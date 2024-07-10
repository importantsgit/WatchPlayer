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
    
    private weak var navigationController: UINavigationController?
    private let actions: OnboardingRouterActions
    
    init(
        navigationController: UINavigationController?,
        actions: OnboardingRouterActions
    ) {
        self.navigationController = navigationController
        self.actions = actions
    }
    
    func dismissOnboardingView() {
        actions.finishFlow.accept(())
    }

}

