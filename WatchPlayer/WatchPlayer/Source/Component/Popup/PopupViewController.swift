//
//  PopupViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/9/24.
//

import UIKit
import RxSwift
import RxRelay

protocol PopupViewControllerProtocol: AnyObject {
    func setupPopup(with model: PopupModel)
}

final class PopupViewController: UIViewController, PopupViewControllerProtocol {
    weak var presenter: PopupPresenterProtocol?
    let disposeBag = DisposeBag()
    
    func setupPopup(with model: PopupModel) {
        let popupView = PopupFactory.setup(with: model)
        popupView.actions
            .bind(to: presenter?.popupActions ?? PublishRelay<PopupEvent>())
            .disposed(by: disposeBag)
        self.view.addSubview(popupView)
        
        // Setup constraints for popupView here
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: 300),
            popupView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}

