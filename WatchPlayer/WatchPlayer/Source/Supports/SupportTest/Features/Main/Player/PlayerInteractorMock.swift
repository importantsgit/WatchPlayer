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
    let dataRepository: DataRepositoryMock
    
    init(
        playerRepository: PlayerRepositoryMock,
        dataRepository: DataRepositoryMock
    ) {
        self.playerRepository = playerRepository
        self.dataRepository = dataRepository
    }
    
    
    var setCallCount = 0
    func set(
        player: AVPlayer
    ) -> Observable<(PlayBackEvent, Any?)> {
        setCallCount += 1
        
        let setting = dataRepository.getPlayerSetting()
        
        return playerRepository.set(
            player: player,
            setting: setting
        )
    }
    
    var handlePlayerCommandEventCallCount = 0
    func handleEvent(
        _ event: PlayerCommandEvent
    ) -> Any? {
        handlePlayerCommandEventCallCount += 1
        return playerRepository.handleEvent(event)
    }
    
    var handleSettingCommandEventCallCount = 0
    func handleEvent(
        _ event: SettingCommandEvent
    ) -> Any? {
        handleSettingCommandEventCallCount += 1
        return playerRepository.handleEvent(event)
    }
}
