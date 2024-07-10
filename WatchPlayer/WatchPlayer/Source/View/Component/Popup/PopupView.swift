//
//  PopupView.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/9/24.
//

import UIKit
import RxSwift
import RxRelay
import RxGesture

enum ButtonStyle {
    case normal
    case cancel
    case destructive
}

enum PopupAction {
    case buttonTapped(index: Int)
    case backgroundTapped
    case dismissed
}

struct PopupButton {
    let title: String
    let style: ButtonStyle
}

enum PopupType {
    case alert(title: String, message: String, buttons: [PopupButton])
    case actionSheet(title: String?, message: String?, buttons: [PopupButton])
}

struct PopupConfiguration {
    let type: PopupType
    let dismmisOnBackgroundTap: Bool
}


class PopupView: UIView {
    let actions = PublishRelay<PopupAction>()
    let disposeBag = DisposeBag()
    
    private let configuration: PopupConfiguration
    
    init(configuration: PopupConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        backgroundColor = .white
        
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        let separator = UIView()
        let buttonSeparator = UIView()
        let buttonContainer = UIStackView()
        
        buttonSeparator.backgroundColor = .separator
        separator.backgroundColor = .separator
        buttonContainer.axis = .horizontal
        buttonContainer.alignment = .fill
        buttonContainer.distribution = .fillProportionally
        
        switch configuration.type {
        case .alert(let title, let message, let buttons),
             .actionSheet(let title?, let message?, let buttons):

            
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
            messageLabel.textColor = .title
            
            messageLabel.text = message
            messageLabel.textAlignment = .center
            messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
            messageLabel.textColor = .subTitle
            messageLabel.numberOfLines = 0
            
            buttons.enumerated().forEach { index, button in
                let uiButton = UIButton()
                uiButton.setTitle(button.title, for: .normal)
                configureButton(uiButton, with: button.style)
                uiButton.rx.tap
                    .map { PopupAction.buttonTapped(index: index) }
                    .bind(to: actions)
                    .disposed(by: disposeBag)
                buttonContainer.addArrangedSubview(uiButton)
                
                if index < buttons.count - 1 {
                    let separator = UIView()
                    separator.backgroundColor = .separator
                    separator.translatesAutoresizingMaskIntoConstraints = false
                    buttonContainer.addArrangedSubview(separator)
                    
                    // separator의 너비 설정
                    NSLayoutConstraint.activate([
                        separator.widthAnchor.constraint(equalToConstant: 1)
                    ])
                }
            }
            
        case .actionSheet(_, _, let buttons):
            buttons.enumerated().forEach { index, button in
                let uiButton = UIButton()
                uiButton.setTitle(button.title, for: .normal)
                configureButton(uiButton, with: button.style)
                uiButton.rx.tap
                    .map { PopupAction.buttonTapped(index: index) }
                    .bind(to: actions)
                    .disposed(by: disposeBag)
                buttonContainer.addArrangedSubview(uiButton)
            }
        }
        
        [titleLabel, messageLabel, separator, buttonContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            separator.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 32),
            separator.leftAnchor.constraint(equalTo: leftAnchor),
            separator.rightAnchor.constraint(equalTo: rightAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            buttonContainer.topAnchor.constraint(equalTo: separator.bottomAnchor),
            buttonContainer.leftAnchor.constraint(equalTo: leftAnchor),
            buttonContainer.rightAnchor.constraint(equalTo: rightAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configureButton(_ button: UIButton, with style: ButtonStyle) {
        switch style {
        case .normal:
            button.setTitleColor(.systemBlue, for: .normal)
        case .cancel:
            button.setTitleColor(.systemGray, for: .normal)
        case .destructive:
            button.setTitleColor(.systemRed, for: .normal)
        }
    }
}

