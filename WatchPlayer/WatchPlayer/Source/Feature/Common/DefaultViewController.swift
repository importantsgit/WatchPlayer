//
//  DefaultViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/27/24.
//

import UIKit
import RxSwift

class DefaultViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {}
    
    func setupLayout() {
        view.backgroundColor = .systemBackground
    }
}
