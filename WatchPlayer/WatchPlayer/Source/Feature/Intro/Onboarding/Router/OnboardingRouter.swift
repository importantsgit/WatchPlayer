//
//  OnboardingRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit
import RxRelay

protocol OnboardingRouterProtocol {
    func dismissOnboardingView()
}

struct OnboardingRouterActions {
    let finishFlow: PublishRelay<Void>
}

final class OnboardingRouter: OnboardingRouterProtocol {
    
    let actions: OnboardingRouterActions
    
    init(
        actions: OnboardingRouterActions
    ) {
        self.actions = actions
    }
    
    func dismissOnboardingView() {
        actions.finishFlow.accept(())
    }

}

