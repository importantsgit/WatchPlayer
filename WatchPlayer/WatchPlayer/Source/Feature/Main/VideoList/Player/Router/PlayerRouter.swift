//
//  PlayerRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import Foundation
import RxRelay


protocol PlayerRouterProtocol {
    func backButtonTapped()
}

struct PlayerRouterActions {
    let dismissView: PublishRelay<Void>
}

final class PlayerRouter: PlayerRouterProtocol {
    private let actions: PlayerRouterActions
    
    init(
        actions: PlayerRouterActions
    ) {
        self.actions = actions
    }
    
    func backButtonTapped() {
        actions.dismissView.accept(())
    }
}
