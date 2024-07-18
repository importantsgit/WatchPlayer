//
//  AVPlayer+Rx.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/18/24.
//

import AVFoundation
import RxSwift

extension Reactive where Base: AVPlayer {
    func periodicTimeObserver(interval: CMTime) -> Observable<CMTime> {
        Observable.create { [weak base] observer in
            guard let player = base
            else {
                observer.onCompleted()
                return Disposables.create()
            }
            let timeObserver = player.addPeriodicTimeObserver(
                forInterval: interval,
                queue: DispatchQueue.main
            ) { time in
                    observer.onNext(time)
            }
            return Disposables.create {
                self.base.removeTimeObserver(timeObserver)
            }
        }
        // 여러 구독자가 있을 때, 가장 최근 값을 새 구독자에게 즉시 제공
        .share(replay: 1, scope: .whileConnected)
    }
}
