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
    
    func dismissPermissionViewForever()
    func dismissOnboardingViewForever()
}

final public class DataService: DataServiceInterface, UserDefaultProtocol {
    
    struct Configuration {
        
    }
    
    private let configuration: Configuration
    
    // IntroFlow
    var isShowPermissionView: Bool = true
    var isShowOnboardingView: Bool = true
    
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
}
