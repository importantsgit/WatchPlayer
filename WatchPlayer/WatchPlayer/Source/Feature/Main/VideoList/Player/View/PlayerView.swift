//
//  PlayerView.swift
//  WatchPlayer
//
//  Created by Importants on 7/3/24.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import RxSwift
import RxGesture

protocol PlayerViewProtocol: AnyObject {
    func set(playerLayer: AVPlayerLayer)
    func setPip(isUse: Bool)
    func setLayout()
}

class PlayerView: UIView {
    
    weak var presenter: PlayerControllerProtocol?
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var pipController: AVPictureInPictureController?
    private var containerView: UIView?
    
    private var disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupTappedGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTappedGesture() {
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.handleContollerEvent(.playViewTapped)
            })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
    }
}

extension PlayerView: PlayerViewProtocol {
    func set(playerLayer: AVPlayerLayer) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            // Error
        }
        
        self.playerLayer = playerLayer
        layer.addSublayer(self.playerLayer!)
        self.setNeedsLayout()
    }
    
    func setLayout() {
        self.playerLayer?.frame = self.bounds
    }
    
    func setPip(isUse: Bool) {
        if  isUse &&
                pipController == nil &&
                AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(playerLayer: self.playerLayer!)
            pipController?.requiresLinearPlayback = true
            pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        }
        else {
            pipController = nil
        }
    }
}
