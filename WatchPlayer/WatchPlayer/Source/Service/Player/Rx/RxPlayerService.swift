//
//  RxPlayerService.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/18/24.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa
import RxRelay
import MediaPlayer
import AVKit

final class RxPlayerService: NSObject {
    
    private let scheduler = SerialDispatchQueueScheduler(
        queue: DispatchQueue.global(qos: .background), internalSerialQueueName: "RxMusicPlayerSerialQueue"
    )
    
    let playerRelay = BehaviorRelay<AVPlayer?>(value: nil)
    let statusRelay = BehaviorRelay<PlayerStatus>(value: .ready)
    let repeatModeRelay = BehaviorRelay<RepeatMode>(value: .none)
    private let autoCommandRelay = PublishRelay<Command>()
    private let remoteCommandRelay = PublishRelay<Command>()
    
    public private(set) var player: AVPlayer? {
        set {
            playerRelay.accept(newValue)
        }
        get {
            return playerRelay.value
        }
    }
    
    public var repeatMode: RepeatMode {
        set {
            repeatModeRelay.accept(newValue)
        }
        get {
            return repeatModeRelay.value
        }
    }
    
    public private(set) var status: PlayerStatus {
        set {
            statusRelay.accept(newValue)
        }
        get {
            return statusRelay.value
        }
    }
    
    func run(cmd: Driver<Command>) -> Driver<PlayerStatus> {
        let status = statusRelay
            .asObservable()
        
        let playerStatus = playerRelay
            .subscribe()
        
        let endTime = observeDidPlayToEndTime()
            .subscribe()
        
        let interruption = observeSessionInterruption()
            .subscribe()
        
        let remoteControl = registerRemoteControl()
            .subscribe()
        
        let cmdRunner = Observable.merge(
                cmd.asObservable(),
                autoCommandRelay.asObservable(),
                remoteCommandRelay.asObservable()
            )
            .flatMapLatest(runCommand)
            .subscribe()
        
        return Observable.create { observer in
            let statusDisposable = status
                .distinctUntilChanged()
                .subscribe(observer)
            
            return Disposables.create {
                statusDisposable.dispose()
                playerStatus.dispose()
                endTime.dispose()
                interruption.dispose()
                remoteControl.dispose()
                cmdRunner.dispose()
            }
        }
        .asDriver(onErrorJustReturn: statusRelay.value)
            
    }
    
    func runCommand(
        _ command: Command
    ) -> Observable<()> {
        rx.canEnabledCommand(command).asObservable().take(1)
            .observe(on: scheduler)
            .flatMapLatest { [weak self] isEnabled -> Observable<()> in
                guard let self = self
                else { return .error(PlayerServiceError.weakError) }
                
                if isEnabled == false {
                    return .error(PlayerServiceError.commandError)
                }
                
                switch command {
                case .play:
                    return self.play()
                case .pause:
                    return self.pause()
                case .stop:
                    return self.stop()
                case .seek(seconds: let seconds, shouldPlay: let shouldPlay):
                    return self.seek(second: seconds, shouldPlay: shouldPlay)
                case .skip(seconds: let seconds):
                    return self.skip(second: seconds)
                }
            }
            .catch { [weak self] error in
                self?.status = .failed
                return .just(())
            }
    }

    
    func registerRemoteControl(
    ) -> Observable<()> {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.remoteCommandRelay.accept(.play)
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.remoteCommandRelay.accept(.pause)
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.remoteCommandRelay.accept(
                self?.status == .playing ? .pause : .play
            )
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent
            else { return .commandFailed}
            
            self?.remoteCommandRelay.accept(.seek(seconds: Int(event.positionTime), shouldPlay: false))
            return .success
        }
        
