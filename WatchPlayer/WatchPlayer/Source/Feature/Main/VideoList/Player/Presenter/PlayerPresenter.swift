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
                let avAsset = try await requestAVAsset(asset)
                playerItem = .init(asset: avAsset)
                fetchPlayerItem.accept(playerItem!)
            }
            catch {
                
            }
        }
    }
    
    func requestAVAsset(
        _ asset: PHAsset
    ) async throws -> AVAsset {
        return try await withCheckedThrowingContinuation { continuation in
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            
            PHImageManager.default().requestAVAsset(
                forVideo: asset,
                options: options
            ) { (asset, _, _) in
                guard let asset = asset
                // FIXME: 에러 처리
                else {
                    continuation.resume(throwing: AssetError.invaild)
                    return
                }
                continuation.resume(returning: asset)
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
