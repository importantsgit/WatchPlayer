//
//  SettingDIContainer.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit

protocol SettingDIContainerProtocol {
    func makeSettingCoordinator(
        navigationController: UINavigationController?
    ) -> SettingCoordinator
}

protocol SettingDependencies {
    func makeSettingViewController(
        actions: SettingRouterActions
    ) -> SettingViewController
}

final public class SettingDIContainer: SettingDIContainerProtocol, SettingDependencies {
    
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
    
    func makeSettingCoordinator(
        navigationController: UINavigationController?
    ) -> SettingCoordinator {
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
    
    // MARK: - SettingModule
    
    func makeSettingRouter(
        actions: SettingRouterActions
    ) -> SettingRouterProtocol {
        SettingRouter(actions: actions)
    }
    
    func makeSettingInteractor(
    ) -> SettingInteractorProtocol {
        SettingInteractor()
    }
    
    func makeSettingPresenter(
        actions: SettingRouterActions
    ) -> SettingPresenterProtocol {
        SettingPresenter(
            router: makeSettingRouter(actions: actions),
            interactor: makeSettingInteractor()
        )
    }
    
    func makeSettingViewController(
        actions: SettingRouterActions
    ) -> SettingViewController {
        SettingViewController(
            presenter: makeSettingPresenter(actions: actions)
        )
    }
}
