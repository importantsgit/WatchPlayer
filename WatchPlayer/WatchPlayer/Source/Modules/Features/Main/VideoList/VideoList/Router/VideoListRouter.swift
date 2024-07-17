//
//  VideoListRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit
import Photos
import RxSwift
import RxRelay

protocol VideoListRouterProtocol {
    func showPlayer(asset: PHAsset)
    
}

struct VideoListRouterActions {
    let showPlayer: PublishRelay<PHAsset>
}

final class VideoListRouter: DefaultRouter, VideoListRouterProtocol {
    
    private let actions: VideoListRouterActions
    weak var presenter: VideoListPresenter?
    
    init(
        navigationController: UINavigationController?,
        actions: VideoListRouterActions
    ) {
        self.actions = actions
        
        super.init(navigationController: navigationController)
    }
    
    func showPlayer(
        asset: PHAsset
    ) {
        actions.showPlayer.accept(asset)
    }
    

}
