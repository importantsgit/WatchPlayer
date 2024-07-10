//
//  PlayerSettingSectionCell.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/8/24.
//

import UIKit

final class PlayerSettingSectionCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let accessoryImageView = UIImageView()
    
    func set(_ style: SettingStyle) {
        
        backgroundColor = .clear
        selectionStyle = .none
        
        titleLabel.textColor = style == .view ? .white : .black
        
        detailLabel.textColor = style == .view ? .primary400 : .primary
        detailLabel.font = .boldSystemFont(ofSize: 17)
        
        
        accessoryImageView.image = style == .view ? .accessory : .accessoryGray
        
        [titleLabel, detailLabel, accessoryImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            
            accessoryImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            accessoryImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            accessoryImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 32),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 32),
            
            detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detailLabel.rightAnchor.constraint(equalTo: accessoryImageView.leftAnchor, constant: -4),
        ])
    }
    
    func configuration(title: String, detail: String) {
        titleLabel.text = title
        detailLabel.text = detail
    }
}
