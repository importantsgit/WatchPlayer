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
    func set(player: AVPlayer) -> Observable<(SendFromServiceEvent, Any?)>
    
    @discardableResult
    func handleEvent(_ event: ReceiveByServiceEvent) -> Any?
}

// MARK: service단에서 감지된 이벤트
enum SendFromServiceEvent {
    case didPlayToEndTime
    case setTimes
}

// MARK: Controller를 통해 입력된 이벤트
enum ReceiveByServiceEvent {
    case seek(SeekType)
    
    case setQuality(Quality)
    
    case playButtonTapped
    case backButtonTapped
    case audioButtonTapped(isUse: Bool)
}


final class PlayerService: NSObject, PlayerServiceInterface {
    
    private let sendEventToView = PublishSubject<(SendFromServiceEvent, Any?)>()
    private var player: AVPlayer?
    
    private let disposeBag = DisposeBag()
    private var periodicTimeObserver: Any?
    
    func set(
        player: AVPlayer
    ) -> Observable<(SendFromServiceEvent, Any?)> {
        self.player = player
        setupObservers(player: self.player)
        play()
        return sendEventToView
            .asObservable()
    }
    
    @discardableResult
    func handleEvent(
        _ event: ReceiveByServiceEvent
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
            // TODO: 뒤로 가기 버튼 클릭 시 이벤트
            player?.pause()
            return nil
            
        case .audioButtonTapped(let isUse):
            setCommandCenter(isUse: isUse)
            return nil
            
        case .setQuality(let quality):
            player?.currentItem?.preferredMaximumResolution = quality.getMaxResolution()
            
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
                self?.sendEventToView.onNext((.didPlayToEndTime, nil))
            })
            .disposed(by: disposeBag)
        
        player?.rx.observe(\.timeControlStatus)
            .subscribe(onNext: { [weak self] status in
//                switch status {
//                case .paused:
//                    print("status paused")
//                case .playing:
//                    print("status playing")
//                case .waitingToPlayAtSpecifiedRate:
//                    print("status waitingToPlayAtSpecifiedRate")
//                @unknown default:
//                    fatalError()
//                }
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

