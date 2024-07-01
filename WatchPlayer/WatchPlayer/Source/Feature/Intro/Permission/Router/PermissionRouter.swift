//
//  PermissionRouter.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import Foundation
import RxRelay

protocol PermissionRouterProtocol {
    func showOnboardingView()
}

struct PermissionRouterActions {
    let showOnboardingView: PublishRelay<Void>
}

final class PermissionRouter: PermissionRouterProtocol {
    
    let actions: PermissionRouterActions
    
    init(
        actions: PermissionRouterActions
    ){
        self.actions = actions
    }

    func showOnboardingView() {
        actions.showOnboardingView.accept(())
    }
}
