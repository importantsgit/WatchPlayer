//
//  PlayerRepositoryMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/4/24.
//

import Foundation
import AVFoundation
import RxSwift

final class PlayerRepositoryMock: PlayerRepositoryInterface {

    let playerService: PlayerServiceMock
    
    init(
        playerService: PlayerServiceMock
    ) {
        self.playerService = playerService
    }
    
    var setCallCount = 0
    func set(
        player: AVPlayer,
        setting: PlayerSetting
    ) -> Observable<(PlayBackEvent, Any?)> {
        setCallCount += 1
        return playerService.set(
            player: player,
            setting: setting
        )
    }
    
    var handleEventCallCount = 0
    func handleEvent(
        _ event: PlayerCommandEvent
    ) -> Any? {
        handleEventCallCount += 1
        return playerService.handleEvent(event)
    }
    
    func handleEvent(
        _ event: SettingCommandEvent
    ) -> Any? {
        return nil
    }
}
