//
//  PlayerRouterMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import Foundation

final class PlayerRouterMock: PlayerRouterProtocol {
    let actions: PlayerRouterActions
    
    init(
        actions: PlayerRouterActions
    ) {
        self.actions = actions
    }
    
    var backButtonTappedCallCount = 0
    func backButtonTapped() {
        backButtonTappedCallCount += 1
        actions.dismissView.accept(())
    }
}
