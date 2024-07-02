//
//  RecordRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation

protocol RecordRouterProtocol {}

struct RecordRouterActions {
    
}

final class RecordRouter: RecordRouterProtocol {
    
    let actions: RecordRouterActions
    
    init(
        actions: RecordRouterActions
    ) {
        self.actions = actions
    }
}
