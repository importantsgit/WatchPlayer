//
//  OnboardingContentViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit

final class OnboardingContentViewController: UIViewController {
    let imageView: UIImageView
    let titleLabel: UILabel
    let descriptionLabel: UILabel
    
    init(
        imageName: String,
        title: String,
        description: String
    ) {
        imageView = UIImageView(image: UIImage(named: imageName))
        titleLabel = UILabel()
        titleLabel.text = title
        descriptionLabel = UILabel()
        let description = NSAttributedStringBuilder()
            .add(
                string: description,
                font: .systemFont(
                    ofSize: 16,
                    weight: .regular
                ),
                lineHeight: 24
            )
            .buildNSAttributedString()
        descriptionLabel.attributedText = description
        descriptionLabel.numberOfLines = 0
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        let backgorundView = UIView()
        backgorundView.backgroundColor = .white
        backgorundView.layer.opacity = 0.1
        
        titleLabel.font = .systemFont(ofSize: 28, weight: .black)
        titleLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = .white
        
        [titleLabel, descriptionLabel, backgorundView, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let imageSize: CGFloat = 260
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backgorundView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            backgorundView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            backgorundView.widthAnchor.constraint(equalToConstant: imageSize),
            backgorundView.heightAnchor.constraint(equalToConstant: imageSize),
        ])
        
        backgorundView.layer.cornerRadius = imageSize / 2
    }
}
