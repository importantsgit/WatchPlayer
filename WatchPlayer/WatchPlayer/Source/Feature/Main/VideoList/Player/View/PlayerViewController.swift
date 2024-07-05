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
    private let controllerView: PlayerControllerView
    private let activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView()
    
    let presenter: PlayerPresenterProtocol
    
    private var layoutConstraints: [NSLayoutConstraint]?
    
    
    init(
        presenter: PlayerPresenterProtocol,
        playerView: PlayerView,
        controllerView: PlayerControllerView
        
    ) {
        self.presenter = presenter
        self.playerView = playerView
        self.controllerView = controllerView
        super.init(nibName: nil, bundle: nil)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
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
            .fetchPlayerLayer
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] playerLayer in
                self?.set(playerLayer: playerLayer)
            })
            .disposed(by: disposeBag)
        
        presenter
            .showController
            .subscribe(onNext: { [weak self] in
                self?.controllerView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        presenter
            .setLayout
            .subscribe(onNext: { [weak self] style in
                guard let self = self else { return }
                self.view.setNeedsUpdateConstraints()
                NSLayoutConstraint.deactivate(self.layoutConstraints ?? [])
                
                let newConstraints: [NSLayoutConstraint]
                switch style {
                case .landscape:
                    newConstraints = self.setLayoutToLandscape()
                case .portrait:
                    newConstraints = self.setLayoutToPortrait()
                }
                
                NSLayoutConstraint.activate(newConstraints)
                self.layoutConstraints = newConstraints
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        let hideController = Observable.merge(
            presenter.hideControllerDelay.debounce(.seconds(3), scheduler: MainScheduler.instance),
            presenter.hideControllerImmediately
        )
        
        hideController
            .subscribe(onNext: { [weak self] in
                self?.controllerView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
}
extension PlayerViewController {
    private func set(playerLayer: AVPlayerLayer) {
        activityIndicator?.stopAnimating()
        playerView.set(playerLayer: playerLayer)
    }
    
    private func setPlayerViewLayout(_ asset: PHAsset) {
        
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.color = .white
        activityIndicator?.style = .large
        activityIndicator?.startAnimating()
        playerView.backgroundColor = .black
        
        controllerView.isHidden = true

        [playerView, controllerView, activityIndicator!].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        

        layoutConstraints = setInitialLayout()
         NSLayoutConstraint.activate(layoutConstraints!)
    }
    
    private func setInitialLayout() -> [NSLayoutConstraint] {
        if view.frame.width > view.frame.height {
            return setLayoutToLandscape()
        } else {
            return setLayoutToPortrait()
        }
    }
    
    private func setLayoutToPortrait(
    ) -> [NSLayoutConstraint] {
        let constraints = [
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 9.0 / 16.0),
            
            controllerView.topAnchor.constraint(equalTo: playerView.topAnchor),
            controllerView.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            controllerView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            controllerView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            activityIndicator!.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            activityIndicator!.centerYAnchor.constraint(equalTo: playerView.centerYAnchor)
        ]
        return constraints
    }
    
    private func setLayoutToLandscape(
    ) -> [NSLayoutConstraint] {
        let constraints = [
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            controllerView.topAnchor.constraint(equalTo: playerView.topAnchor),
            controllerView.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            controllerView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            controllerView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            activityIndicator!.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            activityIndicator!.centerYAnchor.constraint(equalTo: playerView.centerYAnchor)
        ]
        return constraints
    }
}
