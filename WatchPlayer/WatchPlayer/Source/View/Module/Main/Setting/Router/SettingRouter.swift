//
//  SettingRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation


protocol SettingRouterProtocol {}

struct SettingRouterActions {}

final class SettingRouter: SettingRouterProtocol {
    
    let actions: SettingRouterActions
    
    init(
        actions: SettingRouterActions
    ) {
        self.actions = actions
    }
}
