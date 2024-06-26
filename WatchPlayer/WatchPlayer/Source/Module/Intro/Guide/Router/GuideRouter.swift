//
//  GuideRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol GuideRouterProtocol {

}

final class GuideRouter: GuideRouterProtocol {
    let presentingViewController: UIViewController
    
    init(
        presentingViewController: UIViewController
    ) {
        self.presentingViewController = presentingViewController
    }

}

