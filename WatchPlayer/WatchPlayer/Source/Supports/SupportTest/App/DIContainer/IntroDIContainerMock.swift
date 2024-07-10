//
//  IntroDIContainerMock.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit
import RxRelay

final public class IntroDIContainerMock: IntroDIContainerProtocol, IntroDepedencies {

    

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
    
    var makeIntroCoordinatorCallCount = 0
    func makeIntroCoordinator(
        navigationController: UINavigationController?,
        actions: IntroCoordinatorActions
    ) -> IntroCoordinator {
        makeIntroCoordinatorCallCount += 1
        return .init(
            navigationController: navigationController,
            dependencies: self, 
            actions: actions
        )
    }
    var isShowPermissionViewCallCount = 0
    func isShowPermissionView(
    ) -> Bool {
        isShowPermissionViewCallCount += 1
        return dependencies.dataService.isShowPermissionView
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
    
    // MARK: - PermissionModule
    
    var makePermissionModuleCallCount = 0
    func makePermissionModule(
        navigationController: UINavigationController?,
        actions: PermissionRouterActions
    ) -> PermissionViewController {
        makePermissionModuleCallCount += 1
        
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
        
        let viewController = PermissionViewController(presenter: presenter)
        
        return viewController
    }
    
    // MARK: - OnboardingModule

    var makeOnboardModuleCallCount = 0
    func makeOnboardModule(
        navigationController: UINavigationController?,
        actions: OnboardingRouterActions
    ) -> OnboardingViewController {
        makeOnboardModuleCallCount += 1
        
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
        
        let viewController = OnboardingViewController(presenter: presenter)
        
        return viewController
    }
}

