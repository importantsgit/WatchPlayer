//
//  PermissionPresenter.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import Foundation

protocol PermissionPresenterInput {}
protocol PermissionPresenterOutput {}

typealias PermissionPresenterProtocol = PermissionPresenterInput & PermissionPresenterOutput

final class PermissionPresenter: PermissionPresenterProtocol {
    
    let interator: PermissionInteractorProtocol
    let router: PermissionRouterProtocol
    
    init(
        interator: PermissionInteractorProtocol,
        router: PermissionRouterProtocol
    ) {
        self.interator = interator
        self.router = router
    }
}