//
//  VideoListPresenter.swift
//  WatchPlayer
//
//  Created by Importants on 7/2/24.
//

import Foundation
import RxSwift
import RxRelay
import Photos

final class VideoListPresenterMock: VideoListPresenterProtocol {

    let router: VideoListRouterMock
    let interactor: VideoListInteractorMock
    
    private var videoList = [PHAsset]()
    private var isLastPage = false
    private var isFetching = false
    let fetchVideoList = PublishRelay<[PHAsset]>()
    
    init(
        router: VideoListRouterMock,
        interactor: VideoListInteractorMock
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    var viewDidLoadCallCount = 0
    func viewDidLoad() {
        viewDidLoadCallCount += 1
        fetchVideos()
    }
    
    var fetchVideosCallCount = 0
    func fetchVideos() {
        fetchVideosCallCount += 1
        guard isFetching == false && isLastPage == false
        else { return }
        
        isFetching = true
        Task.detached(priority: .background) { [weak self] in
            guard let self = self else { return }
            do {
                let (addList, isLastPage) = try await self.interactor.fetchVideos()
                self.isLastPage = isLastPage
                self.videoList += addList
                self.fetchVideoList.accept(addList)
                print(self.videoList)
                isFetching = false
            }
            catch {
                print("Failed to fetch videos: \(error)")
                isFetching = false
            }
        }
    }
    
    var selectedVideoCallCount = 0
    func selectedVideo(
        _ index: Int
    ) {
        selectedVideoCallCount += 1
        
    }
}
