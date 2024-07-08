//
//  DataRepositoryMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

final public class DataRepositoryMock: DataRepositoryInterface {

    let dataService: DataServiceMock
    
    init(
        dataService: DataServiceMock
    ) {
        self.dataService = dataService
    }
    
    var dismissPermissionViewForeverCallCount = 0
    func dismissPermissionViewForever() {
        dismissPermissionViewForeverCallCount += 1
        dataService.dismissPermissionViewForever()
    }
    
    var dismissOnboardingViewForeverCallCount = 0
    func dismissOnboardingViewForever() {
        dismissOnboardingViewForeverCallCount += 1
        dataService.dismissOnboardingViewForever()
    }
    
    var savePlayerQualityCallCount = 0
    func savePlayerQuality(_ quality: PlayerQuality) {
        savePlayerQualityCallCount += 1
    }
    
    var savePlayerSpeedCallCount = 0
    func savePlayerSpeed(_ speed: PlayerSpeed) {
        savePlayerSpeedCallCount += 1
    }
    
    var getPlayerSettingCallCount = 0
    func getPlayerSetting() -> PlayerSetting {
        getPlayerSettingCallCount += 1
        return dataService.playerSetting
    }
    
}
