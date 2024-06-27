//
//  DataService.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol DataServiceInterface {
    var isShowPermissionView: Bool { get }
    var isShowGuideView: Bool { get }
    
    func dismissPermissionViewForever()
    func dismissGuideViewForever()
}

final public class DataService: DataServiceInterface, UserDefaultProtocol {
    
    struct Configuration {
        
    }
    
    let configuration: Configuration
    
    // IntroFlow
    var isShowPermissionView: Bool = true
    var isShowGuideView: Bool = true
    
    init(
        configuration: Configuration
    ) {
        self.configuration = configuration
        
        self.isShowPermissionView = getBooleanData(
            key: userDefaultKey.permission.rawValue,
            defaultValue: true
        )
        self.isShowGuideView = getBooleanData(
            key: userDefaultKey.guide.rawValue,
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
    
    func dismissGuideViewForever() {
        isShowGuideView = false
        setBooleanData(
            val: isShowGuideView,
            key: userDefaultKey.guide.rawValue
        )
    }
}
