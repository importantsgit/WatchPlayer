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
    
    func setupCell(title: String, detail: String) {
        backgroundColor = .clear
        selectionStyle = .none
        
        titleLabel.textColor = .white
        titleLabel.text = title
        
        detailLabel.textColor = .primary400
        detailLabel.font = .boldSystemFont(ofSize: 17)
        detailLabel.text = detail
        
        accessoryImageView.image = .accessory
        
        [titleLabel, detailLabel, accessoryImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            
            accessoryImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            accessoryImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            accessoryImageView.widthAnchor.constraint(equalToConstant: 32),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 32),
            
            detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.rightAnchor.constraint(equalTo: accessoryImageView.leftAnchor, constant: -4),
        ])
    }
}
