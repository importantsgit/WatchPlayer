//
//  PermissionViewController.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit

final class PermissionViewController: UIViewController {
    
    let presenter: PermissionPresenterProtocol
    
    init(
        presenter: PermissionPresenterProtocol
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
