//
//  PlayerRepository.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/4/24.
//

import Foundation
import AVFoundation

protocol PlayerRepositoryInterface {
    func start(player: AVPlayer)
    func play()
    func pause()
    func seekForward()
    func seekBackward()
}

final class PlayerRepository: PlayerRepositoryInterface {
    
    let playerService: PlayerServiceInterface
    
    init(
        playerService: PlayerServiceInterface
    ) {
        self.playerService = playerService
    }
    
    func start(
        player: AVPlayer
    ) {
        playerService.set(player: player)
        playerService.play()
    }
    
    func play() {
        playerService.play()
    }
    
    func pause() {
        playerService.pause()
    }
    
    func seekForward() {
        playerService.seekForward()
    }
    
    func seekBackward() {
        playerService.seekBackward()
    }
    
}
