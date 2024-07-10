//
//  RecordPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation

protocol RecordPresenterProtocol {}

final class RecordPresenter: RecordPresenterProtocol {
    
    let router: RecordRouterProtocol
    let interactor: RecordInteractorProtocol
    
    init(
        router: RecordRouterProtocol,
        interactor: RecordInteractorProtocol
    ) {
        self.router = router
        self.interactor = interactor
    }
}
