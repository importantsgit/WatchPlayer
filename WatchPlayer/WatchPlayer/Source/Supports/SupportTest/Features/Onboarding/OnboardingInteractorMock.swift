//
//  OnboardingInteractorMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation

final class OnboardingInteractorMock: OnboardingInteractorProtocol {
    
    let dataRepository: DataRepositoryMock
    
    init(
        dataRepository: DataRepositoryMock
    ) {
        self.dataRepository = dataRepository
    }
    
    func neverShowOnboardingView() {
        dataRepository.dismissOnboardingViewForever()
    }
}
