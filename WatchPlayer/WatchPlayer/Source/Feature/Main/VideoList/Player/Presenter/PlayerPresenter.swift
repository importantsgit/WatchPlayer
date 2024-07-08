//
//  PlayerPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import Foundation
import RxRelay
import RxSwift
import Photos

protocol PlayerProtocol: AnyObject {
    @discardableResult
    func handleEvent(_ event: PlayerEvent) -> Any?
}

protocol PlayerControllerProtocol: AnyObject {
    @discardableResult
    func handleEvent(_ event: ControllerEvent) -> Any?
}

protocol PlayerAudioControllerProtocol: AnyObject {
    @discardableResult
    func handleEvent(_ event: AudioControllerEvent) -> Any?
}

protocol PlayerSettingProtocol: AnyObject {
    @discardableResult
    func handleEvent(_ event: SettingEvent) -> Any?
}

protocol PlayerPresenterProtocolInput {
    func viewDidLoad()
    func backButtonTapped()
}

protocol PlayerPresenterProtocolOutput {
    var playerTitle: PublishRelay<String> { get }
    var didLoad: PublishRelay<Void> { get }

    var hideControllerDelay: PublishSubject<Void> { get }
    var hideControllerImmediately: PublishSubject<Void> { get }
    var showController: PublishRelay<Void> { get }
    var showAudioController: PublishRelay<Bool> { get }
    var showSettingView: PublishRelay<Bool> { get }
    
    var setLayout: PublishRelay<LayoutStyle> { get }
}

typealias PlayerPresenterProtocol = PlayerPresenterProtocolInput & PlayerPresenterProtocolOutput

final class PlayerPresenter: NSObject, PlayerPresenterProtocol {
    
    let router: PlayerRouterProtocol
    let interactor: PlayerInteractorProtocol
    let asset: PHAsset
    
    // MARK: - PlayerView, Controller Binding with Handler
    weak var playerView: PlayerViewProtocol?
    weak var controllerView: PlayerControllerViewProtocol?
    weak var audioControllerView: PlayerAudioControllerViewProtocol?
    weak var settingView: PlayerSettingViewProtocol?
    
    // MARK: - PlayerViewController Binding with RxSwift
    let playerTitle = PublishRelay<String>()
    
    let didLoad = PublishRelay<Void>()
    
    let hideControllerDelay = PublishSubject<Void>()
    let hideControllerImmediately = PublishSubject<Void>()
    let showController = PublishRelay<Void>()
    
    let showAudioController = PublishRelay<Bool>()
    private var isShowSettingView = false
    let showSettingView = PublishRelay<Bool>()
    let setLayout = PublishRelay<LayoutStyle>()
    
    let disposeBag = DisposeBag()
    
    init(
        router: PlayerRouterProtocol,
        interactor: PlayerInteractorProtocol,
        asset: PHAsset
    ) {
        self.router = router
        self.interactor = interactor
        self.asset = asset
        
    }
    
    func viewDidLoad() {
        
        Task {
            do {
                playerTitle.accept(asset.creationDate?.getDateString() ?? Date.getCurrentDateString())
                let item = try await requestAVPlayerItem(asset)
            
                let player = AVPlayer(playerItem: item)
                let playerLayer = AVPlayerLayer(player: player)
                playerView?.handleEvent(.set(playerLayer: playerLayer))
                didLoad.accept(())
                
                let getServiceEvent = interactor.set(player: player)
                getServiceEvent
                    .subscribe(onNext: { [weak self] (event, param) in
                        switch event {
                        case .didPlayToEndTime:
                            self?.controllerView?.handleEvent(.updatePlayButton(state: .ended))
                            self?.audioControllerView?.handleEvent(.updatePlayButton(state: .ended))
                            
                        case .setTimes:
                            guard let times = param as? (CMTime?, CMTime?),
                                  let current = times.0,
                                  let duration = times.1
                            else { return }
                            self?.controllerView?.handleEvent(.updateTime(current: current, duration: duration))
                        }
                    })
                    .disposed(by: disposeBag)
            }
            catch {
                print(error)
            }
        }
    
    }
        
