//
//  SettingPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation

protocol SettingPresenterProtocol {
    
}

final class SettingPresenter: SettingPresenterProtocol {
    
    let router: SettingRouterProtocol
    let interactor: SettingInteractorProtocol
    
    init(
        router: SettingRouterProtocol,
        interactor: SettingInteractorProtocol
    ) {
        self.router = router
        self.interactor = interactor
    }
    
}
