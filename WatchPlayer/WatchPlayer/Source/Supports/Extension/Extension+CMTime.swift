//
//  Extension+CMTime.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import Foundation
import MediaPlayer

extension CMTime {
    func convertCMTimeToString()-> String {
        let timeInSeconds = CMTimeGetSeconds(self)
        
        let hours = Int(timeInSeconds) / 3600
        let minutes = Int(timeInSeconds) / 60 % 60
        let seconds = Int(timeInSeconds) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
