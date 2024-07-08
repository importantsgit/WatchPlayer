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
    
    func setupCell(_ title: String) {
        backgroundColor = .clear
        selectionStyle = .none
        
        titleLabel.textColor = .white
        titleLabel.text = title
        
        [titleLabel, detailLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
        
        func set(title: String) {
            titleLabel.text = title
            
        }
    }
}
