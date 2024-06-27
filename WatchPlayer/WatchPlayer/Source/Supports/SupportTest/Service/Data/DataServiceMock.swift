//
//  DataServiceMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

final public class DataServiceMock: DataServiceInterface {
    var isShowPermissionView: Bool = true
     
    var isShowGuideView: Bool = true

    init() {
    }
    
    func dismissPermissionViewForever() {
        isShowPermissionView = false
    }
    
    func dismissGuideViewForever() {
        isShowGuideView = false
    }
}

