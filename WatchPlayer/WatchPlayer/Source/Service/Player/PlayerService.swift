//
//  PlayerService.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/4/24.
//

import Foundation
import AVFoundation
import RxSwift
import RxRelay
import MediaPlayer

// MARK: 컨트롤러의 많은 기능으로 인해 무수한 func을 정의해야 함
protocol PlayerServiceInterface {
    func set(
        player: AVPlayer,
        setting: PlayerSetting
    ) -> Observable<(PlayBackEvent, Any?)>
    
    @discardableResult
    func handleEvent(_ event: PlayerCommandEvent) -> Any?
    
    @discardableResult
    func handleEvent(_ event: SettingCommandEvent) -> Any?
}

// MARK: service단에서 감지된 이벤트
enum PlayBackEvent {
    case setTimes
    case playerStatus(PlayerState)
}

// MARK: Controller를 통해 입력된 이벤트
enum PlayerCommandEvent {
    case seek(SeekType)
    
    case playButtonTapped
    case backButtonTapped
    case audioButtonTapped(isUse: Bool)
}

enum SettingCommandEvent {
    case updateQuality(PlayerQuality)
    case updateSpeed(PlayerSpeed)
}


final class PlayerService: NSObject, PlayerServiceInterface {
    
    private var sendEventToView = PublishSubject<(PlayBackEvent, Any?)>()
    private var player: AVPlayer?
    private var currentState: PlayerState = .playing
    
    private let disposeBag = DisposeBag()
    private var periodicTimeObserver: Any?
    
    func set(
        player: AVPlayer,
        setting: PlayerSetting
    ) -> Observable<(PlayBackEvent, Any?)> {
        self.player = player
        
        if let quality = setting.quality {
            self.player?.currentItem?.preferredMaximumResolution = quality.getMaxResolution()
        }
        if let speed = setting.speed {
            self.player?.rate = speed.rawValue
        }
        
        setupObservers(player: self.player)
        play()
                
        return sendEventToView
            .asObservable()
    }
    
    @discardableResult
    func handleEvent(
        _ event: PlayerCommandEvent
    ) -> Any? {
        switch event {
        case .playButtonTapped:
            return playButtonTapped()
            
        case .seek(let type):
            switch type {
            case .forward(let count):
                seekForward(count: count)
            case .rewind(let count):
                seekRewind(count: count)
            }
            
        case .backButtonTapped:
            resetService()
            return nil
            
        case .audioButtonTapped(let isUse):
            setCommandCenter(isUse: isUse)
            return isUse ? nil : player
        
        }
        
        return nil
    }
    
    func resetService() {
        currentState = .playing
        
        if let player = player {
            player.pause()
            if let observer = periodicTimeObserver {
                player.removeTimeObserver(observer)
            }
        }
        
        player?.replaceCurrentItem(with: nil)
        periodicTimeObserver = nil
        player = nil
        
        setCommandCenter(isUse: false)
        
        let oldSubject = sendEventToView
        sendEventToView = PublishSubject<(PlayBackEvent, Any?)>()
        
        // 이전 subject에 완료 이벤트 전송
        oldSubject.onCompleted()
    }
    
    @discardableResult
    func handleEvent(
        _ event: SettingCommandEvent
    ) -> Any? {
        switch event {
            
        case .updateQuality(let quality):
            player?.currentItem?.preferredMaximumResolution = quality.getMaxResolution()
            
        case .updateSpeed(let speed):
            player?.rate = speed.rawValue
            
        }
        return nil
    }
}

private extension PlayerService {
    func setupObservers(player: AVPlayer?) {
        guard let currentItem = player?.currentItem else { return }
        
        // NotificationCenter observer
        NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime, object: currentItem)
            .subscribe(onNext: { [weak self] _ in
                self?.sendEventToView.onNext((.playerStatus(.ended), nil))
                self?.currentState = .ended
            })
            .disposed(by: disposeBag)
        
