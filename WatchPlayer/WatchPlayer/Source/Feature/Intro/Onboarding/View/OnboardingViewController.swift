//
//  OnboardingViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

class OnboardingViewController: UIViewController {

    let presenter: OnboardingPresenterProtocol
    
    init(
        presenter: OnboardingPresenterProtocol
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

