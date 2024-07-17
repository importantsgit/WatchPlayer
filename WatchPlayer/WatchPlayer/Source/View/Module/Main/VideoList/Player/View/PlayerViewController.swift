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

enum PlayerControllerVisibility {
    case show
    case hideDelay
    case hideImmediately
}

enum PlayerViewControllerUIUpdateEvent {
    case didLoadPlayer
    case setTitle(title: String)
    case updateLayout(style: LayoutStyle)
    case updateAudioControllerVisibility(isVisible: Bool)
    case updateSettingViewVisibility(isVisible: Bool)
    case updateSettingPopupVisibility(isVisible: Bool)
    case updateControllerVisibility(isVisible: PlayerControllerVisibility)
    
}
protocol PlayerViewControllerProtocol: AnyObject {
    func handle(event: PlayerViewControllerUIUpdateEvent)
}

final class PlayerViewController: DefaultViewController {
    
    // MARK: - Properties
    let presenter: PlayerPresenterProtocol
    private var layoutConstraints: [NSLayoutConstraint]?
    
    // MARK: - UI Components
    private let navigationBar = NavigationBarView()
    private let playerView: PlayerView
    private let controllerView: PlayerControllerView
    private let audioControllerView: PlayerAudioControllerView
    private let settingView: PlayerSettingView
    private let settingPopup: PlayerSettingPopup
    private var activityIndicator = UIActivityIndicatorView()
    
    private let hideControllerDelay = PublishRelay<Void>()
    
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
        setPlayerViewLayout()
        presenter.viewDidLoad()
        
        hideControllerDelay
            .debounce(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.controllerView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationBar.setLeftButton()
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.presenter.backButtonTapped()
            })
            .disposed(by: disposeBag)
        
        navigationBar.setRightButton(imageName: "delete")
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.presenter.deleteButtonTapped()
            })
            .disposed(by: disposeBag)
    }
    
    deinit{
        print("PlayerViewController deinit")
    }
}

extension PlayerViewController {

    private func setPlayerViewLayout() {
        
        activityIndicator.color = .white
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        playerView.backgroundColor = .black
        
        controllerView.isHidden = true
        audioControllerView.isHidden = true
        settingView.isHidden = true
        settingPopup.isHidden = true
    
        [playerView, controllerView, audioControllerView, settingView, activityIndicator, navigationBar, settingPopup].forEach {
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
            navigationBar.heightAnchor.constraint(equalToConstant: 48),
            
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
            
            settingView.topAnchor.constraint(equalTo: playerView.topAnchor),
            settingView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            settingView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            settingView.widthAnchor.constraint(equalToConstant: 334),
            
            activityIndicator.topAnchor.constraint(equalTo: playerView.topAnchor),
            activityIndicator.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
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
            
            settingView.topAnchor.constraint(equalTo: playerView.topAnchor),
            settingView.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            settingView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            settingView.widthAnchor.constraint(equalToConstant: 334),
            
            activityIndicator.topAnchor.constraint(equalTo: playerView.topAnchor),
            activityIndicator.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
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
            
            activityIndicator.topAnchor.constraint(equalTo: playerView.topAnchor),
            activityIndicator.leftAnchor.constraint(equalTo: playerView.leftAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: playerView.rightAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            
            settingPopup.topAnchor.constraint(equalTo: view.topAnchor),
            settingPopup.leftAnchor.constraint(equalTo: view.leftAnchor),
            settingPopup.rightAnchor.constraint(equalTo: view.rightAnchor),
            settingPopup.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        return constraints
    }
    

}

extension PlayerViewController: PlayerViewControllerProtocol {
    
    @MainActor
    func handle(event: PlayerViewControllerUIUpdateEvent) {
        switch event {
        case .didLoadPlayer:
            activityIndicator.stopAnimating()
            
        case .setTitle(let title):
            navigationBar.setTitle(title)

        case .updateLayout(let style):
            view.setNeedsUpdateConstraints()
            NSLayoutConstraint.deactivate(layoutConstraints ?? [])
            
            let newConstraints: [NSLayoutConstraint]
            switch style {
            case .landscape:
                newConstraints = setLayoutToLandscape()
            case .portrait:
                newConstraints = setLayoutToPortrait()
            case .fullPortrait:
                newConstraints = setLayoutToFullPortrait()
            }
            
            NSLayoutConstraint.activate(newConstraints)
            layoutConstraints = newConstraints
            
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.playerView.handleEvent(.updateLayout)
            }
            
        case .updateAudioControllerVisibility(let isVisible):
            audioControllerView.isHidden = (isVisible == false)
            
        case .updateSettingViewVisibility(let isVisible):
            settingView.isHidden = (isVisible == false)
            
        case .updateSettingPopupVisibility(let isVisible):
            settingPopup.isHidden = (isVisible == false)
            
        case .updateControllerVisibility(let isVisible):
            switch isVisible {
            case .show:
                controllerView.isHidden = false
                
            case .hideImmediately:
                controllerView.isHidden = true
                
            case .hideDelay:
                hideControllerDelay.accept(())
            }
        }
    }
    
    
}
