//
//  PlayerInteractorMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import Foundation
import AVFoundation
import RxSwift

final class PlayerInteractorMock: PlayerInteractorProtocol {

    
    let playerRepository: PlayerRepositoryMock
    
    init(
        playerRepository: PlayerRepositoryMock
    ) {
        self.playerRepository = playerRepository
    }
    
    
    var setCallCount = 0
    func set(
        player: AVPlayer
    ) -> Observable<(SendFromServiceEvent, Any?)> {
        setCallCount += 1
        return playerRepository.set(player: player)
    }
    
    var handleEventCallCount = 0
    func handleEvent(
        _ event: ReceiveByServiceEvent
    ) -> Any? {
        handleEventCallCount += 1
        return playerRepository.handleEvent(event)
    }
}
