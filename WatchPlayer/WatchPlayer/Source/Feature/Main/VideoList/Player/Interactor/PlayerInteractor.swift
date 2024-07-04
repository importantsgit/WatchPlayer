//
//  PlayerInteractor.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import Foundation
import AVFoundation

protocol PlayerInteractorProtocol {
    func start(player: AVPlayer)
    func play()
    func pause()
    func seekForward()
    func seekBackward()
}

final class PlayerInteractor: PlayerInteractorProtocol {
    
    let playerRepository: PlayerRepositoryInterface
    
    init(
        playerRepository: PlayerRepositoryInterface
    ) {
        self.playerRepository = playerRepository
    }
    
    func start(player: AVPlayer) {
        playerRepository.start(player: player)
    }
    
    func play() {
        playerRepository.play()
    }
    
    func pause() {
        playerRepository.pause()
    }
    
    func seekForward() {
        playerRepository.seekForward()
    }
    
    func seekBackward() {
        playerRepository.seekBackward()
    }
}
