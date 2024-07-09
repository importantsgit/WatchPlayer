//
//  PlayerSettingDetailCell.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/8/24.
//

import UIKit

final class PlayerSettingDetailCell: UITableViewCell {
    
    private var style: SettingStyle!
    
    private let titleLabel = UILabel()
    private let checkImageView = UIImageView()
    
    
    func set(_ style: SettingStyle) {
        self.style = style
        
        backgroundColor = .clear
        selectionStyle = .none
        
        checkImageView.image = style == .view ? .accessorySelected : .accessorySelectedPrimary
        
        [titleLabel, checkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            checkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            checkImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            checkImageView.widthAnchor.constraint(equalToConstant: 32),
            checkImageView.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    func configuration(title: String) {
        titleLabel.text = title
    }
    
    func setTapped(isChecked: Bool = false) {
        if style == .view {
            titleLabel.textColor = isChecked ? .primary100 : .lightGray
        }
        else {
            titleLabel.textColor = isChecked ? .primary : .lightGray
        }
        
        titleLabel.font = isChecked ? 
            .systemFont(ofSize: 17, weight: .bold) :
            .systemFont(ofSize: 17, weight: .light)
        
        checkImageView.isHidden = isChecked == false
    }
}
