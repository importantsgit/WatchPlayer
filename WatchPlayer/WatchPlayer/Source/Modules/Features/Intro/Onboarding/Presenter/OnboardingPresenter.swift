//
//  OnboardingPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol OnboardingPresenterProtocolInput {
    func confirmButtonTapped()
}

protocol OnboardingPresenterProtocolOutput {
    
}

typealias OnboardingPresenterProtocol = OnboardingPresenterProtocolInput & OnboardingPresenterProtocolOutput

final class OnboardingPresenter: OnboardingPresenterProtocol {

    let interactor: OnboardingInteractorProtocol
    let router: OnboardingRouterProtocol
    
    init(
        interactor: OnboardingInteractorProtocol,
        router: OnboardingRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func confirmButtonTapped() {
        interactor.neverShowOnboardingView()
        router.dismissOnboardingView()
    }
}
