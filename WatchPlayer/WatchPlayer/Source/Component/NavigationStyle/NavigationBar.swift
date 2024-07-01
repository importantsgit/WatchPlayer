//
//  NavigationBar.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/1/24.
//

import UIKit
import Combine

class NavigationBarView: UIView {
    private let style: NavigationStyleType
    private let bg: UIColor
    private let isDisplayLeftButton: Bool
    private let isDisplayRightButton: Bool
    private let rightButtonType: NavigationButtonType
    private let isOpenHiddenMenu: Bool
    private var leftButtonAction = PassthroughSubject<Void, Never>()
    private var rightButtonAction = PassthroughSubject<Void, Never>()
    private var hiddenButtonAction = PassthroughSubject<Void, Never>()
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        
        return label
    }()
    
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    private var hiddenButton = UIButton()
    
    init(
        title: String = "",
        style: NavigationStyleType = .dark,
        backgroundColor: UIColor = .clear,
        isDisplayLeftButton: Bool = false,
        isDisplayRightButton: Bool = false,
        rightButtonType: NavigationButtonType = .close,
        isOpenHiddenMenu: Bool = false
    ){
        self.titleLabel.text = title
        self.style = style
        self.bg = backgroundColor
        self.isDisplayLeftButton = isDisplayLeftButton
        self.isDisplayRightButton = isDisplayRightButton
        self.rightButtonType = rightButtonType
        self.isOpenHiddenMenu = isOpenHiddenMenu
        
        
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func leftButtonTapped() {
        leftButtonAction.send()
    }
    
    @objc private func rightButtonTapped() {
        rightButtonAction.send()
    }
    
    @objc private func hiddenButtonTapped() {
        hiddenButtonAction.send()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bg != .clear {
            self.layer.shadowPath = UIBezierPath(
                rect: CGRect(
                    x: 0,
                    y: 0,
                    width: frame.width,
                    height: frame.height
                )).cgPath
            self.backgroundColor = bg
            //self.layer.shadowColor = UIColor.depth3.cgColor
            self.layer.shadowOpacity = 0.1
            self.layer.shadowRadius = 2
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
}

extension NavigationBarView {
    private func setupLayout() {
    
        [leftButton, titleLabel, rightButton, hiddenButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
            
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        titleLabel.textColor = style == .light ? .white : .black
        
        NSLayoutConstraint.activate([
            leftButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            leftButton.widthAnchor.constraint(equalToConstant: 48),
            leftButton.heightAnchor.constraint(equalToConstant: 48),
            
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            hiddenButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            hiddenButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            hiddenButton.widthAnchor.constraint(equalToConstant: 32),
            hiddenButton.heightAnchor.constraint(equalToConstant: 32),
            
            rightButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            rightButton.widthAnchor.constraint(equalToConstant: 48),
            rightButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        leftButton.isHidden = isDisplayLeftButton == false
        rightButton.isHidden = isDisplayRightButton == false
        hiddenButton.isHidden = isOpenHiddenMenu == false
        
        if isOpenHiddenMenu {
            hiddenButton.addTarget(self, action: #selector(hiddenButtonTapped), for: .touchUpInside)
        }
    }
    
    func setTitle(_ name: String) {
        titleLabel.text = name
    }
    
    func isDisplayLeftButton( _ isDisplay: Bool) {
        leftButton.isHidden = isDisplay == false
    }
    
    func isDisplayRightButton( _ isDisplay: Bool) {
        rightButton.isHidden = isDisplay == false
    }
    
    func setLeftButton(
        imageName: String = "backButton_black",
        _ isDisplayLeftButton: Bool? = nil
    ) -> AnyPublisher<Void, Never> {
        if let isDisplayLeftButton = isDisplayLeftButton,
           isDisplayLeftButton == true {
            leftButton.isHidden = false
        }
        
        setLeftConfig(imageName: imageName)
        
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return leftButtonAction
            .eraseToAnyPublisher()
    }
    
    func changeLeftImage(
        imageName: String
    ) {
        leftButton.configuration?.image = UIImage(named: imageName)
    }
    
    func setRightButton(
        imageName: String,
        _ isDisplayRightButton: Bool? = nil
    ) -> AnyPublisher<Void, Never> {
        if let isDisplayRightButton = isDisplayRightButton,
            isDisplayRightButton == true {
            rightButton.isHidden = false
        }
        
        setRightConfig(imageName: imageName)
        
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return rightButtonAction
            .eraseToAnyPublisher()
    }
    
    func setHiddenEvent() -> AnyPublisher<Void, Never> {
        hiddenButtonAction
            .eraseToAnyPublisher()
    }
    
    private func setLeftConfig(imageName: String) {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(named: imageName)
        buttonConfig.imagePlacement = .all
        
        leftButton.configuration = buttonConfig
    }
    
    private func setRightConfig(imageName: String) {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(named: imageName)
        buttonConfig.imagePlacement = .all
        
        rightButton.configuration = buttonConfig
    }
}



