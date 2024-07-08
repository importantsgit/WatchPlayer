//
//  DataRepository.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol DataRepositoryInterface {
    func dismissPermissionViewForever()
    func dismissOnboardingViewForever()
    func savePlayerQuality(_ quality: PlayerQuality)
    func savePlayerSpeed(_ speed: PlayerSpeed)
    func getPlayerSetting() -> PlayerSetting
}

final public class DataRepository: DataRepositoryInterface {
    
    private let dataService: DataServiceInterface
    
    init(
        dataService: DataServiceInterface
    ) {
        self.dataService = dataService
    }
    
    func dismissPermissionViewForever(){
        dataService.dismissPermissionViewForever()
    }
    
    func dismissOnboardingViewForever() {
        dataService.dismissOnboardingViewForever()
    }
    
    func savePlayerQuality(
        _ quality: PlayerQuality
    ) {
        dataService.savePlayerQuality(quality)
    }
    
    func savePlayerSpeed(
        _ speed: PlayerSpeed
    ) {
        dataService.savePlayerSpeed(speed)
    }
    
    func getPlayerSetting() -> PlayerSetting {
        dataService.playerSetting
    }
}
