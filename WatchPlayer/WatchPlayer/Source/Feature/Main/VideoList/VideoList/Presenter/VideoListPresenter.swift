//
//  VideoListPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation
import RxSwift
import RxRelay
import Photos

protocol VideoListPresenterProtocolInput {
    func viewDidLoad()
    func fetchVideos()
    func selectedVideo(
        _ index: Int
    )
}

protocol VideoListPresenterProtocolOutput {
    var fetchVideoList: PublishRelay<[PHAsset]> { get }
}

typealias VideoListPresenterProtocol = VideoListPresenterProtocolInput & VideoListPresenterProtocolOutput

final class VideoListPresenter: VideoListPresenterProtocol {
    
    private let router: VideoListRouterProtocol
    private let interactor: VideoListInteractorProtocol
    private let disposeBag = DisposeBag()
    
    private var videoList = [PHAsset]()
    private var isLastPage = false
    private var isFetching = false
    let fetchVideoList = PublishRelay<[PHAsset]>()
    
    init(
        router: VideoListRouterProtocol,
        interactor: VideoListInteractorProtocol
    ) {
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        fetchVideos()
    }
    
    func fetchVideos() {
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
                isFetching = false
            }
            catch {
                print("Failed to fetch videos: \(error)")
                isFetching = false
            }
        }
    }
    
    func selectedVideo(_ index: Int) {
        let selectedAsset = videoList[index]
        router.showPlayer(asset: selectedAsset)
    }
}
