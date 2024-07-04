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
import Photos

final class PlayerViewController: DefaultViewController {
    
    private let playerView: PlayerView
    private let playerControllerView: PlayerControllerView
    private let activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView()
    
    let presenter: PlayerPresenterProtocol
    
    
    init(
        presenter: PlayerPresenterProtocol
    ) {
        self.presenter = presenter
        self.playerView = .init(
            presenter: self.presenter as! PlayerControllerProtocol
        )
        self.playerControllerView = .init(
            presenter: self.presenter as! PlayerControllerProtocol
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(with: presenter)
        presenter.viewDidLoad()
    }
    
    override func setupLayout() {
        super.setupLayout()
    }
}

extension PlayerViewController {
    func bind(
        with presenter: PlayerPresenterProtocol
    ) {
        presenter
            .setAsset
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] asset in
                self?.setPlayerViewLayout(asset)
            })
            .disposed(by: disposeBag)
        
        presenter
            .fetchPlayerItem
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] player in
                self?.set(player: player)
            })
            .disposed(by: disposeBag)
        
        presenter
            .showController
            .subscribe(onNext: { [weak self] in
                self?.playerControllerView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        presenter
            .setLayout
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        let hideController = Observable.merge(
            presenter.hideControllerDelay.debounce(.seconds(3), scheduler: MainScheduler.instance),
            presenter.hideControllerImmediately
        )
        
        hideController
            .subscribe(onNext: { [weak self] in
                self?.playerControllerView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
}
extension PlayerViewController {
    private func set(player: AVPlayer) {
        activityIndicator?.stopAnimating()
        playerView.set(player: player)
    }
    
    private func setPlayerViewLayout(_ asset: PHAsset) {
        
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.color = .white
        activityIndicator?.style = .large
        activityIndicator?.startAnimating()
        playerView.backgroundColor = .black
        
        playerControllerView.isHidden = true

        [playerView, playerControllerView, activityIndicator!].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerView.widthAnchor.constraint(equalToConstant: view.frame.width),
            playerView.heightAnchor.constraint(equalToConstant: view.frame.width * (9/16)),
            
            playerControllerView.topAnchor.constraint(equalTo: playerView.topAnchor),
            playerControllerView.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            playerControllerView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            playerControllerView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            activityIndicator!.topAnchor.constraint(equalTo: playerView.topAnchor),
            activityIndicator!.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            activityIndicator!.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            activityIndicator!.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
        ])
    }
    
    private func setLayoutToPortrait() {
        
    }
    
    private func setLayoutToLandscape() {
        
    }
}
