//
//  PlayerRouterMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import UIKit
import RxSwift

final class PlayerRouterMock: DefaultRouter, PlayerRouterProtocol {
    
    let actions: PlayerRouterActions
    
    init(
        navigationController: UINavigationController?,
        actions: PlayerRouterActions
    ) {
        self.actions = actions
        
        super.init(navigationController: navigationController)
    }
    
    var dismissViewCallCount = 0
    func dismissView() {
        dismissViewCallCount += 1
        actions.dismissView.accept(())
    }
    
    var showDeletePopupCallCount = 0
    func showDeletePopup(
    ) -> Observable<PopupAction> {
        return showPopup(
            configuration: .init(
                type: .actionSheet(
                    title: "",
                    message: "",
                    buttons: []
                ), dismmisOnBackgroundTap: true
            )
        )
    }
}
