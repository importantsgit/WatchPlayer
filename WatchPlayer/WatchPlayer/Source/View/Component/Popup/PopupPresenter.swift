//
//  PopupPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/9/24.
//

import Foundation
import RxSwift
import RxRelay



protocol PopupPresenterProtocol: AnyObject {
    var popupActions: PublishRelay<PopupAction> { get }
}

final class PopupPresenter: PopupPresenterProtocol {
    
    let popupActions = PublishRelay<PopupAction>()
    let disposeBag = DisposeBag()
    
    weak var view: PopupViewControllerProtocol?
    var router: PopupRouterProtocol
    
    init(
        router: PopupRouterProtocol
    ) {
        self.router = router
        setupBinding()
    }
    
    func setupBinding(){
        popupActions
            .debug("PopupPresenter")
            .bind(to: router.popupActions)
            .disposed(by: disposeBag)
    }
        
}
