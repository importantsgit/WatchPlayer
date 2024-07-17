//
//  PlayerInteractorMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import Foundation
import AVFoundation
import RxSwift
import Photos

final class PlayerInteractorMock: PlayerInteractorProtocol {

    let libraryRepository: LibraryRepositoryMock
    let playerRepository: PlayerRepositoryMock
    let dataRepository: DataRepositoryMock
    
    init(
        libraryRepository: LibraryRepositoryMock,
        playerRepository: PlayerRepositoryMock,
        dataRepository: DataRepositoryMock
    ) {
        self.libraryRepository = libraryRepository
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
    
    var deleteAssetCallCount = 0
    func deleteAsset() {
        deleteAssetCallCount += 1
    }
    
    var fetchAVPlayerItemCallCount = 0
    func fetchAVPlayerItem(_ asset: PHAsset) async throws -> AVPlayerItem {
        fetchAVPlayerItemCallCount += 1
        return try await libraryRepository.fetchAVPlayerItem(asset)
    }
    
}
