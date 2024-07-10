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
            libraryService: LibraryService(configuration: .init(fetchLimit: 20)),
            playerService: PlayerService()
        )
    )

    let coordinator = MainCoordinator(
        navigationController: navigationController,
        dependencies: dependencies
    )
    
    coordinator.start()
    
    let popup = PopupRouter.createPopupModule(actions: .init(popupActionEvent: .init()))
    popup.setupPopup(
        with: .init(
            type: .alert(
                title: "동영상 삭제",
                message: "메세지입니다메세지입니다메세지입니다메세지입니다.",
                buttons: [
                    .init(title: "안녕", style: .normal),
                    .init(title: "안녕", style: .destructive)
                ]
            ),
            dismmisOnBackgroundTap: true
        )
    )
    
    navigationController.pushViewController(popup, animated: true)
    
    return navigationController
}

#endif


