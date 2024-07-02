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
    
    var makePermissionInteractorCallCount = 0
    func makePermissionInteractor(
    ) -> PermissionInteractorProtocol {
        makePermissionInteractorCallCount += 1
        return PermissionInteractor(
            dataRepository: makeDataRepository(),
            recordRepository: makeRecordRepository()
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
    
    // MARK: - OnboardingModule

    var makeOnboardingInteractorCallCount = 0
    func makeOnboardingInteractor(
    ) -> OnboardingInteractorProtocol {
        makeOnboardingInteractorCallCount += 1
        return OnboardingInteractor(
            dataRepository: makeDataRepository()
        )
    }
    
    var makeOnboardingRouterCallCount = 0
    func makeOnboardingRouter(
        actions: OnboardingRouterActions
    ) -> OnboardingRouterProtocol {
        makeOnboardingRouterCallCount += 1
        return OnboardingRouter(
            actions: actions
        )
    }
    
    var makeOnboardingPresenterCallCount = 0
    func makeOnboardingPresenter(
        actions: OnboardingRouterActions
    ) -> OnboardingPresenterProtocol {
        makeOnboardingPresenterCallCount += 1
        return OnboardingPresenter(
            interactor: makeOnboardingInteractor(),
            router: makeOnboardingRouter(actions: actions)
        )
    }
    
    var makeOnboardingViewCallCount = 0
    func makeOnboardingView(
        actions: OnboardingRouterActions
    ) -> OnboardingViewController {
        makeOnboardingViewCallCount += 1
        return OnboardingViewController(
            presenter: makeOnboardingPresenter(actions: actions)
        )
    }
}

