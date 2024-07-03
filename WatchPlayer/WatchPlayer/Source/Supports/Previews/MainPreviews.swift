//
//  MainPreviews.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import UIKit

#if DEBUG

@available(iOS 17.0, *)
#Preview {
    let navigationController = UINavigationController()
    navigationController.isNavigationBarHidden = true

    let dependencies = MainDIContainer(
        dependencies: .init(
            translationService: TranslationService(configuration: .init()),
            dataService: DataService(configuration: .init()),
            recordService: RecordService(configuration: .init()),
            libraryService: LibraryService(configuration: .init(fetchLimit: 20))
        )
    )

    let coordinator = MainCoordinator(
        navigationController: navigationController,
        dependencies: dependencies
    )
    
    coordinator.start()
    return navigationController
}

#endif


