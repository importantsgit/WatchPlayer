//
//  VideoListRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation

protocol VideoListRouterProtocol {}

struct VideoListRouterActions {
    
}

final class VideoListRouter: VideoListRouterProtocol {
    
    let actions: VideoListRouterActions
    
    init(
        actions: VideoListRouterActions
    ) {
        self.actions = actions
    }
}
