//
//  PlayerDefine.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import Foundation

enum SeekType {
    case forward(count: Int)
    case rewind(count: Int)
}

enum PlayerState {
    case playing
    case paused
    case ended
}

enum LayoutStyle {
    case portrait
    case landscape
}

enum Quality {
    case high
    case middle
    case low
    
    func getMaxResolution(
    ) -> CGSize {
        switch self {
        case .high:     CGSize(width: 1920.0, height: 1080.0)
        case .middle:   CGSize(width: 1280.0, height: 720.0)
        case .low:      CGSize(width: 854.0, height: 480.0)
        }
    }
}
