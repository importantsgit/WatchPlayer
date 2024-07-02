//
//  VideoListCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit
import RxSwift
import RxRelay

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
        return .init()
    }
    
    func start() {
        showVideoListView()
    }
    
    func showVideoListView() {
        let videoListViewController = dependencies.makeVideoListViewController(
            actions: makeVideoListRouterActions()
        )
        rootViewController = videoListViewController
    }
    
}
