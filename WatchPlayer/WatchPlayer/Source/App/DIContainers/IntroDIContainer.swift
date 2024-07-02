//
//  IntroDIContainer.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit

protocol IntroDIContainerProtocol {
    func makeIntroCoordinator(
        navigationController: UINavigationController?,
        actions: IntroCoordinatorActions
    ) -> IntroCoordinator
}

protocol IntroDepedencies {
    
    func makePermissionView (
        actions: PermissionRouterActions
    ) -> PermissionViewController
    
    func makeOnboardingView (
        actions: OnboardingRouterActions
    ) -> OnboardingViewController
    
    func isShowPermissionView (
    ) -> Bool
}

final public class IntroDIContainer: IntroDIContainerProtocol, IntroDepedencies {
    
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
    
    func makeIntroCoordinator(
        navigationController: UINavigationController?,
        actions: IntroCoordinatorActions
    ) -> IntroCoordinator {
        .init(
            navigationController: navigationController,
            dependencies: self,
            actions: actions
        )
    }
    
    func isShowPermissionView(
    ) -> Bool {
        dependencies.dataService.isShowPermissionView
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
    
    // MARK: - PermissionModule
    
    func makePermissionInteractor(
    ) -> PermissionInteractorProtocol {
        PermissionInteractor(
            dataRepository: makeDataRepository(),
            recordRepository: makeRecordRepository()
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
    
    // MARK: - OnboardingModule
    
    func makeOnboardingInteractor(
    ) -> OnboardingInteractorProtocol {
        OnboardingInteractor(
            dataRepository: makeDataRepository()
        )
    }
    
    func makeOnboardingRouter(
        actions: OnboardingRouterActions
    ) -> OnboardingRouterProtocol {
        OnboardingRouter(
            actions: actions
        )
    }
    
    func makeOnboardingPresenter(
        actions: OnboardingRouterActions
    ) -> OnboardingPresenterProtocol {
        OnboardingPresenter(
            interactor: makeOnboardingInteractor(),
            router: makeOnboardingRouter(actions: actions)
        )
    }
    
    func makeOnboardingView(
        actions: OnboardingRouterActions
    ) -> OnboardingViewController {
        OnboardingViewController(
            presenter: makeOnboardingPresenter(actions: actions)
        )
    }
}
