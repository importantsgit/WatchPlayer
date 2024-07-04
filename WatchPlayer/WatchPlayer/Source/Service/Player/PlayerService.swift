//
//  PlayerService.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/4/24.
//

import Foundation
import AVFoundation

protocol PlayerServiceInterface {
    func set(player: AVPlayer)
    func play()
    func pause()
    func seekForward()
    func seekBackward()
}

final class PlayerService: PlayerServiceInterface {
    
    private var player: AVPlayer?
    
    
    func set(player: AVPlayer) {
        self.player = player
    }
    
    func play() {
        guard let player = player
        else { return }
        
        player.play()
    }
    
    func pause() {
        guard let player = player
        else { return }
        
        player.pause()
    }
    
    func seekForward() {
        guard let player = player
        else { return }
    }
    
    func seekBackward() {
        guard let player = player
        else { return }
    }
}

