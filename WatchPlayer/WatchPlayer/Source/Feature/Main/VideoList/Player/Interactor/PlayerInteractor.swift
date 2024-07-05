//
//  PlayerInteractor.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import Foundation
import AVFoundation
import RxSwift

protocol PlayerInteractorProtocol {
    func set(player: AVPlayer) -> Observable<(SendFromServiceEvent, Any?)>
    
    @discardableResult
    func handleEvent(_ event: ReceiveByServiceEvent) -> Any?
}

final class PlayerInteractor: PlayerInteractorProtocol {
    
    let playerRepository: PlayerRepositoryInterface
    
    init(
        playerRepository: PlayerRepositoryInterface
    ) {
        self.playerRepository = playerRepository
    }
    
    func set(
        player: AVPlayer
    ) -> Observable<(SendFromServiceEvent, Any?)> {
        playerRepository.set(player: player)
    }
    
    func handleEvent(
        _ event: ReceiveByServiceEvent
    ) -> Any? {
        playerRepository.handleEvent(event)
    }
}
