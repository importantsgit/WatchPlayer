//
//  RootCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol RouterManageable: NodeCoordinator {
    func startIntroFlow()
    func startMainFlow()
}

final public class RootCoordinator: RouterManageable {
    var childCoordinators: [BaseCoordinator] = []
    private var navigationController: UINavigationController
    private let dependencies: AppDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: AppDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let isShowPermissionView = dependencies.dataService.isShowPermissionView
        let isShowGuideView = dependencies.dataService.isShowGuideView
        
        if isShowPermissionView || isShowGuideView {
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
            navigationController: navigationController
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