    private func requestAVPlayerItem(
        _ asset: PHAsset
    ) async throws -> AVPlayerItem {
        
        return try await withCheckedThrowingContinuation { continuation in
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .automatic
            
            // MARK: - 클라우드에서 받는 경우도 있기에 true로 해야 item != nil
            options.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestPlayerItem(
                forVideo: asset,
                options: options
            ) { item, info in
                if let error = info?["PHImageErrorKey"] as? Error {
                    continuation.resume(throwing: error)
                }
                guard let item = item
                        // FIXME: 에러 처리
                else {
                    continuation.resume(throwing: AssetError.invaild)
                    return
                }
                continuation.resume(returning: item)
            }
        }
    }
    
    func backButtonTapped() {
        interactor.handleEvent(.backButtonTapped)
        router.backButtonTapped()
        AppDelegate.orientationLock = .portrait
    }
    
    func showControllerView() {
        showController.accept(())
        hideControllerDelay.onNext(())
    }
    
    func updateToPortrait() {
        guard AppDelegate.orientationLock == .landscape
        else { return }
        
        AppDelegate.orientationLock = .portrait
        setLayout.accept(.portrait)
        controllerView?.handleEvent(.updateLayout(style: .portrait))
        audioControllerView?.handleEvent(.updateLayout(style: .portrait))
    }
    
    func updateToLandscape() {
        guard AppDelegate.orientationLock == .portrait
        else { return }
        
        AppDelegate.orientationLock = .landscape
        setLayout.accept(.landscape)
        controllerView?.handleEvent(.updateLayout(style: .landscape))
        audioControllerView?.handleEvent(.updateLayout(style: .landscape))
    }
}

extension PlayerPresenter: PlayerProtocol {
    
    // 플레이어 뷰에서 입력된 이벤트
    func handleEvent(_ event: PlayerEvent) -> Any? {
        switch event {
        case .playerTapped:
            if isShowSettingView {
                isShowSettingView = false
                showSettingView.accept(isShowSettingView)
                settingView?.handleEvent(.reset)
            }
            else {
                showControllerView()
            }
        }
        
        return nil
    }
    
}

extension PlayerPresenter: PlayerControllerProtocol {
    
    // 컨트롤러에서 입력된 이벤트
    @discardableResult
    func handleEvent(_ event: ControllerEvent) -> Any? {
        switch event {
        case .controllerTapped:
            print("controllerTapped")
            hideControllerImmediately.onNext(())
            
        case .backButtonTapped:
            updateToPortrait()
            
        case .playButtonTapped:
            hideControllerDelay.onNext(())
            return interactor.handleEvent(.playButtonTapped)
            
        case .showAudioButtonTapped:
            interactor.handleEvent(.audioButtonTapped(isUse: true))
            playerView?.handleEvent(.update(player: nil))
            showAudioController.accept(true)
            hideControllerImmediately.onNext(())
            
        case .settingButtonTapped:
            isShowSettingView = true
            
            if AppDelegate.orientationLock == .landscape {
                showSettingView.accept(isShowSettingView)
            }
            //TODO: 세로뷰일 때, 팝업 뜨게
            hideControllerImmediately.onNext(())
            
        case .rotationButtonTapped:
            // 가로일 때, 세로로 전환 / 세로일 때, 가로로 전환
            AppDelegate.orientationLock == .landscape ? updateToPortrait() : updateToLandscape()
                
        }
        
        return nil
    }
}

extension PlayerPresenter: PlayerAudioControllerProtocol {
    
    // 오디오 컨트롤러에서 입력된 이벤트
    @discardableResult
    func handleEvent(_ event: AudioControllerEvent) -> Any? {
        switch event {
        case .dismissAudioButtonTapped:
            guard let player = interactor.handleEvent(.audioButtonTapped(isUse: false)) as? AVPlayer
            else {
                fatalError()
            }
            playerView?.handleEvent(.update(player: player))
            showAudioController.accept(false)
            showControllerView()
            
        case .backButtonTapped:
            updateToPortrait()
            
        case .playButtonTapped:
            return interactor.handleEvent(.playButtonTapped)
        }
        
        return nil
    }
}

extension PlayerPresenter: PlayerSettingProtocol {
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
            isShowSettingView = false
            showSettingView.accept(isShowSettingView)
        }
        return nil
    }
}

enum AssetError: Error {
    case invaild
}
