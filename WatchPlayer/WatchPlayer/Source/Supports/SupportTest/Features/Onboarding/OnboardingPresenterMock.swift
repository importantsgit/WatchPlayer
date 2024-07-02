//
//  OnboardingPresenterMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation

final class OnboardingPresenterMock: OnboardingPresenterProtocol {
    
    let interactor: OnboardingInteractorProtocol
    let router: OnboardingRouterProtocol
    
    init(
        interactor: OnboardingInteractorProtocol,
        router: OnboardingRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    var confirmButtonTappedCallCount = 0
    func confirmButtonTapped() {
        confirmButtonTappedCallCount += 1
        interactor.neverShowOnboardingView()
        router.dismissOnboardingView()
    }
}
