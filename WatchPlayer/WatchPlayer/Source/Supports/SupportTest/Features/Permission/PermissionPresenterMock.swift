//
//  PermissionPresenterMock.swift
//  WatchPlayer
//
//  Created by Importants on 6/28/24.
//

import Foundation

final class PermissionPresenterMock: PermissionPresenterProtocol {
    
    let interator: PermissionInteractorProtocol
    let router: PermissionRouterProtocol
    
    init(
        interator: PermissionInteractorProtocol,
        router: PermissionRouterProtocol
    ) {
        self.interator = interator
        self.router = router
    }
    
    func permissionButtonTapped() {
        
    }
}
