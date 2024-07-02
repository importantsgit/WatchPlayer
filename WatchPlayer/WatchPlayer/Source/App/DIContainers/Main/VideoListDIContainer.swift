//
//  VideoListDIContainer.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit

protocol VideoListDIContainerProtocol {
    func makeVideoListCoordinator(
        navigationController: UINavigationController?
    ) -> VideoListCoordinator
}

protocol VideoListDependencies {
    func makeVideoListViewController(
        actions: VideoListRouterActions
    ) -> VideoListViewController
}

final public class VideoListDIContainer: VideoListDIContainerProtocol, VideoListDependencies {

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
    
    func makeVideoListCoordinator(
        navigationController: UINavigationController?
    ) -> VideoListCoordinator {
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
    
    // MARK: - VideoListModule
    
    func makeVideoListInteractor(
    ) -> VideoListInteractorProtocol {
        VideoListInteractor()
    }
    
    func makeVideoListRouter(
        actions: VideoListRouterActions
    ) -> VideoListRouterProtocol {
        VideoListRouter(
            actions: actions
        )
    }
    
    func makeVideoListPresenter(
        actions: VideoListRouterActions
    ) -> VideoListPresenterProtocol {
        VideoListPresenter(
            router: makeVideoListRouter(actions: actions),
            interactor: makeVideoListInteractor()
        )
    }
    
    func makeVideoListViewController(
        actions: VideoListRouterActions
    ) -> VideoListViewController {
        .init(
            presenter: makeVideoListPresenter(
                actions: actions
            )
        )
    }
}


