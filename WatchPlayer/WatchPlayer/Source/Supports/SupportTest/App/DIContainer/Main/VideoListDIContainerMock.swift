//
//  VideoListDIContainerMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit
import Photos

final public class VideoListDIContainerMock: VideoListDIContainerProtocol, VideoListDependencies {
    
    struct Dependencies {
        let translationService: TranslationServiceMock
        let dataService: DataServiceMock
        let recordService: RecordServiceMock
        let libraryService: LibraryServiceMock
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
        return TranslationRepositoryMock(
            translationService: dependencies.translationService
        )
    }
    
    var makeDataRepositoryCallCount = 0
    func makeDataRepository(
    ) -> DataRepositoryInterface {
        makeDataRepositoryCallCount += 1
        return DataRepositoryMock(
            dataService: dependencies.dataService
        )
    }
    
    var  makeRecordRepositoryCallCount = 0
    func makeRecordRepository(
    ) -> RecordRepositoryInterface {
        makeRecordRepositoryCallCount += 1
        return RecordRepositoryMock(
            recordService: dependencies.recordService
        )
    }
    
    var makeLibraryRepositoryCallCount = 0
    func makeLibraryRepository(
    ) -> LibraryRepositoryInterface {
        makeLibraryRepositoryCallCount += 1
        return LibraryRepositoryMock(
            libraryService: dependencies.libraryService
        )
    }
    
    // MARK: - VideoListModule
    
    var makeVideoListInteractorCallCount = 0
    func makeVideoListInteractor(
    ) -> VideoListInteractorProtocol {
        makeVideoListInteractorCallCount += 1
        return VideoListInteractor(
            libraryRepository: makeLibraryRepository()
        )
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
    
    // MARK: - PlayerModule
    
    var  makePlayerInteractorCallCout = 0
    func makePlayerInteractor(
    ) -> PlayerInteractorProtocol {
        makePlayerInteractorCallCout += 1
        return PlayerInteractor()
    }
    
    var makePlayerRouterCallCount = 0
    func makePlayerRouter(
        actions: PlayerRouterActions
    ) -> PlayerRouterProtocol {
        makePlayerRouterCallCount += 1
        return PlayerRouter(actions: actions)
    }
    
    var  makePlayerPresenterCallCount = 0
    func makePlayerPresenter(
        actions: PlayerRouterActions,
        asset: PHAsset
    ) -> PlayerPresenterProtocol {
        makePlayerPresenterCallCount += 1
        return PlayerPresenter(
            router: makePlayerRouter(actions: actions),
            interactor: makePlayerInteractor(),
            asset: asset
        )
    }
    
    var makePlayerViewControllerCallCount = 0
    func makePlayerViewController(
        actions: PlayerRouterActions,
        asset: PHAsset
    ) -> PlayerViewController {
        makePlayerViewControllerCallCount += 1
        return .init(
            presenter: makePlayerPresenter(
                actions: actions,
                asset: asset
            )
        )
    }
}
