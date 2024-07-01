//
//  OnboardingPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol OnboardingPresenterProtocolInput {
    
}

protocol OnboardingPresenterProtocolOutput {
    
}

typealias OnboardingPresenterProtocol = OnboardingPresenterProtocolInput & OnboardingPresenterProtocolOutput

final class OnboardingPersenter: OnboardingPresenterProtocol {
    
    let interactor: OnboardingInteractorProtocol
    let router: OnboardingRouterProtocol
    
    init(
        interactor: OnboardingInteractorProtocol,
        router: OnboardingRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
}
