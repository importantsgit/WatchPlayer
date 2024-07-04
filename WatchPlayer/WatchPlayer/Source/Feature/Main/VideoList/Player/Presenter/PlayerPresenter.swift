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

enum LayoutStyle {
    case portrait
    case landscape
}

protocol PlayerPresenterProtocolInput {
    func viewDidLoad()
    
}

protocol PlayerControllerProtocol {
    func playViewTapped()
    func controllerTapped()
    
    func backButtonTapped()
    func playButtonTapped()
    
    func audioButtonTapped()
    func settingButtonTapped()
    func expandButtonTapped()
    func shrinkButtonTapped()
}

protocol PlayerPresenterProtocolOutput {
    var setAsset: PublishRelay<PHAsset> { get }
    var fetchPlayerItem: PublishRelay<AVPlayer> { get }
    
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
    
    var playerItem: AVPlayerItem?
    
    let setAsset = PublishRelay<PHAsset>()
    let fetchPlayerItem = PublishRelay<AVPlayer>()

    let hideControllerDelay = PublishSubject<Void>()
    let hideControllerImmediately = PublishSubject<Void>()
    
    let showController = PublishRelay<Void>()
    
    let setLayout = PublishRelay<LayoutStyle>()
    
    
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
                playerItem = item
                let player = AVPlayer(playerItem: playerItem)
                fetchPlayerItem.accept(player)
                interactor.start(player: player)
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
    
    func backButtonTapped() {
        router.backButtonTapped()
    }
    
    func audioButtonTapped() {
        
    }
    
    func playViewTapped() {
        showController.accept(())
        hideControllerDelay.onNext(())
    }
    
    func controllerTapped() {
        hideControllerImmediately.onNext(())
    }
    
    func playButtonTapped() {
        
    }
    
    func settingButtonTapped() {
        
    }
    
    func expandButtonTapped() {
        //AppDelegate.orientationRotate = .landscape
        if AppDelegate.orientationLock == .landscape {
            AppDelegate.orientationLock = .portrait
            setLayout.accept(.portrait)
        }
        else if AppDelegate.orientationLock == .portrait {
            AppDelegate.orientationLock = .landscape
            setLayout.accept(.landscape)
        }
        
    }
    
    func shrinkButtonTapped() {
        
    }
    
}

enum AssetError: Error {
    case invaild
}
