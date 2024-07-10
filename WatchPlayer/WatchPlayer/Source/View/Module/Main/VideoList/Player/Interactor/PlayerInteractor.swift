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
    func set(
        player: AVPlayer
    ) -> Observable<(PlayBackEvent, Any?)>
    
    @discardableResult
    func handleEvent(_ event: PlayerCommandEvent) -> Any?
    
    @discardableResult
    func handleEvent(_ event: SettingCommandEvent) -> Any?
    
    func deleteAsset()
}

final class PlayerInteractor: PlayerInteractorProtocol {
    
    let libraryRepository: LibraryRepositoryInterface
    let playerRepository: PlayerRepositoryInterface
    let dataRepository: DataRepositoryInterface
    
    init(
        libraryRepository: LibraryRepositoryInterface,
        playerRepository: PlayerRepositoryInterface,
        dataRepository: DataRepositoryInterface
    ) {
        self.libraryRepository = libraryRepository
        self.playerRepository = playerRepository
        self.dataRepository = dataRepository
    }
    
    func set(
        player: AVPlayer
    ) -> Observable<(PlayBackEvent, Any?)> {
        let setting = dataRepository.getPlayerSetting()
        
        return playerRepository.set(
            player: player,
            setting: setting
        )
    }
    
    func handleEvent(
        _ event: PlayerCommandEvent
    ) -> Any? {
        playerRepository.handleEvent(event)
    }
    
    func handleEvent(
        _ event: SettingCommandEvent
    ) -> Any? {
        playerRepository.handleEvent(event)
    }
    
    func deleteAsset() {
        
    }
    
}
