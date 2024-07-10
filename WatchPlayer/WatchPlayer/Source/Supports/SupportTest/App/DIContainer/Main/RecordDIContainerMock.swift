//
//  RecordDIContainerMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit

final public class RecordDIContainerMock: RecordDIContainerProtocol, RecordDependencies {

    
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
    
    var makeTranslationRepositoryCallCount = 0
    func makeTranslationRepository(
    ) -> TranslationRepositoryInterface {
        makeTranslationRepositoryCallCount += 1
        return TranslationRepository(
            translationService: dependencies.translationService
        )
    }
    
    var makeDataRepositoryCallCount = 0
    func makeDataRepository(
    ) -> DataRepositoryInterface {
        makeDataRepositoryCallCount += 1
        return DataRepository(
            dataService: dependencies.dataService
        )
    }
    var  makeRecordRepositoryCallCount = 0
    func makeRecordRepository(
    ) -> RecordRepositoryInterface {
        makeRecordRepositoryCallCount += 1
        return RecordRepository(
            recordService: dependencies.recordService
        )
    }
    
    // MARK: - RecordModule
    
    var makeRecordModuleCallCount = 0
    func makeRecordModule(
        navigationController: UINavigationController?,
        actions: RecordRouterActions
    ) -> RecordViewController {
        makeRecordModuleCallCount += 1
        
        let router = RecordRouter(navigationController: navigationController, actions: actions)
        let interactor = RecordInteractor()
        let presenter = RecordPresenter(router: router, interactor: interactor)
        let viewController = RecordViewController(presenter: presenter)
        
        return viewController
    }

}
