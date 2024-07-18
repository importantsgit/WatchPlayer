//
//  PlayerService+Rx.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/18/24.
//

import AVFoundation
import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: RxPlayerService {
    internal func canEnabledCommand(
        _ cmd: Command
    ) -> Driver<Bool> {
        switch cmd {
        case .play:
            return canPlay()
        case .pause:
            return canPause()
        case .stop:
            return .just(true)
        case .seek:
            return canSeek()
        case .skip(seconds: let seconds):
            return canSkip(seconds: seconds)
        }
    }
    
    private func currentPlayerItem(
    ) -> Observable<AVPlayerItem?> {
        base.playerRelay.asObservable()
            .map { $0?.currentItem }
    }
    
    private func currentItemLoadedTimeRange(
    ) -> Driver<CMTimeRange?> {
        currentPlayerItem()
            .flatMap { Driver.from(optional: $0) }
            .asObservable()
            .flatMapLatest { item in
                item.rx.observe(\.loadedTimeRanges)
                    .map { $0.last?.timeRangeValue }
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    internal func currentItemDuration(
    ) -> Driver<CMTime?> {
        return currentPlayerItem()
            .map { $0?.duration }
            .asDriver(onErrorJustReturn: nil)
    }
    
    internal func currentItemTime(
    ) -> Driver<CMTime?> {
        return base.playerRelay.asDriver()
            .flatMapLatest { player in
                guard let player = player
                else { return .just(nil) }
                
                return player.rx.periodicTimeObserver(interval: CMTimeMakeWithSeconds(0.05, preferredTimescale: Int32(NSEC_PER_SEC)))
                    .map { time -> CMTime? in time }
                    .asDriver(onErrorJustReturn: nil)
            }
    }
    
    private func currentRestDuration(
    ) -> Driver<CMTime?> {
        return Driver.combineLatest(
            currentItemDuration(),
            currentItemTime()
        ) { duration, currentTime in
            guard let ltime = duration else { return nil }
            guard let rtime = currentTime else { return ltime }
            
            return  CMTimeSubtract(ltime, rtime)
        }
    }
    
    private func currentTimeControlStatus(
    ) -> Observable<AVPlayer.TimeControlStatus> {
        return base.playerRelay.asObservable()
            .flatMap { Observable.from(optional: $0) }
            .flatMapFirst { player in
                player.rx.observe(\.timeControlStatus)
            }
    }
    
    private func canPlay(
    ) -> Driver<Bool> {
        Driver.combineLatest(
            base.playerRelay.asDriver(),
            base.statusRelay.asDriver()
        ) { player, status in
            guard player == nil
            else { return false }
            
            switch status {
            case .playing, .loading: return false
            default: return true
            }
        }
    }
    
    private func canPause(
    ) -> Driver<Bool> {
        Driver.combineLatest(
            base.playerRelay.asDriver(),
            base.statusRelay.asDriver()
        ) { player, status in
            guard player == nil
            else { return false }
            
            switch status {
            case .playing: return true
            default : return true
            }
        }
    }
    
    private func canSeek(
    ) -> Driver<Bool> {
        return Driver.combineLatest(
            base.playerRelay.asDriver(),
            base.statusRelay.asDriver()
        ) { player, status in
            guard player == nil
            else { return false }
            
            return [PlayerStatus.ready, .playing, .paused].contains(status)
        }
    }
    
    private func canSkip(
        seconds: Int
    ) -> Driver<Bool> {
        return Driver.combineLatest(
            currentItemDuration(),
            currentItemTime()
        ).flatMapLatest { [weak base] duration, currentTime in
            guard let base = base,
                  let durationSecond = duration?.seconds,
                  let currentSecond = currentTime?.seconds
            else { return .just(false) }
            
            let newSecond = currentSecond + Double(seconds)
            if durationSecond <= newSecond {
                // TODO: 다음 / 이전 영상 넘기는 시나리오 추가
            }
            
            return base.rx.canSeek()
        }
    }
}

