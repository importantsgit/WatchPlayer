//
//  PermissionViewController.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit

final class PermissionViewController: DefaultViewController {
    

    
    let presenter: PermissionPresenterProtocol
    
    init(
        presenter: PermissionPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedStringBuilder()
            .add(
                string: "WatchPlayer 앱을 사용하기 위해서\n앱 서비스 접근 권한이 필요해요",
                color: .title,
                font: .systemFont(ofSize: 20, weight: .bold),
                lineHeight: 30
            )
            .buildNSAttributedString()
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = "권한을 허용해주시면 다양한 서비스를 이용할 수 있어요!"
        subTitleLabel.textColor = .subDescription
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.textAlignment = .center

        let allowButton = UIButton()
        var allButtonTitle = AttributedString("권한을 허용할게요")
        allButtonTitle.font = .systemFont(ofSize: 16, weight: .medium)
        allButtonTitle.foregroundColor = .white

        var allowButtonConfig = UIButton.Configuration.filled()
        allowButtonConfig.attributedTitle = allButtonTitle
        allowButtonConfig.cornerStyle = .capsule
        allowButtonConfig.baseBackgroundColor = .primary
        allowButton.configuration = allowButtonConfig
        
        let permissionStack = UIStackView()
        permissionStack.axis = .vertical
        permissionStack.spacing = 32
        
        [titleLabel, subTitleLabel, allowButton, permissionStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let cameraStackView = UIStackView()
        cameraStackView.axis = .horizontal
        
        let cameraImageView = UIImageView()
        cameraImageView.image = .camera
        
        let cameraLabelView = UIView()
        let cameraTitleLabelView = UILabel()
        let cameraDescriptionLabelView = UILabel()
        
        [cameraTitleLabelView, cameraDescriptionLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cameraLabelView.addSubview($0)
        }
        
        [cameraImageView, cameraLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cameraStackView.addArrangedSubview($0)
        }
        
        let microphoneStackView = UIStackView()
        microphoneStackView.axis = .horizontal
        
        let microphoneImageView = UIImageView()
        microphoneImageView.image = .mic
        
        let microphoneLabelView = UIView()
        let microphoneTitleLabelView = UILabel()
        let microphoneDescriptionLabelView = UILabel()
        
        [microphoneTitleLabelView, microphoneDescriptionLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            microphoneLabelView.addSubview($0)
        }
        
        [microphoneImageView, microphoneLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            microphoneStackView.addArrangedSubview($0)
        }
        
        let galleryStackView = UIStackView()
        galleryStackView.axis = .horizontal
        
        let galleryImageView = UIImageView()
        galleryImageView.image = .photo
        
        let galleryLabelView = UIView()
        let galleryTitleLabelView = UILabel()
        let galleryDescriptionLabelView = UILabel()
        
        [galleryTitleLabelView, galleryDescriptionLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            galleryLabelView.addSubview($0)
        }
        
        [galleryImageView, galleryLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            galleryStackView.addArrangedSubview($0)
        }
        
        [cameraStackView, microphoneStackView, galleryStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            permissionStack.addArrangedSubview($0)
        }
        
        [cameraImageView, microphoneImageView, galleryImageView].forEach {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 32),
                $0.heightAnchor.constraint(equalToConstant: 32),
            ])
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            subTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
                        
            allowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            allowButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            allowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            allowButton.heightAnchor.constraint(equalToConstant: 48),
            
            permissionStack.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 48),
            permissionStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            permissionStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 32),
            
        ])
    }
    
    @objc func tapped() {
        
    }
}
