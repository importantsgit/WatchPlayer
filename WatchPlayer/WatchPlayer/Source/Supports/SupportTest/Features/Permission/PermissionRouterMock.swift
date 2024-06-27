//
//  PermissionRouterMock.swift
//  WatchPlayer
//
//  Created by Importants on 6/28/24.
//

import Foundation

final class PermissionRouterMock: PermissionRouterProtocol {
    
    let actions: PermissionRouterActions
    
    init(
        actions: PermissionRouterActions
    ) {
        self.actions = actions
    }
    
}
