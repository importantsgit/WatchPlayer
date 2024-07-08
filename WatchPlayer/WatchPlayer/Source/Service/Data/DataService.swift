//
//  DataService.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol DataServiceInterface {
    var isShowPermissionView: Bool { get }
    var isShowOnboardingView: Bool { get }
    var playerSetting: PlayerSetting { get }
    
    func dismissPermissionViewForever()
    func dismissOnboardingViewForever()
    func savePlayerQuality(_ quality: PlayerQuality)
    func savePlayerSpeed(_ speed: PlayerSpeed)
}

final public class DataService: DataServiceInterface, UserDefaultProtocol {
    
    struct Configuration {
        
    }
    
    private let configuration: Configuration
    
    // IntroFlow
    var isShowPermissionView: Bool = true
    var isShowOnboardingView: Bool = true
    var playerSetting: PlayerSetting = PlayerSetting()
    
    init(
        configuration: Configuration
    ) {
        self.configuration = configuration
        
        self.isShowPermissionView = getBooleanData(
            key: userDefaultKey.permission.rawValue,
            defaultValue: true
        )
        self.isShowOnboardingView = getBooleanData(
            key: userDefaultKey.onboarding.rawValue,
            defaultValue: true
        )
        
        // TODO: PlayerSetting 가져오기
    }
    
    func dismissPermissionViewForever() {
        isShowPermissionView = false
        setBooleanData(
            val: isShowPermissionView,
            key: userDefaultKey.permission.rawValue
        )
    }
    
    func dismissOnboardingViewForever() {
        isShowOnboardingView = false
        setBooleanData(
            val: isShowOnboardingView,
            key: userDefaultKey.onboarding.rawValue
        )
    }
    
    func savePlayerQuality(
        _ quality: PlayerQuality
    ) {
        self.playerSetting.quality = quality
        // TODO: 저장
        
    }
    
    func savePlayerSpeed(
        _ speed: PlayerSpeed
    ) {
        self.playerSetting.speed = speed
        // TODO: 저장
    }
}
