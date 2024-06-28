//
//  PermissionRouter.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import Foundation

protocol PermissionRouterProtocol {
    func showImagePicker()
    
}

struct PermissionRouterActions {
    
}

final class PermissionRouter: PermissionRouterProtocol {

    weak var permissionView: DefaultViewController?
    let actions: PermissionRouterActions
    
    init(
        permissionView: DefaultViewController?,
        actions: PermissionRouterActions
    ){
        self.permissionView = permissionView
        self.actions = actions
    }
    
    func showImagePicker() {
        
    }
}
