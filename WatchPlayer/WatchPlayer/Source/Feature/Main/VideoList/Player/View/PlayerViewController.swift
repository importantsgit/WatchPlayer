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
    private let navigationBar = NavigationBarView()
    private let playerView: PlayerView
    private let controllerView: PlayerControllerView
    private let audioControllerView: PlayerAudioControllerView
    private let settingView: PlayerSettingView
    private let settingPopup: PlayerSettingPopup
    private let activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView()
    
    let presenter: PlayerPresenterProtocol
    
    private var layoutConstraints: [NSLayoutConstraint]?
    
    
    init(
        presenter: PlayerPresenterProtocol,
        playerView: PlayerView,
        controllerView: PlayerControllerView,
        audioControllerView: PlayerAudioControllerView,
        settingView: PlayerSettingView,
        settingPopup: PlayerSettingPopup
    ) {
        self.presenter = presenter
        self.playerView = playerView
        self.controllerView = controllerView
        self.audioControllerView = audioControllerView
        self.settingView = settingView
        self.settingPopup = settingPopup
        
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
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationBar.setLeftButton()
            .subscribe(onNext: { [weak self] in
                self?.presenter.backButtonTapped()
            })
            .disposed(by: disposeBag)
        
        navigationBar.setRightButton(imageName: "delete")
            .subscribe(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
    }
}

extension PlayerViewController {
    func bind(
        with presenter: PlayerPresenterProtocol
    ) {
        presenter
            .playerTitle
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                self?.setPlayerViewLayout()
                self?.navigationBar.setTitle(title)
                self?.controllerView.handleEvent(.setTitle(title: title))
                self?.audioControllerView.handleEvent(.setTitle(title: title))
            })
            .disposed(by: disposeBag)
        
        presenter
            .didLoadPlayer
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.activityIndicator?.stopAnimating()
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
                case .fullPortrait:
                    newConstraints = self.setLayoutToFullPortrait()
                }
                
                NSLayoutConstraint.activate(newConstraints)
                self.layoutConstraints = newConstraints
                
                UIView.animate(withDuration: 0.1) {
                    self.view.layoutIfNeeded()
                } completion: { _ in
                    self.playerView.handleEvent(.updateLayout)
                }
            })
            .disposed(by: disposeBag)
        
        presenter
            .showAudioController
            .subscribe(onNext: { [weak self] isShow in
                self?.audioControllerView.isHidden = (isShow == false)
            })
            .disposed(by: disposeBag)
        
        presenter
            .showSettingView
            .subscribe(onNext: { [weak self] isShow in
                self?.settingView.isHidden = (isShow == false)
            })
            .disposed(by: disposeBag)
        
        presenter
            .showSettingPopup
            .subscribe(onNext: { [weak self] isShow in
                self?.settingPopup.isHidden = (isShow == false)
            })
            .disposed(by: disposeBag)
        
        presenter
            .showController
            .subscribe(onNext: { [weak self] in
                self?.controllerView.isHidden = false
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

    
    private func setPlayerViewLayout() {
        
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.color = .white
        activityIndicator?.style = .large
        activityIndicator?.startAnimating()
        playerView.backgroundColor = .black
        
        controllerView.isHidden = true
        audioControllerView.isHidden = true
        settingView.isHidden = true
        settingPopup.isHidden = true
    
        [playerView, controllerView, audioControllerView, settingView, activityIndicator!, navigationBar, settingPopup].forEach {
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
        navigationBar.isHidden = false
        
        let constraints = [
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 56),
            
            playerView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 9.0 / 16.0),
            
            controllerView.topAnchor.constraint(equalTo: playerView.topAnchor),
            controllerView.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            controllerView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            controllerView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            audioControllerView.topAnchor.constraint(equalTo: playerView.topAnchor),
            audioControllerView.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            audioControllerView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            audioControllerView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            activityIndicator!.topAnchor.constraint(equalTo: playerView.topAnchor),
            activityIndicator!.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            activityIndicator!.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            activityIndicator!.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            settingPopup.topAnchor.constraint(equalTo: view.topAnchor),
            settingPopup.leftAnchor.constraint(equalTo: view.leftAnchor),
            settingPopup.rightAnchor.constraint(equalTo: view.rightAnchor),
            settingPopup.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        return constraints
    }
    
    private func setLayoutToFullPortrait(
    ) -> [NSLayoutConstraint] {
        navigationBar.isHidden = true
        
        let constraints = [
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            controllerView.topAnchor.constraint(equalTo: playerView.topAnchor),
            controllerView.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            controllerView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            controllerView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            audioControllerView.topAnchor.constraint(equalTo: playerView.topAnchor),
            audioControllerView.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            audioControllerView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            audioControllerView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            activityIndicator!.topAnchor.constraint(equalTo: playerView.topAnchor),
            activityIndicator!.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            activityIndicator!.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            activityIndicator!.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            settingPopup.topAnchor.constraint(equalTo: view.topAnchor),
            settingPopup.leftAnchor.constraint(equalTo: view.leftAnchor),
            settingPopup.rightAnchor.constraint(equalTo: view.rightAnchor),
            settingPopup.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        return constraints
    }
    
    private func setLayoutToLandscape(
    ) -> [NSLayoutConstraint] {
        navigationBar.isHidden = true
        
        let constraints = [
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            controllerView.topAnchor.constraint(equalTo: playerView.topAnchor),
            controllerView.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            controllerView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            controllerView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            audioControllerView.topAnchor.constraint(equalTo: playerView.topAnchor),
            audioControllerView.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            audioControllerView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            audioControllerView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            settingView.topAnchor.constraint(equalTo: playerView.topAnchor),
            settingView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            settingView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            settingView.widthAnchor.constraint(equalToConstant: 334),
            
            activityIndicator!.topAnchor.constraint(equalTo: playerView.topAnchor),
            activityIndicator!.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            activityIndicator!.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            activityIndicator!.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
        ]
        return constraints
    }
}
