//
//  PlayerSettingDetailCell.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/8/24.
//

import UIKit

final class PlayerSettingDetailCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let checkImageView = UIImageView()
    
    func setupCell(_ title: String) {
        backgroundColor = .clear
        selectionStyle = .none
        
        titleLabel.text = title
        
        [titleLabel, checkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            checkImageView.widthAnchor.constraint(equalToConstant: 42),
            checkImageView.heightAnchor.constraint(equalToConstant: 42),
        ])
    }
    
    func setTapped(isChecked: Bool = false) {
        titleLabel.textColor = isChecked ? .primary100 : .lightGray
        titleLabel.font = isChecked ? .systemFont(ofSize: 17, weight: .black) : .systemFont(ofSize: 17, weight: .light)
        checkImageView.isHidden = isChecked == false
    }
}
