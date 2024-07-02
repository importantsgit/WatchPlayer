//
//  SettingCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit
import RxSwift
import RxRelay

protocol SettingRouterManageable: LeafCoordinator {
    var navigationController: UINavigationController? { get }
    var rootViewController: UIViewController? { get }
}

final public class SettingCoordinator: SettingRouterManageable {
    
    weak public private(set) var navigationController: UINavigationController?
    public private(set) var rootViewController: UIViewController?
    private let dependencies: SettingDependencies
    var disposeBag = DisposeBag()
    
    init(
        navigationController: UINavigationController?,
        dependencies: SettingDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func makeSettingRouterActions(
    ) -> SettingRouterActions {
        return .init()
    }
    
    func start() {
        showSettingView()
    }
    
    func showSettingView() {
        let settingViewController = dependencies.makeSettingViewController(
            actions: makeSettingRouterActions()
        )
        rootViewController = settingViewController
    }
    
}
