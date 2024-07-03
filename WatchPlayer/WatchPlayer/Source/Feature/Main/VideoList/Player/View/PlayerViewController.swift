//
//  PlayerViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import Foundation
import AVKit
import RxSwift
import RxRelay

final class PlayerViewController: DefaultViewController {
    
    let navigationBar: NavigationBarProtocol = NavigationBarView()
    var playerViewController: AVPlayerViewController = .init()
    
    let presenter: PlayerPresenterProtocol

    
    init(
        presenter: PlayerPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        bind(with: presenter)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        let navigationBar = navigationBar as! UIView
        
        addChild(playerViewController)
        playerViewController.didMove(toParent: self)
        
        [playerViewController.view, navigationBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 56),
            
            playerViewController.view.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            playerViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            playerViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            playerViewController.view.heightAnchor.constraint(equalToConstant: 300)
            
        ])
        
    }
    
    override func setupNavigationBar() {
        navigationBar.setTitle("동영상 리스트")
        navigationBar.setLeftButton()
            .subscribe(onNext: { [weak self] in
                self?.presenter.backButtonTapped()
            })
            .disposed(by: disposeBag)
    }
}

extension PlayerViewController {
    func bind(
        with presenter: PlayerPresenterProtocol
    ) {
        presenter
            .fetchPlayerItem
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
            self?.play(item: item)
        })
        .disposed(by: disposeBag)
    }
    
    func play(item: AVPlayerItem) {
        let player = AVPlayer(playerItem: item)
        playerViewController.player = player
        player.play()
    }
}
