//
//  PermissionRouter.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit
import RxRelay

protocol PermissionRouterProtocol {
    func showOnboardingView()
}

struct PermissionRouterActions {
    let showOnboardingView: PublishRelay<Void>
}

final class PermissionRouter: PermissionRouterProtocol {
    
    private weak var navigationController: UINavigationController?
    private let actions: PermissionRouterActions
    
    init(
        navigationController: UINavigationController?,
        actions: PermissionRouterActions
    ){
        self.navigationController = navigationController
        self.actions = actions
    }

    func showOnboardingView() {
        actions.showOnboardingView.accept(())
    }
}
