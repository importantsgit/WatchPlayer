//
//  GuidePresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol GuidePresenterProtocolInput {
    
}

protocol GuidePresenterProtocolOutput {
    
}

typealias GuidePresenterProtocol = GuidePresenterProtocolInput & GuidePresenterProtocolOutput

final class GuidePersenter: GuidePresenterProtocol {
    
    let interactor: GuideInteractorProtocol
    let router: GuideRouterProtocol
    
    init(
        interactor: GuideInteractorProtocol,
        router: GuideRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
}
