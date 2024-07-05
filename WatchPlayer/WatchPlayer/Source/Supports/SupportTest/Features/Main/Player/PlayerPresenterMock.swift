//
//  PlayerPresenterMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import Foundation
import RxRelay
import RxSwift
import Photos


final class PlayerPresenterMock: PlayerPresenterProtocol {
    
    let router: PlayerRouterProtocol
    let interactor: PlayerInteractorProtocol
    let asset: PHAsset
    
    let setAsset = PublishRelay<PHAsset>()
    var fetchPlayerLayer = PublishRelay<AVPlayerLayer>()

    let hideControllerDelay = PublishSubject<Void>()
    let hideControllerImmediately = PublishSubject<Void>()
    
    let showController = PublishRelay<Void>()
    
    let setLayout = PublishRelay<LayoutStyle>()
    
    weak var playerView: PlayerViewProtocol?
    weak var controllerView: PlayerControllerViewProtocol?
    
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
        
    }
}

extension PlayerPresenterMock: PlayerControllerProtocol {
    func handleContollerEvent(_ event: SendFromControllerEvent) -> Any? {
        return nil
    }
}
