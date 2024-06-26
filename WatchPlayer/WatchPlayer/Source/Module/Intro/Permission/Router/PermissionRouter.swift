//
//  PermissionRouter.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import Foundation

protocol PermissionRouterProtocol {}

struct PermissionRouterActions {
    
}

final class PermissionRouter: PermissionRouterProtocol {
    
    let actions: PermissionRouterActions
    
    init(
        actions: PermissionRouterActions
    ){
        self.actions = actions
    }
}
