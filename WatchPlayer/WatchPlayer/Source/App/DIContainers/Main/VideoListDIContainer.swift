//
//  VideoListDIContainer.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit
import Photos

protocol VideoListDIContainerProtocol {
    func makeVideoListCoordinator(
        navigationController: UINavigationController?
    ) -> VideoListCoordinator
}

protocol VideoListDependencies {
    func makeVideoListModule(
        navigationController: UINavigationController?,
        actions: VideoListRouterActions
    ) -> VideoListViewController
    
    func makePlayerModule(
        navigationController: UINavigationController?,
        actions: PlayerRouterActions,
        asset: PHAsset
    ) -> PlayerViewController
}

final public class VideoListDIContainer: VideoListDIContainerProtocol, VideoListDependencies {

    struct Dependencies {
        let translationService: TranslationServiceInterface
        let dataService: DataServiceInterface
        let recordService: RecordServiceInterface
        let libraryService: LibraryServiceInterface
        let playerService: PlayerServiceInterface
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
    
    func makeLibraryRepository(
    ) -> LibraryRepositoryInterface {
        LibraryRepository(
            libraryService: dependencies.libraryService
        )
    }
    
    func makePlayerRepository(
    ) -> PlayerRepositoryInterface {
        PlayerRepository(
            playerService: dependencies.playerService
        )
    }
    
    // MARK: - VideoListModule
    
    func makeVideoListModule(
        navigationController: UINavigationController?,
        actions: VideoListRouterActions
    ) -> VideoListViewController {
        
        let router = VideoListRouter(
            navigationController: navigationController,
            actions: actions
        )
        
        let interactor = VideoListInteractor(
            libraryRepository: makeLibraryRepository()
        )
        
        let presenter = VideoListPresenter(
            router: router,
            interactor: interactor
        )
        
        return .init(presenter: presenter)
    }
    
    // MARK: - PlayerModule
    
    func makePlayerModule(
        navigationController: UINavigationController?,
        actions: PlayerRouterActions,
        asset: PHAsset
    ) -> PlayerViewController {
        
        let router = PlayerRouter(
            navigationController: navigationController,
            actions: actions
        )
        
        let interactor = PlayerInteractor(
            libraryRepository: makeLibraryRepository(),
            playerRepository: makePlayerRepository(),
            dataRepository: makeDataRepository()
        )
        
        let presenter = PlayerPresenter(
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
        
        let playerViewController = PlayerViewController(
            presenter: presenter,
            playerView: playerView,
            controllerView: controllerView,
            audioControllerView: audioControllerView,
            settingView: settingView,
            settingPopup: settingPopup
        )
        
        presenter.playerViewController = playerViewController
        
        return playerViewController
    }
}


