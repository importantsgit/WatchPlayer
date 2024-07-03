//
//  NavigationBar.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/1/24.
//

import UIKit
import RxSwift
import RxRelay

protocol NavigationBarProtocol {
    func setTitle(
        _ name: String
    )
    
    func setAttriButeTitle(
        _ name: NSAttributedString
    )
    
    func setLeftButton(
        imageName: String
    ) -> Observable<Void>
    
    func setRightButton(
        imageName: String
    ) -> Observable<Void>
    
    func setHiddenButton(
    ) -> Observable<Void>
}

extension NavigationBarProtocol {
    @discardableResult
    func setLeftButton(
        imageName: String = "Nor"
    ) -> Observable<Void> {
        setLeftButton(imageName: imageName)
    }
}

final class NavigationBarView: UIView, NavigationBarProtocol {
    
    private var leftButtonAction = PublishRelay<Void>()
    private var rightButtonAction = PublishRelay<Void>()
    private var hiddenButtonAction = PublishRelay<Void>()
    
    private let navigationBarColor: UIColor
    private let imageSize: CGFloat = 24
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .title
        
        return label
    }()
    
    private var leftButton = UIButton()
    private var rightButton = UIButton()
    private var hiddenButton = UIButton()
    
    init(
        title: String = "",
        navigationBarColor: UIColor = .white
    ){
        self.titleLabel.text = title
        self.navigationBarColor = navigationBarColor
        
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func leftButtonTapped() {
        leftButtonAction.accept(())
    }
    
    @objc private func rightButtonTapped() {
        rightButtonAction.accept(())
    }
    
    @objc private func hiddenButtonTapped() {
        hiddenButtonAction.accept(())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if navigationBarColor == .clear {
            return
        }
        
        self.layer.shadowPath = UIBezierPath(
            rect: CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: frame.height
            )).cgPath
        self.backgroundColor = navigationBarColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}

extension NavigationBarView {
    private func setupLayout() {
        
        [leftButton, titleLabel, rightButton, hiddenButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
            
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            leftButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4),
            leftButton.widthAnchor.constraint(equalToConstant: imageSize * 2),
            leftButton.heightAnchor.constraint(equalToConstant: imageSize * 2),
            
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            hiddenButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            hiddenButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            hiddenButton.widthAnchor.constraint(equalToConstant: 32),
            hiddenButton.heightAnchor.constraint(equalToConstant: 32),
            
            rightButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -4),
            rightButton.widthAnchor.constraint(equalToConstant: imageSize * 2),
            rightButton.heightAnchor.constraint(equalToConstant: imageSize * 2),
        ])
        
        leftButton.isHidden = true
        rightButton.isHidden = true
        hiddenButton.isHidden = true
        
    }
    
    func setTitle(
        _ name: String
    ) {
        titleLabel.text = name
    }
    
    func setAttriButeTitle(
        _ name: NSAttributedString
    ) {
        titleLabel.attributedText = name
    }
    
    @discardableResult
    func setLeftButton(
        imageName: String
    ) -> Observable<Void> {
        leftButton.isHidden = false
        setLeftConfig(imageName: imageName)
        
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        return leftButtonAction
            .asObservable()
    }
    
    @discardableResult
    func setRightButton(
        imageName: String
    ) -> Observable<Void> {
        rightButton.isHidden = false
        setRightConfig(imageName: imageName)
        
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return rightButtonAction
            .asObservable()
    }
    
    func setHiddenButton(
    ) -> Observable<Void> {
        hiddenButton.isHidden = false
        hiddenButton.addTarget(self, action: #selector(hiddenButtonTapped), for: .touchUpInside)
        
        return hiddenButtonAction
            .asObservable()
    }
    
    private func setLeftConfig(imageName: String) {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(named: imageName)?
            .resized(to: .init(width: imageSize, height: imageSize))
        buttonConfig.imagePlacement = .all
        
        leftButton.configuration = buttonConfig
    }
    
    private func setRightConfig(imageName: String) {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.image = UIImage(named: imageName)?
            .resized(to: .init(width: imageSize, height: imageSize))
        buttonConfig.imagePlacement = .all
        
        rightButton.configuration = buttonConfig
    }
}



