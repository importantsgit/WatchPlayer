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
    var popupActions: PublishRelay<PopupEvent> { get }
}

final class PopupPresenter: PopupPresenterProtocol {
    
    let popupActions = PublishRelay<PopupEvent>()
    let disposeBag = DisposeBag()
    
    weak var view: PopupViewControllerProtocol?
    var router: PopupRouterProtocol
    
    init(
        router: PopupRouterProtocol
    ) {
        self.router = router
        setupBindings()
    }
    
    private func setupBindings() {
        popupActions.subscribe(onNext: { [weak self] event in
            switch event {
            case .oneOptionButtonTapped:
                self?.router.confirmButtonTapped()
            case .leftButtonTapped:
                self?.router.cancelButtonTapped()
            case .rightButtonTapped:
                self?.router.confirmButtonTapped()
            }
        }).disposed(by: disposeBag)
    }
    
}
