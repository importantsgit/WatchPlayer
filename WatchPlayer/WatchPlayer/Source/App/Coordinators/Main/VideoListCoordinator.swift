//
//  VideoListCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit
import RxSwift
import RxRelay
import Photos

protocol VideoListRouterManageable: LeafCoordinator {
    var navigationController: UINavigationController? { get }
    var rootViewController: UIViewController? { get }
}

final public class VideoListCoordinator: VideoListRouterManageable {
    
    weak public private(set) var navigationController: UINavigationController?
    public private(set) var rootViewController: UIViewController?
    private let dependencies: VideoListDependencies
    var disposeBag = DisposeBag()
    
    init(
        navigationController: UINavigationController?,
        dependencies: VideoListDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func makeVideoListRouterActions(
    ) -> VideoListRouterActions {
        let showPlayer = PublishRelay<PHAsset>()
        showPlayer
            .subscribe(onNext: { [weak self] asset in
            self?.showPlayer(asset: asset)
        })
        .disposed(by: disposeBag)
        
        return .init(
            showPlayer: showPlayer
        )
    }
    
    func makePlayerRouterActions(
    ) -> PlayerRouterActions {
        let dismissView = PublishRelay<Void>()
        dismissView.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)
        
        return .init(
            dismissView: dismissView
        )
    }
    
    func start() {
        showVideoListView()
    }
    
    func showVideoListView() {
        let videoListViewController = dependencies.makeVideoListModule(
            navigationController: navigationController,
            actions: makeVideoListRouterActions()
        )
        rootViewController = videoListViewController
    }
    
    func showPlayer(asset: PHAsset) {
        let playerViewController = dependencies.makePlayerModule(
            navigationController: navigationController,
            actions: makePlayerRouterActions(),
            asset: asset
        )
        
        navigationController?.pushViewController(playerViewController, animated: true)
    }
}
