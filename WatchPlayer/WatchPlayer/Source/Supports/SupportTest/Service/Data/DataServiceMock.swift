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
}

