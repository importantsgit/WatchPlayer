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
    
    func makePermissionModule(
        navigationController: UINavigationController?,
        actions: PermissionRouterActions
    ) -> PermissionViewController
    
    func makeOnboardModule(
        navigationController: UINavigationController?,
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
    
    func makePermissionModule(
        navigationController: UINavigationController?,
        actions: PermissionRouterActions
    ) -> PermissionViewController {
        let router = PermissionRouter(
            navigationController: navigationController,
            actions: actions
        )
        
        let interactor = PermissionInteractor(
            dataRepository: makeDataRepository(), 
            recordRepository: makeRecordRepository()
        )
        
        let presenter = PermissionPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewContoller = PermissionViewController(presenter: presenter)
        
        return viewContoller
    }
    
    
    // MARK: - OnboardingModule
    
    func makeOnboardModule(
        navigationController: UINavigationController?,
        actions: OnboardingRouterActions
    ) -> OnboardingViewController {
        let router = OnboardingRouter(
            navigationController: navigationController,
            actions: actions
        )
        
        let interactor = OnboardingInteractor(
            dataRepository: makeDataRepository()
        )
        
        let presenter = OnboardingPresenter(
            interactor: interactor,
            router: router
        )
        
        let viewContoller = OnboardingViewController(presenter: presenter)
        
        return viewContoller
    }
}
