//
//  RootCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit
import RxSwift
import RxRelay

protocol RouterManageable: NodeCoordinator {
    func startIntroFlow()
    func startMainFlow()
}

final public class RootCoordinator: RouterManageable {
    var childCoordinators: [BaseCoordinator] = []
    private var navigationController: UINavigationController
    private let dependencies: AppDependencies
    private let disposeBag = DisposeBag()
    
    init(
        navigationController: UINavigationController,
        dependencies: AppDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func makeIntroCoordinatorActions(
    ) -> IntroCoordinatorActions {
        let finishFlow = PublishRelay<Void>()
        finishFlow.subscribe( onNext: { [weak self] in
            self?.startMainFlow()
        })
        .disposed(by: disposeBag)
        
        return .init(finishFlow: finishFlow)
    }
    
    func start() {
        let isShowPermissionView = dependencies.dataService.isShowPermissionView
        let isShowOnboardingView = dependencies.dataService.isShowOnboardingView
        
        if isShowPermissionView || isShowOnboardingView {
            startIntroFlow()
        }
        else {
            startMainFlow()
        }
    }

    func startIntroFlow(
    ) {
        let introDependencies = dependencies.makeIntroDependencies()
        let introCoordinator = introDependencies.makeIntroCoordinator(
            navigationController: navigationController,
            actions: makeIntroCoordinatorActions()
        )
        introCoordinator.start()
        childCoordinators.append(introCoordinator)
    }
    
    func startMainFlow(
    ) {
        let mainDependencies = dependencies.makeMainDependencies()
        let mainCoordinator =  mainDependencies.makeMainCoordinator(
            navigationController: navigationController
        )
        
        mainCoordinator.start()
        childCoordinators.append(mainCoordinator)
    }
}
