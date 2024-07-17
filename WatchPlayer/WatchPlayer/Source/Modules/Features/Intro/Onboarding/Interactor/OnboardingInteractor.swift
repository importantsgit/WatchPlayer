//
//  OnboardingInteractor.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation

protocol OnboardingInteractorProtocol {
    func neverShowOnboardingView()
}

final class OnboardingInteractor: OnboardingInteractorProtocol {
    
    let dataRepository: DataRepositoryInterface
    
    init(
        dataRepository: DataRepositoryInterface
    ) {
        self.dataRepository = dataRepository
    }
    
    func neverShowOnboardingView() {
        dataRepository.dismissOnboardingViewForever()
    }
}
