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

protocol PlayerPresenterProtocolInput {
    func viewDidLoad()
}

protocol PlayerControllerProtocol: AnyObject {
    @discardableResult
    func handleContollerEvent(_ event: SendFromControllerEvent) -> Any?
}

protocol PlayerPresenterProtocolOutput {
    var setAsset: PublishRelay<PHAsset> { get }
    var fetchPlayerLayer: PublishRelay<AVPlayerLayer> { get }
    
    var hideControllerDelay: PublishSubject<Void> { get }
    var hideControllerImmediately: PublishSubject<Void> { get }
    var showController: PublishRelay<Void> { get }
    
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
    
    // MARK: - PlayerViewController Binding with RxSwift
    
    let setAsset = PublishRelay<PHAsset>()
    let fetchPlayerLayer = PublishRelay<AVPlayerLayer>()
    
    let hideControllerDelay = PublishSubject<Void>()
    let hideControllerImmediately = PublishSubject<Void>()
    
    let showController = PublishRelay<Void>()
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
                setAsset.accept(asset)
                let item = try await requestAVPlayerItem(asset)
                let player = AVPlayer(playerItem: item)
                let playerLayer = AVPlayerLayer(player: player)
                fetchPlayerLayer.accept(playerLayer)
                
                let getServiceEvent = interactor.set(player: player)
                getServiceEvent
                    .subscribe(onNext: { [weak self] (event, param) in
                        switch event {
                        case .didPlayToEndTime:
                            self?.controllerView?.handleEvent(.setPlayButton(state: .ended))
                            
                        case .setTimes:
                            guard let times = param as? (CMTime?, CMTime?),
                                  let current = times.0,
                                  let duration = times.1
                            else { return }
                            self?.controllerView?.handleEvent(.setTime(current: current, duration: duration))
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
    
}

extension PlayerPresenter: PlayerControllerProtocol {
    @discardableResult
    func handleContollerEvent(_ event: SendFromControllerEvent) -> Any? {
        switch event {
        case .playViewTapped:
            showController.accept(())
            hideControllerDelay.onNext(())
            
        case .controllerTapped:
            hideControllerImmediately.onNext(())
            
        case .backButtonTapped:
            interactor.handleEvent(.backButtonTapped)
            router.backButtonTapped()
            AppDelegate.orientationLock = .portrait
            
        case .playButtonTapped:
            hideControllerDelay.onNext(())
            return interactor.handleEvent(.playButtonTapped)
            
        case .audioButtonTapped:
            interactor.handleEvent(.audioButtonTapped(isUse: true))
        case .settingButtonTapped:
            break
        case .rotationButtonTapped:
            print("AppDelegate.orientationLock \(AppDelegate.orientationLock == .landscape)")
            print(AppDelegate.orientationLock)
            if AppDelegate.orientationLock == .landscape {
                AppDelegate.orientationLock = .portrait
                setLayout.accept(.portrait)
                controllerView?.handleEvent(.setLayout(style: .portrait))
                playerView?.setLayout()
            }
            else if AppDelegate.orientationLock == .portrait {
                AppDelegate.orientationLock = .landscape
                setLayout.accept(.landscape)
                controllerView?.handleEvent(.setLayout(style: .landscape))
                playerView?.setLayout()
            }
        }
        
        return nil
    }
    
    func backButtonTapped() {
        
    }
    
}

enum AssetError: Error {
    case invaild
}
