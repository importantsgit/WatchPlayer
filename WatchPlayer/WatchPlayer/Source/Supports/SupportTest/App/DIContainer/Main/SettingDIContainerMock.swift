//
//  SettingDIContainerMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit

final public class SettingDIContainerMock: SettingDIContainerProtocol, SettingDependencies {
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
    
    var makeSettingCoordinatorCallCount = 0
    func makeSettingCoordinator(
        navigationController: UINavigationController?
    ) -> SettingCoordinator {
        makeSettingCoordinatorCallCount += 1
        return .init(
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
    
    // MARK: - SettingModule
    
    var makeSettingRouterCallCount = 0
    func makeSettingRouter(
        actions: SettingRouterActions
    ) -> SettingRouterProtocol {
        makeSettingRouterCallCount += 1
        return SettingRouter(actions: actions)
    }
    
    var makeSettingInteractorCallCount = 0
    func makeSettingInteractor(
    ) -> SettingInteractorProtocol {
        makeSettingInteractorCallCount += 1
        return SettingInteractor()
    }
    
    var makeSettingPresenterCallCount = 0
    func makeSettingPresenter(
        actions: SettingRouterActions
    ) -> SettingPresenterProtocol {
        makeSettingPresenterCallCount += 1
        return SettingPresenter(
            router: makeSettingRouter(actions: actions),
            interactor: makeSettingInteractor()
        )
    }
    
    var makeSettingViewControllerCallCount = 0
    func makeSettingViewController(
        actions: SettingRouterActions
    ) -> SettingViewController {
        makeSettingViewControllerCallCount += 1
        return SettingViewController(
            presenter: makeSettingPresenter(actions: actions)
        )
    }
}
