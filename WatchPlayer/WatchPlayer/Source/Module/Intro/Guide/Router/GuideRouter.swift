//
//  GuideRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol GuideRouterProtocol {

}

struct GuideRouterActions {
    
}

final class GuideRouter: GuideRouterProtocol {
    
    let actions: GuideRouterActions
    
    init(
        actions: GuideRouterActions
    ) {
        self.actions = actions
    }

}

