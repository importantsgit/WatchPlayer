//
//  SettingViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

final class SettingViewController: DefaultViewController {
    
    let presenter: SettingPresenterProtocol
    
    init(
        presenter: SettingPresenterProtocol
    ) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

