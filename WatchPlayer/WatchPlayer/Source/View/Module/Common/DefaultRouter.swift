//
//  DefaultRouter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/10/24.
//

import UIKit
import RxSwift
import RxRelay

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var disposeBag: DisposeBag { get }
    
    func showPopup(
        configuration: PopupConfiguration
    ) -> Observable<PopupAction>
}

extension RouterProtocol {
    func showPopup(
        configuration: PopupConfiguration
    ) -> Observable<PopupAction> {
        let popupActionEvent = PublishRelay<PopupAction>()
        
        let actions = PopupRouterActions(
            popupActionEvent: popupActionEvent
        )
        
        let popupViewController = PopupRouter.createPopupModule(actions: actions)
        popupViewController.setupPopup(with: configuration)
        
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.modalTransitionStyle = .crossDissolve
        navigationController?.present(popupViewController, animated: true)
        
        return popupActionEvent.asObservable()
    }
}

class DefaultRouter: RouterProtocol {
    
    weak var navigationController: UINavigationController?
    let disposeBag = DisposeBag()
    
    init(
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
    }
    

}


