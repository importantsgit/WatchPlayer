//
//  PlayerServiceMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/4/24.
//

import Foundation
import AVFoundation

final class PlayerServiceMock: PlayerServiceInterface {
    
    var player: AVPlayer?
    
    var setCallCount = 0
    func set(player: AVPlayer) {
        setCallCount += 1
        self.player = player
    }
    
    var playCallCount = 0
    func play() {
        playCallCount += 1
        
        player?.play()
    }
    
    var pauseCallCount = 0
    func pause() {
        pauseCallCount += 1
        
        player?.pause()
    }
    
    var seekForwardCallCount = 0
    func seekForward() {
        seekForwardCallCount += 1
    }
    
    var seekBackwardCallCount = 0
    func seekBackward() {
        seekBackwardCallCount += 1
    }
}
