//
//  PlayerDefine.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import Foundation
import AVFoundation
import UIKit

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
    case portrait       // 세로 (작은)
    case fullPortrait   // 세로 (큰)
    case landscape      // 가로 
    
    func getOrientation(
    ) -> UIInterfaceOrientationMask {
        switch self {
        case .fullPortrait:
            return .portrait
        case .portrait:
            return .portrait
        case .landscape:
            return .landscape
        }
    }
}

enum PlayerGravity {
    case resize
    case resizeAspect
    
    static func getValueFromIndex(
        _ index: Int
    ) -> PlayerGravity {
        switch index {
        case 0: return .resizeAspect
        case 1: return .resize
        default: fatalError()
        }
    }
    
    func getGravity(
    ) -> AVLayerVideoGravity {
        switch self {
        case .resizeAspect:
            return .resizeAspect
        case .resize:
            return .resize
        }
    }
}

enum PlayerSpeed: Float {
    case X2_0 = 2.0
    case X1_5 = 1.5
    case X1_25 = 1.25
    case X1_0 = 1.0
    case X0_5 = 0.5
    
    static func getValueFromIndex(
        _ index: Int
    ) -> PlayerSpeed {
        switch index {
        case 0: return .X0_5
        case 1: return .X1_0
        case 2: return .X1_25
        case 3: return .X1_5
        case 4: return .X2_0
        default: fatalError()
        }
    }
}

enum PlayerQuality {
    case auto
    case X1080
    case X720
    case X480
    
    static func getValueFromIndex(
        _ index: Int
    ) -> PlayerQuality {
        switch index {
        case 0: return .auto
        case 1: return .X1080
        case 2: return .X720
        case 3: return .X480
        default:
            fatalError()
        }
    }
    
    func getMaxResolution(
    ) -> CGSize {
        switch self {
        case .auto:     .zero
        case .X1080:     CGSize(width: 1920.0, height: 1080.0)
        case .X720:   CGSize(width: 1280.0, height: 720.0)
        case .X480:      CGSize(width: 854.0, height: 480.0)
        }
    }
}

struct PlayerSetting {
    var speed: PlayerSpeed?
    var quality: PlayerQuality?
}
