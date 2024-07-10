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
        let playerService: PlayerServiceMock
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
    
    var makePlayerRepositoryCallCount = 0
    func makePlayerRepository(
    ) -> PlayerRepositoryInterface {
        makePlayerRepositoryCallCount += 1
        return PlayerRepositoryMock(
            playerService: dependencies.playerService
        )
    }
    
    // MARK: - VideoListModule
    
    var makeVideoListModuleCallCount = 0
    func makeVideoListModule(
        navigationController: UINavigationController?,
        actions: VideoListRouterActions
    ) -> VideoListViewController {
        makeVideoListModuleCallCount += 1
        let router = VideoListRouter(
            navigationController: navigationController,
            actions: actions
        )
        let interactor = VideoListInteractorMock(libraryRepository: makeLibraryRepository() as! LibraryRepositoryMock)
        let presenter = VideoListPresenter(
            router: router,
            interactor: interactor
        )
        
        return .init(presenter: presenter)
    }
    
    // MARK: - PlayerModule
    
    var makePlayerModuleCallCount = 0
    func makePlayerModule(
        navigationController: UINavigationController?,
        actions: PlayerRouterActions,
        asset: PHAsset
    ) -> PlayerViewController {
        makePlayerModuleCallCount += 1
        let router = PlayerRouterMock(
            navigationController: navigationController,
            actions: actions
        )
        let interactor = PlayerInteractorMock(
            playerRepository: makePlayerRepository() as! PlayerRepositoryMock,
            dataRepository: makeDataRepository() as! DataRepositoryMock
        )
        let presenter = PlayerPresenterMock(
            router: router,
            interactor: interactor,
            asset: asset
        )
        let playerView = PlayerView()
        let controllerView = PlayerControllerView()
        let audioControllerView = PlayerAudioControllerView()
        let settingView = PlayerSettingView()
        let settingPopup = PlayerSettingPopup()
        
        playerView.presenter = presenter
        controllerView.presenter = presenter
        audioControllerView.presenter = presenter
        settingView.presenter = presenter
        settingPopup.presenter = presenter
        
        presenter.playerView = playerView
        presenter.controllerView = controllerView
        presenter.audioControllerView = audioControllerView
        presenter.settingView = settingView
        presenter.settingPopup = settingPopup
        
        return .init(
            presenter: presenter,
            playerView: playerView,
            controllerView: controllerView,
            audioControllerView: audioControllerView,
            settingView: settingView,
            settingPopup: settingPopup
        )
    }
}
