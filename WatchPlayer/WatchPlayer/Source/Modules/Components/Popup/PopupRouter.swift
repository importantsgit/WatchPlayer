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
    let popupActionEvent: PublishRelay<PopupAction>
}

protocol PopupRouterProtocol {
    func setupBinding()
    var popupActions: PublishRelay<PopupAction> { get }
}

final class PopupRouter: PopupRouterProtocol {
    
    private var disposeBag = DisposeBag()
    
    let popupActions = PublishRelay<PopupAction>()
    let actions: PopupRouterActions
    
    init(
        actions: PopupRouterActions
    ){
        self.actions = actions
        setupBinding()
    }
    
    static func createPopupModule(
        actions: PopupRouterActions
    ) -> PopupViewControllerProtocol {
        let router = PopupRouter(actions: actions)
        let presenter = PopupPresenter(router: router)
        let viewController = PopupViewController(presenter: presenter)
        
        presenter.view = viewController
        
        return viewController
    }
    
    func setupBinding(){
        popupActions
            .debug("PopupRouter")
            .bind(to: actions.popupActionEvent)
            .disposed(by: disposeBag)
    }

}
