//
//  IntroDIContainer.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit

protocol IntroDepedencies {
    func makePermissionView(
        actions: PermissionRouterActions
    ) -> PermissionViewController
    
    func makeGuideView(
        actions: GuideRouterActions
    ) -> GuideViewController
}

final public class IntroDIContainer: IntroDepedencies {
    
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
    
    func makeIntroCoordinator(
        navigationController: UINavigationController?
    ) -> IntroCoordinator {
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
    
    // MARK: - PermissionModule
    
    func makePermissionInteractor(
    ) -> PermissionInteractorProtocol {
        PermissionInteractor(
            dataRepository: makeDataRepository()
        )
    }
    
    func makePermissionRouter(
        actions: PermissionRouterActions
    ) -> PermissionRouterProtocol {
        PermissionRouter(actions: actions)
    }
    
    func makePermissionPresenter(
        actions: PermissionRouterActions
    ) -> PermissionPresenterProtocol {
        PermissionPresenter(
            interator: makePermissionInteractor(),
            router: makePermissionRouter(actions: actions)
        )
    }
    
    func makePermissionView(
        actions: PermissionRouterActions
    ) -> PermissionViewController {
        PermissionViewController(
            presenter: makePermissionPresenter(actions: actions)
        )
    }
    
    // MARK: - GuideModule
    
    func makeGuideRouter(
        actions: GuideRouterActions
    ) -> GuideRouterProtocol {
        GuideRouter(
            actions: actions
        )
    }
    
    func makeGuideInteractor(
    ) -> GuideInteractorProtocol {
        GuideInteractor(
            dataRepository: makeDataRepository()
        )
    }
    
    func makeGuidePresenter(
        actions: GuideRouterActions
    ) -> GuidePresenterProtocol {
        GuidePersenter(
            interactor: makeGuideInteractor(),
            router: makeGuideRouter(actions: actions)
        )
    }
    
    func makeGuideView(
        actions: GuideRouterActions
    ) -> GuideViewController {
        GuideViewController(
            presenter: makeGuidePresenter(actions: actions)
        )
    }
}
