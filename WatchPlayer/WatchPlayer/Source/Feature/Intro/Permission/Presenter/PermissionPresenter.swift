//
//  PermissionPresenter.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import Foundation

protocol PermissionPresenterInput {
    func permissionButtonTapped() async
    func viewDidLoad()
}

protocol PermissionPresenterOutput {
    
}

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
    
    func viewDidLoad() {
        
    }
    
    func permissionButtonTapped() async {
        await interator.showPermissionPopup()
        router.showOnboardingView()
    }
}
