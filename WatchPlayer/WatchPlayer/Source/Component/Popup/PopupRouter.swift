//
//  PopupRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/9/24.
//

import Foundation
import RxSwift
import RxRelay

struct PopupRouterActions {
    let confirmButtonTapped: PublishRelay<Void>
    let cancelButtonTapped: PublishRelay<Void>
}


protocol PopupRouterProtocol {
    func confirmButtonTapped()
    func cancelButtonTapped()
}

final class PopupRouter: PopupRouterProtocol {
    
    let actions: PopupRouterActions
    
    init(
        actions: PopupRouterActions
    ){
        self.actions = actions
    }
    
    static func createPopupModule(
        actions: PopupRouterActions
    ) -> UIViewController {
        let router = PopupRouter(actions: actions)
        let presenter = PopupPresenter(router: router)
        let viewController = PopupViewController()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
    
    func confirmButtonTapped() {
        actions.confirmButtonTapped.accept(())
    }
    
    func cancelButtonTapped() {
        actions.cancelButtonTapped.accept(())
    }
}
