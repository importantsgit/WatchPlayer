//
//  IntroPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol IntroPresenterProtocolInput {
    
}

protocol IntroPresenterProtocolOutput {
    
}

typealias IntroPresenterProtocol = IntroPresenterProtocolInput & IntroPresenterProtocolOutput

final class IntroPersenter: IntroPresenterProtocol {
    let interactor: IntroInteractorProtocol
    // let router:
    
    init(
        interactor: IntroInteractorProtocol
    ) {
        self.interactor = interactor
    }
}
