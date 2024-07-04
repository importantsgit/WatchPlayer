//
//  PlayerRepositoryMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/4/24.
//

import Foundation
import AVFoundation

final class PlayerRepositoryMock: PlayerRepositoryInterface {
    
    let playerService: PlayerServiceMock
    
    init(
        playerService: PlayerServiceMock
    ) {
        self.playerService = playerService
    }
    
    var startCallCount = 0
    func start(player: AVPlayer) {
        startCallCount += 1
        playerService.set(player: player)
        playerService.play()
    }
    
    var playCallCount = 0
    func play() {
        playCallCount += 1
        playerService.play()
    }
    
    var pauseCallCount = 0
    func pause() {
        pauseCallCount += 1
        playerService.pause()
    }
    
    var seekForwardCallCount = 0
    func seekForward() {
        seekForwardCallCount += 1
        playerService.seekForward()
    }
    
    var seekBackwardCallCount = 0
    func seekBackward() {
        seekBackwardCallCount += 1
        playerService.seekBackward()
    }
    
    
}
