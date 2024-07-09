//
//  PlayerSettingHeaderView.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/8/24.
//

import UIKit
import RxRelay

struct PlayerSettingViewActions {
    let closeButtonTapped: PublishRelay<Void>
}

final class PlayerSettingHeaderView: UIView {
    private let style: SettingStyle
    private let titleLabel = UILabel()
    private let closeButton = UIButton()
    private var actions: PlayerSettingViewActions?
    
    init(
        style: SettingStyle
    ) {
        self.style = style
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeaderViewActions(_ actions: PlayerSettingViewActions) {
        self.actions = actions
    }

    func setupLayout() {
        titleLabel.text = "설정"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = style == .view ? .white : .black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        closeButton.configuration = .plain()
        closeButton.configuration?.image = UIImage(named: style == .view ? "close" : "closeBlack")?
            .resized(to: .init(width: 36, height: 36))
        closeButton.configuration?.imagePlacement = .all
        
        [titleLabel, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
        ])
    }
    
    func updateTitle(_ title: String) {
        self.titleLabel.text = title
    }

    
    @objc func closeButtonTapped() {
        actions?.closeButtonTapped.accept(())
    }
    
}

