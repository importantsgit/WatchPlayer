//
//  GuideViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

class GuideViewController: UIViewController {

    let presenter: GuidePresenterProtocol
    
    init(
        presenter: GuidePresenterProtocol
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
}

