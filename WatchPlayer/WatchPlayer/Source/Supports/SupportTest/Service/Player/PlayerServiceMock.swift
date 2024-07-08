//
//  PlayerServiceMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/4/24.
//

import Foundation
import AVFoundation
import RxSwift

final class PlayerServiceMock: PlayerServiceInterface {

    private let sendEventToView = PublishSubject<(PlayBackEvent, Any?)>()
    private var player: AVPlayer?
    
    private let disposeBag = DisposeBag()
    private var periodicTimeObserver: Any?
    
    var setCallCount = 0
    func set(
        player: AVPlayer,
        setting: PlayerSetting
    ) -> Observable<(PlayBackEvent, Any?)> {
        setCallCount += 1
        return sendEventToView
            .asObservable()
    }
    
    var PlayerCommandHandleEventCallCount = 0
    func handleEvent(
        _ event: PlayerCommandEvent
    ) -> Any? {
        PlayerCommandHandleEventCallCount += 1
        return nil
    }
    
    var SettingCommandHandleEventCallCount = 0
    func handleEvent(
        _ event: SettingCommandEvent
) -> Any? {
        SettingCommandHandleEventCallCount += 1
        return nil
    }
}

extension PlayerServiceMock {
    func setupObservers(player: AVPlayer?) {
        guard let currentItem = player?.currentItem else { return }
        
        // NotificationCenter observer
        NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime, object: currentItem)
            .subscribe(onNext: { [weak self] _ in
                self?.sendEventToView.onNext((.didPlayToEndTime, nil))
            })
            .disposed(by: disposeBag)
        
        // KVO observers
        currentItem.rx.observe(AVPlayerItem.Status.self, #keyPath(AVPlayerItem.status))
            .subscribe(onNext: { [weak self] status in
                print("status: \(status)")
            })
            .disposed(by: disposeBag)
        
        currentItem.rx.observe(Bool.self, #keyPath(AVPlayerItem.isPlaybackBufferFull))
            .subscribe(onNext: { [weak self] isBufferFull in
                print("isBufferFull: \(isBufferFull)")
            })
            .disposed(by: disposeBag)
        
        currentItem.rx.observe(Bool.self, #keyPath(AVPlayerItem.isPlaybackBufferEmpty))
            .subscribe(onNext: { [weak self] isBufferEmpty in
                print("isBufferEmpty: \(isBufferEmpty)")
            })
            .disposed(by: disposeBag)
        
        currentItem.rx.observe(Bool.self, #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp))
            .subscribe(onNext: { [weak self] isLikelyToKeepUp in
                print("isLikelyToKeepUp: \(isLikelyToKeepUp)")
            })
            .disposed(by: disposeBag)
        
        currentItem.rx.observe([NSValue].self, #keyPath(AVPlayerItem.loadedTimeRanges))
            .subscribe(onNext: { [weak self] loadedTimeRanges in
                print("loadedTimeRanges: \(loadedTimeRanges)")
            })
            .disposed(by: disposeBag)
        
        // Periodic time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        periodicTimeObserver = player?.addPeriodicTimeObserver(
            forInterval: interval,
            queue: DispatchQueue.main
        ) { [weak self] currentTime in
            guard let self = self else { return }
            self.sendEventToView.onNext((.setTimes, (currentTime, player?.currentItem?.duration)))
        }
    }
    
    func playButtonTapped() -> PlayerState {
        switch player?.timeControlStatus {
        case .playing:
            print("playing")
            pause()
            return .paused
        case .paused:
            print("pause")
            play()
            return .playing
        default:
            print("default")
            return .ended
        }
    }
    
    func play() {
        guard let player = player
        else { return }
        
        player.play()
    }
    
    func pause() {
        guard let player = player
        else { return }
        
        player.pause()
    }
    
    func seekForward(count: Int) {
        guard let player = player
        else { return }
    }
    
    func seekRewind(count: Int) {
        guard let player = player
        else { return }
    }
    
}
