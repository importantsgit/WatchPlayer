//
//  VideoListRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation
import RxRelay
import Photos

protocol VideoListRouterProtocol {
    func showPlayer(asset: PHAsset)
    
}

struct VideoListRouterActions {
    let showPlayer: PublishRelay<PHAsset>
}

final class VideoListRouter: VideoListRouterProtocol {
    
    let actions: VideoListRouterActions
    
    init(
        actions: VideoListRouterActions
    ) {
        self.actions = actions
    }
    
    func showPlayer(
        asset: PHAsset
    ) {
        actions.showPlayer.accept(asset)
    }
}
