//
//  MainDIContainer.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol MainDIContainerProtocol {
    func makeMainCoordinator(
        navigationController: UINavigationController?
    ) -> MainCoordinator
}

protocol MainDependencies {
    
}

final public class MainDIContainer: MainDIContainerProtocol, MainDependencies {

    struct Dependencies {
        let translationService: TranslationServiceInterface
        let dataService: DataServiceInterface
        let recordService: RecordServiceInterface
    }
    
    let dependencies: Dependencies
    
    init(
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
    }
    
    func makeMainCoordinator(
        navigationController: UINavigationController?
    ) -> MainCoordinator {
        .init(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
}
