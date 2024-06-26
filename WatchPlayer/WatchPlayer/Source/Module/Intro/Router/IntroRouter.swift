//
//  IntroRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol IntroRouterProtocol {
    static func createIntroMudule(
    ) -> UIViewController
}

final class IntroRouter: IntroRouterProtocol {
    let presentingViewController: UIViewController
    
    init(
        presentingViewController: UIViewController
    ) {
        self.presentingViewController = presentingViewController
    }
    
    static func createIntroMudule(
    ) -> UIViewController {
        return .init()
    }
}

