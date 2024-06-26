//
//  IntroCoordinator.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit

protocol IntroRouterManageable: BaseCoordinator {
}

final public class IntroCoordinator: IntroRouterManageable {
    
    weak private var navigationController: UINavigationController?
    private var dependencies: IntroDepedencies
    
    init(
        navigationController: UINavigationController?,
        dependencies: IntroDepedencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func makePermissionRouterActions(
    ) -> PermissionRouterActions {
        
        return .init()
    }
    
    func start() {
        let permissionViewController = dependencies.makePermissionView(
            actions: makePermissionRouterActions()
        )
        
        navigationController?.pushViewController(permissionViewController, animated: true)
    }
    
}
