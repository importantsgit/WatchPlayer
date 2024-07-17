//
//  PlayerPresenterMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import Foundation
import RxRelay
import RxSwift
import Photos


final class PlayerPresenterMock: PlayerPresenterProtocol {
    
    let router: PlayerRouterProtocol
    let interactor: PlayerInteractorProtocol
    let asset: PHAsset
    
    var playerTitle = PublishRelay<String>()
    var didLoadPlayer = PublishRelay<Void>()

    let hideControllerDelay = PublishSubject<Void>()
    let hideControllerImmediately = PublishSubject<Void>()
    let showController = PublishRelay<Void>()
    let showAudioController = PublishRelay<Bool>()
    let showSettingView = PublishRelay<Bool>()
    let showSettingPopup = PublishRelay<Bool>()
    
    let setLayout = PublishRelay<LayoutStyle>()
    
    weak var playerView: PlayerViewProtocol?
    weak var controllerView: PlayerControllerViewProtocol?
    weak var audioControllerView: PlayerAudioControllerViewProtocol?
    weak var settingView: PlayerSettingViewProtocol?
    weak var settingPopup: PlayerSettingViewProtocol?
    
    init(
        router: PlayerRouterProtocol,
        interactor: PlayerInteractorProtocol,
        asset: PHAsset
    ) {
        self.router = router
        self.interactor = interactor
        self.asset = asset
    }
    
    var viewDidLoadCallCount = 0
    func viewDidLoad() {
        viewDidLoadCallCount += 1
    }
    
    var backButtonTappedCallCount = 0
    func backButtonTapped() {
        backButtonTappedCallCount += 1
    }
    
    var deleteButtonTappedCallCount = 0
    func deleteButtonTapped() {
        deleteButtonTappedCallCount += 1
    }
    
    
    var handlePlayerEvent = 0
    var playerEventPlayerTapped = 0
    
    var handleControllerEvent = 0
    var controllerEventBackButtonTapped = 0
    var controllerEventControllerTapped = 0
    var controllerEventPlayButtonTapped = 0
    var controllerEventRotationButtonTapped = 0
    var controllerEventSettingButtonTapped = 0
    var controllerEventShowAudioButtonTapped = 0
    var controllerEventRewindButtonTapped = 0
    var controllerEventForwardButtonTapped = 0
    
    var handleAudioControllerEvent = 0
    var AudioControllerEventBackButtonTapped = 0
    var audioControllerEventDismissAudioButtonTapped = 0
    var audioControllerEventPlayButtonTapped = 0
}

extension PlayerPresenterMock: PlayerProtocol {
    
    func handleEvent(_ event: PlayerEvent) -> Any? {
        handlePlayerEvent += 1
        switch event {
        case .playerTapped:
            playerEventPlayerTapped += 1
            break
        }
        return nil
    }
}

extension PlayerPresenterMock: PlayerControllerProtocol {
    
    func handleEvent(_ event: ControllerEvent) -> Any? {
        handleControllerEvent += 1
        switch event {
        case .backButtonTapped:
            controllerEventBackButtonTapped += 1
            break
            
        case .controllerTapped:
            controllerEventControllerTapped += 1
            break
            
        case .playButtonTapped:
            controllerEventPlayButtonTapped += 1
            break
            
        case .rotationButtonTapped:
            controllerEventRotationButtonTapped += 1
            break
            
        case .settingButtonTapped:
            controllerEventSettingButtonTapped += 1
            break
            
        case .showAudioButtonTapped:
            controllerEventShowAudioButtonTapped += 1
            break
            
        case .rewindButtonTapped:
            controllerEventRewindButtonTapped += 1
            break
            
        case .forwardButtonTapped:
            controllerEventForwardButtonTapped += 1
            break
        }
        return nil
    }
}

extension PlayerPresenterMock: PlayerAudioControllerProtocol {

    func handleEvent(_ event: AudioControllerEvent) -> Any? {
        handleAudioControllerEvent += 1
        switch event {
        case .backButtonTapped:
            AudioControllerEventBackButtonTapped += 1
            break
            
        case .dismissAudioButtonTapped:
            audioControllerEventDismissAudioButtonTapped += 1
            break
            
        case .playButtonTapped:
            audioControllerEventPlayButtonTapped += 1
            break
            
        }
        return nil
    }
    
    
}

extension PlayerPresenterMock: PlayerSettingProtocol {

    @discardableResult
    func handleEvent(_ event: SettingEvent) -> Any? {
        switch event {
        case .updateGravity(let index):
            break
        case .updateQuality(let index):
            break
        case .updateSpeed(let index):
            break
        case .closeView:
            break
        }
        return nil
    }

}
