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
}

struct IntroCoordinatorActions: CoordinatorActionsProtocol {
    let finishFlow: PublishRelay<Void>
}

final public class IntroCoordinator: IntroRouterManageable {
    
    weak public private(set) var navigationController: UINavigationController?
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
        // TODO: 권한 페이지 노출 여부
        showPermissionView()
    }
    
    func showPermissionView() {
        let permissionViewController = dependencies.makePermissionView(
            actions: makePermissionRouterActions()
        )
        
        navigationController?.setViewControllers(
            [permissionViewController],
            animated: true
        )
    }
    
    func showOnboardingView() {
        let OnboardingViewController = dependencies.makeOnboardingView(
            actions: makeOnboardingRouterActions()
        )
        
        navigationController?.pushViewController(
            OnboardingViewController,
            animated: true
        )
    }
}
