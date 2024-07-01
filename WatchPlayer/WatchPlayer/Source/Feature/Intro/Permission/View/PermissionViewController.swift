//
//  PermissionViewController.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit

protocol PermissionViewProtocol {
    
}

final class PermissionViewController: DefaultViewController, PermissionViewProtocol {
    
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
        allowButton.addTarget(self, action: #selector(permissionButtonTapped), for: .touchUpInside)
        
        var allowButtonConfig = UIButton.Configuration.filled()
        allowButtonConfig.attributedTitle = allButtonTitle
        allowButtonConfig.cornerStyle = .capsule
        allowButtonConfig.baseBackgroundColor = .primary
        allowButton.configuration = allowButtonConfig
        
        let permissionStack = UIStackView()
        permissionStack.axis = .vertical
        permissionStack.alignment = .center
        permissionStack.distribution = .equalCentering
        permissionStack.spacing = 32
        
        [titleLabel, subTitleLabel, allowButton, permissionStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let cameraStackView = UIStackView()
        
        let cameraImageView = UIImageView()
        cameraImageView.image = .camera
        
        let cameraLabelView = UIView()
        let cameraTitleLabelView = UILabel()
        cameraTitleLabelView.text = "카메라 권한 설정"
        
        let cameraDescriptionLabelView = UILabel()
        cameraDescriptionLabelView.text = "영상을 찍으려면 카메라 권한이 필요해요."
        
        [cameraTitleLabelView, cameraDescriptionLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cameraLabelView.addSubview($0)
        }
        
        [cameraImageView, cameraLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cameraStackView.addArrangedSubview($0)
        }
        
        let microphoneStackView = UIStackView()
        
        let microphoneImageView = UIImageView()
        microphoneImageView.image = .mic
        
        let microphoneLabelView = UIView()
        let microphoneTitleLabelView = UILabel()
        microphoneTitleLabelView.text = "마이크 권한 설정"
        let microphoneDescriptionLabelView = UILabel()
        microphoneDescriptionLabelView.text = "영상을 찍으려면 마이크 권한이 필요해요."
        
        [microphoneTitleLabelView, microphoneDescriptionLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            microphoneLabelView.addSubview($0)
        }
        
        [microphoneImageView, microphoneLabelView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            microphoneStackView.addArrangedSubview($0)
        }
        
        let galleryStackView = UIStackView()
        
        let galleryImageView = UIImageView()
        galleryImageView.image = .photo
        
        let galleryLabelView = UIView()
        let galleryTitleLabelView = UILabel()
        galleryTitleLabelView.text = "갤러리 접근 권한 설정"
        let galleryDescriptionLabelView = UILabel()
        galleryDescriptionLabelView.text = "갤러리에 접근하기 위해 권한이 필요해요."
        galleryDescriptionLabelView.numberOfLines = 0
        
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
            $0.axis = .horizontal
            $0.spacing = 12
            $0.alignment = .center
        }
        
        [cameraImageView, microphoneImageView, galleryImageView].forEach {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 32),
                $0.heightAnchor.constraint(equalToConstant: 32),
            ])
        }
        
        [cameraTitleLabelView, microphoneTitleLabelView, galleryTitleLabelView].forEach {
            $0.font = .systemFont(ofSize: 16, weight: .bold)
        }

        [cameraDescriptionLabelView, microphoneDescriptionLabelView, galleryDescriptionLabelView].forEach {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .subTitle
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            subTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
                        
            allowButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            allowButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            allowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            allowButton.heightAnchor.constraint(equalToConstant: 48),
            
            permissionStack.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 64),
            permissionStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cameraTitleLabelView.leftAnchor.constraint(equalTo: cameraLabelView.leftAnchor),
            cameraTitleLabelView.rightAnchor.constraint(equalTo: cameraLabelView.rightAnchor),
            cameraTitleLabelView.topAnchor.constraint(equalTo: cameraLabelView.topAnchor),
            
            cameraDescriptionLabelView.topAnchor.constraint(equalTo: cameraTitleLabelView.bottomAnchor, constant: 4),
            cameraDescriptionLabelView.leftAnchor.constraint(equalTo: cameraLabelView.leftAnchor),
            cameraDescriptionLabelView.rightAnchor.constraint(equalTo: cameraLabelView.rightAnchor),
            cameraDescriptionLabelView.bottomAnchor.constraint(equalTo: cameraLabelView.bottomAnchor),
            
            microphoneTitleLabelView.leftAnchor.constraint(equalTo: microphoneLabelView.leftAnchor),
            microphoneTitleLabelView.rightAnchor.constraint(equalTo: microphoneLabelView.rightAnchor),
            microphoneTitleLabelView.topAnchor.constraint(equalTo: microphoneLabelView.topAnchor),
            
            microphoneDescriptionLabelView.topAnchor.constraint(equalTo: microphoneTitleLabelView.bottomAnchor, constant: 4),
            microphoneDescriptionLabelView.leftAnchor.constraint(equalTo: microphoneLabelView.leftAnchor),
            microphoneDescriptionLabelView.rightAnchor.constraint(equalTo: microphoneLabelView.rightAnchor),
            microphoneDescriptionLabelView.bottomAnchor.constraint(equalTo: microphoneLabelView.bottomAnchor),
            
            galleryTitleLabelView.leftAnchor.constraint(equalTo: galleryLabelView.leftAnchor),
            galleryTitleLabelView.rightAnchor.constraint(equalTo: galleryLabelView.rightAnchor),
            galleryTitleLabelView.topAnchor.constraint(equalTo: galleryLabelView.topAnchor),
            
            galleryDescriptionLabelView.topAnchor.constraint(equalTo: galleryTitleLabelView.bottomAnchor, constant: 4),
            galleryDescriptionLabelView.leftAnchor.constraint(equalTo: galleryLabelView.leftAnchor),
            galleryDescriptionLabelView.rightAnchor.constraint(equalTo: galleryLabelView.rightAnchor),
            galleryDescriptionLabelView.bottomAnchor.constraint(equalTo: galleryLabelView.bottomAnchor),
            
        ])
    }
    
    @objc func permissionButtonTapped() {
        Task {
            await presenter.permissionButtonTapped()
        }
    }
}
