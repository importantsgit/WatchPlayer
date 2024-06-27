//
//  IntroCoordinator.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit

protocol IntroRouterManageable: LeafCoordinator {
    var navigationController: UINavigationController? { get }
}

final public class IntroCoordinator: IntroRouterManageable {
    
    weak public private(set) var navigationController: UINavigationController?
    private let dependencies: IntroDepedencies
    
    init(
        navigationController: UINavigationController?,
        dependencies: IntroDepedencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    private func makePermissionRouterActions(
    ) -> PermissionRouterActions {
        
        return .init()
    }
    
    private func makeGuideRouterActions(
    ) -> GuideRouterActions {
        
        return .init()
    }
    
    func start() {
        let permissionViewController = dependencies.makePermissionView(
            actions: makePermissionRouterActions()
        )
        
        navigationController?.setViewControllers(
            [permissionViewController],
            animated: true
        )
    }
    
    func showGuideView() {
        let guideViewController = dependencies.makeGuideView(
            actions: makeGuideRouterActions()
        )
        
        navigationController?.pushViewController(
            guideViewController,
            animated: true
        )
    }
    
}
