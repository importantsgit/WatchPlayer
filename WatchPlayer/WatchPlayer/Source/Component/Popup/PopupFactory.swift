//
//  PopupFactory.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/9/24.
//

import UIKit
import RxSwift
import RxRelay
import RxGesture

enum PopupEvent {
    case oneOptionButtonTapped
    case leftButtonTapped
    case rightButtonTapped
}

protocol Popup {
    func setLayout()
}

protocol PopupModel {}

struct OneOptionPopupModel: PopupModel {
    let title: String
    let description: String
    let buttonTitle: String
}

struct TwoOptionPopupModel: PopupModel {
    let title: String
    let description: String
    let leftButtonTitle: String
    let rightButtonTitle: String
}
 
class DefaultPopupView: UIView, Popup {
    
    let actions = PublishRelay<PopupEvent>()
    let disposeBag = DisposeBag()
    
    let model: PopupModel
    
    init(
        model: PopupModel
    ) {
        self.model = model
    
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {}
}

final class OneOptionPopupView: DefaultPopupView {
    
    
    override func setLayout() {
        super.setLayout()
        
        let titleLabel = UILabel()
        let descriptionLabel = UILabel()
        let button = UIButton()
        
        guard let model = model as? OneOptionPopupModel
        else { fatalError() }
        
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        button.configuration = .plain()
        button.configuration?.title = model.buttonTitle
        button.rx.tap
            .bind { [weak self] in
                self?.actions.accept(.oneOptionButtonTapped)
            }
            .disposed(by: disposeBag)
        
        
        [titleLabel, descriptionLabel, button].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor),
            
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            button.leftAnchor.constraint(equalTo: leftAnchor),
            button.rightAnchor.constraint(equalTo: rightAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

final class TwoOptionPopupView: DefaultPopupView {
    
    override func setLayout() {
        super.setLayout()
        
        let titleLabel = UILabel()
        let descriptionLabel = UILabel()
        let leftButton = UIButton()
        let rightButton = UIButton()
        
        guard let model = model as? TwoOptionPopupModel
        else { fatalError() }
        
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        leftButton.configuration = .plain()
        leftButton.configuration?.title = model.leftButtonTitle
        leftButton.rx.tap
            .bind { [weak self] in
                self?.actions.accept(.leftButtonTapped)
            }
            .disposed(by: disposeBag)
        
        rightButton.configuration = .plain()
        rightButton.configuration?.title = model.rightButtonTitle
        rightButton.rx.tap
            .bind { [weak self] in
                self?.actions.accept(.rightButtonTapped)
            }
            .disposed(by: disposeBag)
        
        [titleLabel, descriptionLabel, leftButton, rightButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor),
            
            leftButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            leftButton.leftAnchor.constraint(equalTo: leftAnchor),
            leftButton.rightAnchor.constraint(equalTo: centerXAnchor),
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftButton.heightAnchor.constraint(equalToConstant: 48),
            
            rightButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            rightButton.leftAnchor.constraint(equalTo: centerXAnchor),
            rightButton.rightAnchor.constraint(equalTo: rightAnchor),
            rightButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

final class PopupFactory {
    
    static func setup(
        with model: PopupModel
    ) -> DefaultPopupView {
        
        switch model {
        case is OneOptionPopupModel:
            let popup = OneOptionPopupView(model: model)
            return popup
            
        case is TwoOptionPopupModel:
            let popup = TwoOptionPopupView(model: model)
            return popup
            
        default:
            fatalError()
        }
    }
}
