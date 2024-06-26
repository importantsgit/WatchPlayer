//
//  MainCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol MainRouterManageable: BaseCoordinator {
}

final public class MainCoordinator: MainRouterManageable {
    
    private var navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    func start() {}
}
