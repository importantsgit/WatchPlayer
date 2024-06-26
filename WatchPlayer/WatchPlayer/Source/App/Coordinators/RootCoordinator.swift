//
//  RootCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol RouterManageable {
    func showPermissionView()
    
    func showIntroView()
    
    func startMainFlow()
}

final public class RootCoordinator: RouterManageable {
    
    private var navigationController: UINavigationController
    private let dependencies: AppDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: AppDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func showPermissionView(
    ) {
        
    }
    
    func showIntroView(
    ) {
        
    }
    
    func startMainFlow(
    ) {
        let mainDependencies = dependencies.makeMainDependencies()
        
        
    }
}
