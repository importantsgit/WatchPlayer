//
//  IntroCoordinator.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit
import RxSwift
import RxRelay

protocol IntroRouterManageable: LeafCoordinator {
    var navigationController: UINavigationController? { get }
    var rootViewController: UIViewController? { get }
}

struct IntroCoordinatorActions: CoordinatorActionsProtocol {
    let finishFlow: PublishRelay<Void>
}

final public class IntroCoordinator: IntroRouterManageable {
    
    weak public private(set) var navigationController: UINavigationController?
    weak public private(set) var rootViewController: UIViewController?
    private let dependencies: IntroDepedencies
    private let actions: IntroCoordinatorActions
    var disposeBag = DisposeBag()
    
    init(
        navigationController: UINavigationController?,
        dependencies: IntroDepedencies,
        actions: IntroCoordinatorActions
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.actions = actions
    }
    
    private func makePermissionRouterActions(
    ) -> PermissionRouterActions {
        let showOnboardingView = PublishRelay<Void>()
        showOnboardingView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.showOnboardingView()
            })
            .disposed(by: disposeBag)
        
        return .init(
            showOnboardingView: showOnboardingView
        )
    }
    
    private func makeOnboardingRouterActions(
    ) -> OnboardingRouterActions {
        let finishFlow = PublishRelay<Void>()
        finishFlow
            .subscribe(onNext: { [weak self] in
                self?.actions.finishFlow.accept(())
            })
            .disposed(by: disposeBag)
        
        return .init(
            finishFlow: finishFlow
        )
    }
    
    func start() {
        dependencies.isShowPermissionView() ?
        showPermissionView() :
        showOnboardingView()
    }
    
    func showPermissionView() {
        let permissionViewController = dependencies.makePermissionModule(
            navigationController: navigationController,
            actions: makePermissionRouterActions()
        )
        
        navigationController?.setViewControllers(
            [permissionViewController],
            animated: true
        )
        rootViewController = permissionViewController
    }
    
    func showOnboardingView() {
        let OnboardingViewController = dependencies.makeOnboardModule(
            navigationController: navigationController,
            actions: makeOnboardingRouterActions()
        )
        
        if navigationController?.viewControllers.isEmpty == true {
            navigationController?.setViewControllers(
                [OnboardingViewController],
                animated: true
            )
            
            rootViewController = OnboardingViewController
        }
        else {
            navigationController?.pushViewController(
                OnboardingViewController,
                animated: true
            )
        }
    }
}
