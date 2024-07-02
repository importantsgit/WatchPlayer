//
//  OnboardingRouterMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation

final class OnboardingRouterMock: OnboardingRouterProtocol {
    
    let actions: OnboardingRouterActions
    
    init(
        actions: OnboardingRouterActions
    ) {
        self.actions = actions
    }
    
    var dismissOnboardingViewCallCount = 0
    func dismissOnboardingView() {
        dismissOnboardingViewCallCount += 1
        actions.finishFlow.accept(())
    }

}

