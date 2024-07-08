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
    func set(
        player: AVPlayer,
        setting: PlayerSetting
    ) -> Observable<(PlayBackEvent, Any?)>
    
    @discardableResult
    func handleEvent(_ event: PlayerCommandEvent) -> Any?
    
    @discardableResult
    func handleEvent(_ event: SettingCommandEvent) -> Any?
}

protocol SettingRepositoryInterface {
    @discardableResult
    func handleEvent(_ event: SettingCommandEvent) -> Any?
}

final class PlayerRepository: PlayerRepositoryInterface, SettingRepositoryInterface {
    
    let playerService: PlayerServiceInterface
    
    init(
        playerService: PlayerServiceInterface
    ) {
        self.playerService = playerService
    }
    
    func set(
        player: AVPlayer,
        setting: PlayerSetting
    ) -> Observable<(PlayBackEvent, Any?)> {
        playerService.set(
            player: player,
            setting: setting
        )
    }
    
    func handleEvent(
        _ event: PlayerCommandEvent
    ) -> Any? {
        playerService.handleEvent(event)
    }
    
    func handleEvent(
        _ event: SettingCommandEvent
    ) -> Any? {
        playerService.handleEvent(event)
    }
    
}
