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

protocol PlayerViewProtocol {
    func startPlayer(playerItem: AVPlayerItem)
    func start()
    func pause()
    func seekRewind()
    func seekForward()
}

class PlayerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerItem: AVPlayerItem?
    
    private var pipController: AVPictureInPictureController?
    private var containerView: UIView?
    
    private var periodicTimeObserver: Any?
    
    func startPlayer(playerItem: AVPlayerItem) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            // Error
        }
        
        if self.playerItem == nil {
            self.playerItem = playerItem
        }
        
        if player == nil {
            player = .init(playerItem: playerItem)
        }
        
        if playerLayer == nil {
            playerLayer = AVPlayerLayer(player: player)
        }
        
        print(self.frame)
        playerLayer?.frame = self.bounds
        layer.addSublayer(playerLayer!)
        player?.play()
    }
    
    func stop() {
        player?.replaceCurrentItem(with: nil)
    }
    
    @objc private func playerItemDidPlayToEndTime() {
        // TODO: 영상 끝났을 때 처리
    }
    
    deinit{
        player = nil
        playerLayer = nil
        playerItem = nil
    }
}

extension PlayerView: PlayerViewProtocol {
    func start() {
        
    }
    
    func pause() {
        
    }
    
    func seekRewind() {
        
    }
    
    func seekForward() {
        
    }
    
    
}
