//
//  PlayerRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import UIKit
import RxSwift
import RxRelay
import Photos


protocol PlayerRouterProtocol {
    func dismissView()
    func showDeletePopup(
    ) -> Observable<PopupAction>
}

struct PlayerRouterActions {
    let dismissView: PublishRelay<Void>
}

final class PlayerRouter: DefaultRouter, PlayerRouterProtocol {
    
    private let actions: PlayerRouterActions
    
    init(
        navigationController: UINavigationController?,
        actions: PlayerRouterActions
    ) {
        self.actions = actions
        
        super.init(navigationController: navigationController)
    }
    
    func dismissView() {
        actions.dismissView.accept(())
    }
    
    func showDeletePopup(
    ) -> Observable<PopupAction>  {
        return self.showPopup(
            configuration: .init(
                type: .alert(
                    title: "동영상 삭제",
                    message: "해당 동영상을 삭제하시겠습니까?",
                    buttons: [.init(title: "취소", style: .cancel), .init(title: "삭제", style: .destructive)]
                ),
                dismmisOnBackgroundTap: true
            )
        )
        .do(onNext: { [weak self] _ in
            self?.navigationController?.presentedViewController?.dismiss(animated: true)
        })
    }
}
