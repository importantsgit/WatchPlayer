//
//  IntroDIContainerMock.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit

final public class IntroDIContainerMock: IntroDIContainerProtocol, IntroDepedencies {
    
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
    
    var makeIntroCoordinatorCallCount = 0
    func makeIntroCoordinator(
        navigationController: UINavigationController?
    ) -> IntroCoordinator {
        makeIntroCoordinatorCallCount += 1
        return .init(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
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
    
    // MARK: - PermissionModule
    
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
    
    // MARK: - GuideModule
    
    var makeGuideRouterCallCount = 0
    func makeGuideRouter(
        actions: GuideRouterActions
    ) -> GuideRouterProtocol {
        makeGuideRouterCallCount += 1
        return GuideRouter(
            actions: actions
        )
    }
    
    var makeGuideInteractorCallCount = 0
    func makeGuideInteractor(
    ) -> GuideInteractorProtocol {
        makeGuideInteractorCallCount += 1
        return GuideInteractor(
            dataRepository: makeDataRepository()
        )
    }
    
    var makeGuidePresenterCallCount = 0
    func makeGuidePresenter(
        actions: GuideRouterActions
    ) -> GuidePresenterProtocol {
        makeGuidePresenterCallCount += 1
        return GuidePersenter(
            interactor: makeGuideInteractor(),
            router: makeGuideRouter(actions: actions)
        )
    }
    
    var makeGuideViewCallCount = 0
    func makeGuideView(
        actions: GuideRouterActions
    ) -> GuideViewController {
        makeGuideViewCallCount += 1
        return GuideViewController(
            presenter: makeGuidePresenter(actions: actions)
        )
    }
}

