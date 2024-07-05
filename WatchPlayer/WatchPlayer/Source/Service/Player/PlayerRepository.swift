//
//  PlayerRepository.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/4/24.
//

import Foundation
import AVFoundation
import RxSwift

protocol PlayerRepositoryInterface {
    func set(player: AVPlayer) -> Observable<(SendFromServiceEvent, Any?)>
    
    @discardableResult
    func handleEvent(_ event: ReceiveByServiceEvent) -> Any?
}

final class PlayerRepository: PlayerRepositoryInterface {
    
    let playerService: PlayerServiceInterface
    
    init(
        playerService: PlayerServiceInterface
    ) {
        self.playerService = playerService
    }
    
    func set(
        player: AVPlayer
    ) -> Observable<(SendFromServiceEvent, Any?)> {
        playerService.set(player: player)
    }
    
    func handleEvent(
        _ event: ReceiveByServiceEvent
    ) -> Any? {
        playerService.handleEvent(event)
    }
    
}
