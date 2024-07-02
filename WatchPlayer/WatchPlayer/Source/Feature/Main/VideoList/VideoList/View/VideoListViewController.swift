//
//  VideoListViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

final class VideoListViewController: DefaultViewController {
    
    let navigationBar: NavigationBarProtocol = NavigationBarView()
    
    private let presenter: VideoListPresenterProtocol
    
    init(
        presenter: VideoListPresenterProtocol
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
    
    override func setupLayout() {
        super.setupLayout()
    
    }
    
    override func setupNavigationBar() {
        navigationBar.setTitle("동영상 리스트")
        navigationBar.setRightButton(imageName: "")
            .subscribe(onNext: { [weak self] in
                self?.presenter.showVideoLibrary()
            })
            .disposed(by: disposeBag)
    }
}
