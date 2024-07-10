//
//  RecordDIContainer.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit

protocol RecordDIContainerProtocol {
    func makeRecordCoordinator(
        navigationController: UINavigationController?
    ) -> RecordCoordinator
}

protocol RecordDependencies {
    func makeRecordModule(
        navigationController: UINavigationController?,
        actions: RecordRouterActions
    ) -> RecordViewController
}

final public class RecordDIContainer: RecordDIContainerProtocol, RecordDependencies {
    
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
    
    func makeRecordCoordinator(
        navigationController: UINavigationController?
    ) -> RecordCoordinator {
        .init(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    
    // MARK: - Repository
    
    func makeTranslationRepository(
    ) -> TranslationRepositoryInterface {
        TranslationRepository(
            translationService: dependencies.translationService
        )
    }
    
    func makeDataRepository(
    ) -> DataRepositoryInterface {
        DataRepository(
            dataService: dependencies.dataService
        )
    }
    
    func makeRecordRepository(
    ) -> RecordRepositoryInterface {
        RecordRepository(
            recordService: dependencies.recordService
        )
    }
    
    // MARK: - RecordModule
    
    func makeRecordModule(
        navigationController: UINavigationController?,
        actions: RecordRouterActions
    ) -> RecordViewController {
        let router = RecordRouter(
            navigationController: navigationController,
            actions: actions
        )
        
        let interactor = RecordInteractor()
        
        let presenter = RecordPresenter(
            router: router,
            interactor: interactor
        )
        
        let viewController = RecordViewController(presenter: presenter)
        
        return viewController
    }

}