        return Observable.create { [weak self] _ in
            guard let self = self else { return Disposables.create() }
            
            let canPlay = self.rx.canEnabledCommand(.play)
                .do(onNext: {
                    commandCenter.playCommand.isEnabled = $0
                })
                .drive()
            
            let canPause = self.rx.canEnabledCommand(.pause)
                .do(onNext: {
                    commandCenter.pauseCommand.isEnabled = $0
                })
                .drive()
            
            let canSeek = self.rx.canEnabledCommand(.seek(seconds: 0, shouldPlay: false))
                .do(onNext: {
                    commandCenter.changePlaybackPositionCommand.isEnabled = $0
                })
                .drive()
            
            return Disposables.create {
                canPlay.dispose()
                canPause.dispose()
                canSeek.dispose()
            }
        }
    }
    
    private func play(
    ) -> Observable<()> {
        player?.play()
        
        status = .playing
        return .just(())
    }
    
    private func pause(
    ) -> Observable<()> {
        player?.pause()
        
        status = .paused
        return .just(())
    }
    
    private func stop(
    ) -> Observable<()> {
        player?.pause()
        player = nil
        
        status = .ready
        return .just(())
    }
    
    private func seek(
        second: Int,
        shouldPlay: Bool = false
    ) -> Observable<()> {
        guard let player = player else { return .just(()) }
        
        player.seek(to: CMTimeMake(value: Int64(second), timescale: 1))
        
        if shouldPlay {
            player.play()
            if status != .playing {
                status = .playing
            }
        }
        return .just(())
    }
    
    private func skip(
        second: Int
    ) -> Observable<()> {
        Driver.combineLatest(
            rx.currentItemDuration(),
            rx.currentItemTime()
        ).asObservable().take(1)
            .flatMapLatest { [weak self] duration, currentTime -> Observable<()> in
                guard let self = self,
                      let durationSecond = duration?.seconds,
                      let currentSecond = duration?.seconds
                else { return .just(()) }
                
                let newSecond = currentSecond + Double(second)
                if durationSecond <= newSecond {
                    self.autoCommandRelay.accept(.stop)
                    return self.seek(second: Int(durationSecond))
                }
                else if newSecond <= 0 {
                    return self.seek(second: 0)
                }
                return self.seek(second: Int(newSecond))
            }
    }
    
    
    private func observeDidPlayToEndTime() -> Observable<()> {
        NotificationCenter.default.rx
            .notification(.AVPlayerItemDidPlayToEndTime)
            .map { [weak self] _ -> Command in
                guard let self = self
                else { return .stop }
                
                switch self.repeatMode {
                case .none:
                    return .stop
                case .one:
                    return .seek(seconds: 0, shouldPlay: true)
                }
            }
            .flatMapLatest { [weak self] command -> Observable<()> in
                guard let self = self
                else {return .just(())}
                
                return self.rx.canEnabledCommand(command)
                    .asObservable()
                    .take(1)
                    .map { [weak self] isEnabled in
                        self?.autoCommandRelay.accept(isEnabled ? command : .stop)
                    }
                
            }
        
    }
    
    private func observeSessionInterruption(
    ) -> Observable<()> {
        NotificationCenter.default.rx
            .notification(AVAudioSession.interruptionNotification)
            .map { [weak self] notification -> Command? in
                guard let userInfo = notification.userInfo,
                      let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                      let type = AVAudioSession.InterruptionType(rawValue: typeValue)
                else { return nil }
                
                if type == .began {
                    self?.status = .paused
                }
                else if type == .ended {
                    if let optionValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                        let options = AVAudioSession.InterruptionOptions(rawValue: optionValue)
                        if options.contains(.shouldResume) {
                            return .play
                        }
                    }
                }
                
                return nil
            }
            .flatMap { Observable.from(optional: $0) }
            .flatMapLatest { [weak self] command -> Observable<()> in
                guard let self = self else { return .just(()) }
                return self.rx.canEnabledCommand(command)
                    .asObservable()
                    .take(1)
                    .filter { $0 }
                    .map { [weak self] _ in
                        self?.autoCommandRelay.accept(command)
                    }
            }
    }
    
}
