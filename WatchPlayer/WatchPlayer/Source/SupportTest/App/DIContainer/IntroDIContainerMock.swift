//
//  IntroDIContainerMock.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import Foundation

final public class IntroDIContainerMock: IntroDepedencies {

    struct Dependencies {
        let translationService: TranslationServiceInterface
        let dataService: DataServiceInterface
    }
    
    let dependencies: Dependencies
    
    init(
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
    }
    
    var makeTranslationRepositoryCallCount = 0
    func makeTranslationRepository(
    ) -> TranslationRepositoryInterface {
        TranslationRepository(
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
    
    // PermissionInteractor
    
    var makePermissionInteractorCallCount = 0
    func makePermissionInteractor(
    ) -> PermissionInteractorProtocol {
        makePermissionInteractorCallCount += 1
        return PermissionInteractor(
            dataRepository: makeDataRepository()
        )
    }
    
    var makePermissionRouterCallCount = 0
    func makePermissionRouter(
        actions: PermissionRouterActions
    ) -> PermissionRouterProtocol {
        makePermissionRouterCallCount += 1
        return PermissionRouter(actions: actions)
    }
    
    var makePermissionPresenterCallCount = 0
    func makePermissionPresenter(
        actions: PermissionRouterActions
    ) -> PermissionPresenterProtocol {
        makePermissionPresenterCallCount += 1
        return PermissionPresenter(
            interator: makePermissionInteractor(),
            router: makePermissionRouter(actions: actions)
        )
    }
    
    var makePermissionViewCallCount = 0
    func makePermissionView(
        actions: PermissionRouterActions
    ) -> PermissionViewController {
        makePermissionViewCallCount += 1
        return PermissionViewController(
            presenter: makePermissionPresenter(actions: actions)
        )
    }
}

