//
//  VideoListPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation

protocol VideoListPresenterProtocol {}

final class VideoListPresenter: VideoListPresenterProtocol {
    
    private let router: VideoListRouterProtocol
    private let interactor: VideoListInteractorProtocol
    
    init(
        router: VideoListRouterProtocol,
        interactor: VideoListInteractorProtocol
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    
}
