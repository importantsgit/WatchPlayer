//
//  IntroProtocol.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation


protocol IntroInteractorProtocol {
    
}

final class IntroInteractor: IntroInteractorProtocol {
    
    let dataRepository: DataRepositoryInterface
    
    init(
        dataRepository: DataRepositoryInterface
    ) {
        self.dataRepository = dataRepository
    }
}
