//
//  Extension+AVPlayer.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/12/24.
//

import RxSwift
import AVFoundation


extension Reactive where Base: AVPlayer {
    var playerStatus: Observable<AVPlayer> {
        return self.observe(AVPlayer.self, #keyPath(AVPlayer.timeControlStatus))
            .compactMap { $0 }
    }
    

}
