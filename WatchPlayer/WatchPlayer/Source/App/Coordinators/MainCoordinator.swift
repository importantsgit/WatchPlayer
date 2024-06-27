//
//  MainCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol MainRouterManageable: NodeCoordinator {
    var navigationController: UINavigationController? { get }
}

final public class MainCoordinator: MainRouterManageable {
    var childCoordinators: [BaseCoordinator] = []
    
    weak public private(set) var navigationController: UINavigationController?
    private let dependencies: MainDependencies
    
    init(
        navigationController: UINavigationController?,
        dependencies: MainDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        
    }
}
