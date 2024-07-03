//
//  PlayerPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import Foundation
import RxRelay
import Photos

protocol PlayerPresenterProtocolInput {
    func viewDidLoad()
    func backButtonTapped()
}

protocol PlayerPresenterProtocolOutput {
    var fetchPlayerItem: PublishRelay<AVPlayerItem> { get }
}

typealias PlayerPresenterProtocol = PlayerPresenterProtocolInput & PlayerPresenterProtocolOutput

final class PlayerPresenter: PlayerPresenterProtocol {
    
    let router: PlayerRouterProtocol
    let interactor: PlayerInteractorProtocol
    let asset: PHAsset
    
    var playerItem: AVPlayerItem?
    
    let fetchPlayerItem = PublishRelay<AVPlayerItem>()
    
    
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
                print(asset.pixelWidth, asset.pixelHeight)
                let item = try await requestAVPlayerItem(asset)
                playerItem = item
                fetchPlayerItem.accept(item)
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
            
            PHImageManager.default().requestPlayerItem(
                forVideo: asset,
                options: options
            ) { item, _ in
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
        router.backButtonTapped()
    }
}

enum AssetError: Error {
    case invaild
}
