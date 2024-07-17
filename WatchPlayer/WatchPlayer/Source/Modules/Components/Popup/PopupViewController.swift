//
//  PopupViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/9/24.
//

import UIKit
import RxSwift
import RxRelay
import RxGesture

protocol PopupViewControllerProtocol: UIViewController {
    func setupPopup(with configuration: PopupConfiguration)
}

final class PopupViewController: UIViewController, PopupViewControllerProtocol  {
    var presenter: PopupPresenterProtocol
    let disposeBag = DisposeBag()
    
    init(
        presenter: PopupPresenterProtocol
    ){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupPopup(with configuration: PopupConfiguration) {
        let popupView = PopupView(configuration: configuration)
        popupView.layer.cornerRadius = 16
        
        popupView.actions
            .debug("buttonTapped")
            .take(1)
            .bind(to: presenter.popupActions)
            .disposed(by: disposeBag)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hex: "000000", alpha: 0.4)
        
        backgroundView
            .rx
            .tapGesture()
            .when(.recognized)
            .take(1)
            .debug("backgroundTapped")
            .map { _ in PopupAction.backgroundTapped }
            .bind(to: presenter.popupActions)
            .disposed(by: disposeBag)
        
        [backgroundView, popupView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            popupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
}