        player?.rx.observe(\.timeControlStatus)
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .playing:
                    print("status playing")
                    self?.sendEventToView.onNext((.playerStatus(.playing), nil))
                case .waitingToPlayAtSpecifiedRate:
                    print("status waitingToPlayAtSpecifiedRate")
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        // KVO observers
        currentItem.rx.observe(AVPlayerItem.Status.self, #keyPath(AVPlayerItem.status))
            .subscribe(onNext: { [weak self] status in
                //print("status: \(status)")
            })
            .disposed(by: disposeBag)
        
        currentItem.rx.observe(Bool.self, #keyPath(AVPlayerItem.isPlaybackBufferFull))
            .subscribe(onNext: { [weak self] isBufferFull in
                //print("isBufferFull: \(isBufferFull)")
            })
            .disposed(by: disposeBag)
        
        currentItem.rx.observe(Bool.self, #keyPath(AVPlayerItem.isPlaybackBufferEmpty))
            .subscribe(onNext: { [weak self] isBufferEmpty in
                //print("isBufferEmpty: \(isBufferEmpty)")
            })
            .disposed(by: disposeBag)
        
        currentItem.rx.observe(Bool.self, #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp))
            .subscribe(onNext: { [weak self] isLikelyToKeepUp in
                //print("isLikelyToKeepUp: \(isLikelyToKeepUp)")
            })
            .disposed(by: disposeBag)
        
        currentItem.rx.observe([NSValue].self, #keyPath(AVPlayerItem.loadedTimeRanges))
            .subscribe(onNext: { [weak self] loadedTimeRanges in
                //print("loadedTimeRanges: \(loadedTimeRanges)")
            })
            .disposed(by: disposeBag)
        
        // Periodic time observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        periodicTimeObserver = player?.addPeriodicTimeObserver(
            forInterval: interval,
            queue: DispatchQueue.main
        ) { [weak self] currentTime in
            self?.sendEventToView.onNext((.setTimes, (currentTime, player?.currentItem?.duration)))
        }
    }
    
    func playButtonTapped() -> PlayerState {
        switch currentState {
        case .playing:
            pause()
            return .paused
            
        case .paused:
            play()
            return .playing
            
        case .ended:
            player?.seek(to: CMTime.zero, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] completed in
                if completed {
                    self?.play()
                }
            }
            return .playing
        }
    }
    
    func play() {
        guard let player = player
        else { return }
        
        player.play()
        currentState = .playing
    }
    
    func pause() {
        guard let player = player
        else { return }
        
        player.pause()
        currentState = .paused
    }
    
    func seekForward(count: Int) {
        guard let player = player,
              let currentItem = player.currentItem,
              let seekableTimeRange = currentItem.seekableTimeRanges.last?.timeRangeValue
        else { return }
        
        let skipSecond = Float64(count * 10)
        
        let currentTime = player.currentTime()
        let skipTime = CMTime(seconds: skipSecond, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        let seekTime = CMTimeAdd(currentTime, skipTime)
        
        player.seek(to: seekableTimeRange.containsTime(seekTime) ? seekTime : seekableTimeRange.end)
    }
    
    func seekRewind(count: Int) {
        guard let player = player,
              let currentItem = player.currentItem,
              let seekableTimeRange = currentItem.seekableTimeRanges.last?.timeRangeValue
        else { return }
        
        let skipSecond = Float64(count * 10)
        
        let currentTime = player.currentTime()
        let skipTime = CMTime(seconds: skipSecond, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        let seekTime = CMTimeSubtract(currentTime, skipTime)
        
        player.seek(to: seekableTimeRange.containsTime(seekTime) ? seekTime : seekableTimeRange.start)
    }
    
    private func setCommandCenter(isUse: Bool) {
        let commandCenter = MPRemoteCommandCenter.shared()
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        
        if isUse {
            var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
            nowPlayingInfo[MPMediaItemPropertyArtist] = "WatchPlayer"
            nowPlayingInfo[MPMediaItemPropertyTitle] = "영상"
            nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
            
            commandCenter.playCommand.addTarget(self, action: #selector(commandCenterPlay))
            commandCenter.pauseCommand.addTarget(self, action: #selector(commandCenterPause))
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } else {
            nowPlayingInfoCenter.nowPlayingInfo = [:]
            
            commandCenter.playCommand.removeTarget(self)
            commandCenter.pauseCommand.removeTarget(self)
            UIApplication.shared.endReceivingRemoteControlEvents()
        }
        
        commandCenter.playCommand.isEnabled = isUse
        commandCenter.pauseCommand.isEnabled = isUse
    }
    
    @objc func commandCenterPlay(
        sender: MPRemoteCommandEvent
    ) -> MPRemoteCommandHandlerStatus{
        play()
        return .success
        
    }
    
    @objc func commandCenterPause(
        sender: MPRemoteCommandEvent
    ) -> MPRemoteCommandHandlerStatus{
        pause()
        return .success
    }
    
}

