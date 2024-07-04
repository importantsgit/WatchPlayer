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

protocol PlayerViewProtocol {
    func set(player: AVPlayer)
    func setPip(isUse: Bool)
    func setCommandCenter(isUse: Bool)
}

class PlayerView: UIView {
    
    private var presenter: PlayerControllerProtocol
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var pipController: AVPictureInPictureController?
    private var containerView: UIView?
    
    private var disposeBag = DisposeBag()
    
    init(presenter: PlayerControllerProtocol) {
        self.presenter = presenter
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
                self?.presenter.playViewTapped()
            })
            .disposed(by: disposeBag)
    }
    
    func set(player: AVPlayer) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            // Error
        }
        
        if self.player == nil {
            self.player = player
        }
        
        if playerLayer == nil {
            playerLayer = AVPlayerLayer(player: player)
        }
        
        playerLayer?.frame = self.bounds
        layer.addSublayer(playerLayer!)
        
        let commandCenter = MPRemoteCommandCenter.shared()
        var playInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
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
    
    
    func setCommandCenter(isUse: Bool) {
        let commandCenter = MPRemoteCommandCenter.shared()
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        
        if isUse {
            var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
            nowPlayingInfo[MPMediaItemPropertyArtist] = "WatchPlayer"
            nowPlayingInfo[MPMediaItemPropertyTitle] = "영상"
            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            
            commandCenter.playCommand.addTarget(self, action: #selector(commandCenterPlay))
            commandCenter.pauseCommand.addTarget(self, action: #selector(commandCenterPause))
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } else {
            nowPlayingInfoCenter.nowPlayingInfo = [:]
            
            commandCenter.playCommand.removeTarget(self)
            commandCenter.pauseCommand.removeTarget(self)
            UIApplication.shared.endReceivingRemoteControlEvents()
        }
        
        commandCenter.playCommand.isEnabled = isUse
        commandCenter.pauseCommand.isEnabled = isUse
    }
    
}

extension PlayerView {
    
    @objc func commandCenterPlay(
    sender: MPRemoteCommandEvent
    ) -> MPRemoteCommandHandlerStatus{
        presenter
       return .success
       
    }
    @objc func commandCenterPause(
        sender: MPRemoteCommandEvent
    ) -> MPRemoteCommandHandlerStatus{
        presenter
       return .success
    }
    
    @objc func viewTapped(){
        presenter.playViewTapped()
    }
}


