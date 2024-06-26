//
//  RootCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol RouterManageable {
    func showPermissionView()
    
    func startIntroFlow()
    
    func startMainFlow()
}

final public class RootCoordinator: RouterManageable {

    private var childCoordinators: [BaseCoordinator] = []
    private var navigationController: UINavigationController
    private let dependencies: AppDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: AppDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
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
        // childCoordinators.append(introCoordinator)
    }
}
