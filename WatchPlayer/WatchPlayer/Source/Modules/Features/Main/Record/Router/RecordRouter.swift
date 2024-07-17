//
//  RecordRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit

protocol RecordRouterProtocol {}

struct RecordRouterActions {
    
}

final class RecordRouter: RecordRouterProtocol {
    
    private weak var navigationController: UINavigationController?
    private let actions: RecordRouterActions
    
    init(
        navigationController: UINavigationController?,
        actions: RecordRouterActions
    ) {
        self.navigationController = navigationController
        self.actions = actions
    }
}
