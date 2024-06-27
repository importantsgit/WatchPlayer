//
//  IntroPreviews.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/27/24.
//

import UIKit
import Combine

#if DEBUG

@available(iOS 17.0, *)
#Preview {
    let navigationController = UINavigationController()
    navigationController.isNavigationBarHidden = true

    let dependencies = IntroDIContainer(
        dependencies: .init(
            translationService: TranslationService(configuration: .init()),
            dataService: DataService(configuration: .init())
        )
    )

    let coordinator = IntroCoordinator(
        navigationController: navigationController,
        dependencies: dependencies
    )
    
    coordinator.start()
    return navigationController
}

#endif
