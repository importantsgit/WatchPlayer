//
//  DataServiceMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

final public class DataServiceMock: DataServiceInterface {
    
    var isShowPermissionView: Bool = true
     
    var isShowOnboardingView: Bool = true
    
    var playerSetting: PlayerSetting = .init()

    init() {
    }
    
    var dismissPermissionViewForeverCallCount = 0
    func dismissPermissionViewForever() {
        dismissPermissionViewForeverCallCount += 1
        isShowPermissionView = false
    }
    
    var dismissOnboardingViewForeverCallCount = 0
    func dismissOnboardingViewForever() {
        dismissOnboardingViewForeverCallCount += 1
        isShowOnboardingView = false
    }
    
    var savePlayerQualityCallCount = 0
    func savePlayerQuality(_ quality: PlayerQuality) {
        savePlayerQualityCallCount += 1
    }
    
    var savePlayerSpeedCallCount = 0
    func savePlayerSpeed(_ speed: PlayerSpeed) {
        savePlayerSpeedCallCount += 1
    }
}

