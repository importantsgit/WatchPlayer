//
//  VideoListDIContainerMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit

final public class VideoListDIContainerMock: VideoListDIContainerProtocol, VideoListDependencies {
    
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
    
    var makeVideoListCoordinatorCallCount = 0
    func makeVideoListCoordinator(
        navigationController: UINavigationController?
    ) -> VideoListCoordinator {
        makeVideoListCoordinatorCallCount += 1
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
    
    // MARK: - VideoListModule
    
    var makeVideoListInteractorCallCount = 0
    func makeVideoListInteractor(
    ) -> VideoListInteractorProtocol {
        makeVideoListInteractorCallCount += 1
        return VideoListInteractor()
    }
    
    var makeVideoListRouterCallCount = 0
    func makeVideoListRouter(
        actions: VideoListRouterActions
    ) -> VideoListRouterProtocol {
        makeVideoListRouterCallCount += 1
        return VideoListRouter(
            actions: actions
        )
    }
    
    var makeVideoListPresenterCallCount = 0
    func makeVideoListPresenter(
        actions: VideoListRouterActions
    ) -> VideoListPresenterProtocol {
        makeVideoListPresenterCallCount += 1
        return VideoListPresenter(
            router: makeVideoListRouter(actions: actions),
            interactor: makeVideoListInteractor()
        )
    }
    
    var makeVideoListViewController = 0
    func makeVideoListViewController(
        actions: VideoListRouterActions
    ) -> VideoListViewController {
        makeVideoListViewController += 1
        return .init(
            presenter: makeVideoListPresenter(
                actions: actions
            )
        )
    }
}
