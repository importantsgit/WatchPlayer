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
    
    let interactor: PermissionInteractorProtocol
    let router: PermissionRouterProtocol
    
    init(
        interactor: PermissionInteractorProtocol,
        router: PermissionRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        
    }
    
    func permissionButtonTapped() async {
        await interactor.showPermissionPopup()
        router.showOnboardingView()
    }
}
