//
//  GuideInteractor.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation


protocol GuideInteractorProtocol {
    
}

final class GuideInteractor: GuideInteractorProtocol {
    
    let dataRepository: DataRepositoryInterface
    
    init(
        dataRepository: DataRepositoryInterface
    ) {
        self.dataRepository = dataRepository
    }
}
