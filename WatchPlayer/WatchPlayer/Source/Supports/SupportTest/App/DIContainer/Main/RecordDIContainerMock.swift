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
    
    var makeRecordInteractorCallCount = 0
    func makeRecordInteractor(
    ) -> RecordInteractorProtocol {
        makeRecordInteractorCallCount += 1
        return RecordInteractor()
    }
    
    var makeRecordRouterCallCount = 0
    func makeRecordRouter(
        actions: RecordRouterActions
    ) -> RecordRouterProtocol {
        makeRecordRouterCallCount += 1
        return RecordRouter(
            actions: actions
        )
    }
    
    var makeRecordPresenterCallCount = 0
    func makeRecordPresenter(
        actions: RecordRouterActions
    ) -> RecordPresenterProtocol {
        makeRecordPresenterCallCount += 1
        return RecordPresenter(
            router: makeRecordRouter(actions: actions),
            interactor: makeRecordInteractor()
        )
    }
    
    var makeRecordViewControllerCallCount = 0
    func makeRecordViewController(
        actions: RecordRouterActions
    ) -> RecordViewController {
        makeRecordViewControllerCallCount += 1
        return .init(
            presenter: makeRecordPresenter(
                actions: actions
            )
        )
    }
}
