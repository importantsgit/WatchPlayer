//
//  PlayerView.swift
//  WatchPlayer
//
//  Created by Importants on 7/3/24.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import RxSwift
import RxGesture

// 플레이어뷰에서 presenter로 전달되는 이벤트
enum PlayerEvent {
    case playerTapped
}

// presenter에서 플레이어뷰로 전달되는 UIUpdate 이벤트
enum PlayerViewUIUpdateEvent {
    case set(playerLayer: AVPlayerLayer)
    case update(player: AVPlayer?)
    case updateLayout
}

protocol PlayerViewProtocol: AnyObject {
    func handleEvent(_ event: PlayerViewUIUpdateEvent)
}

class PlayerView: UIView {
    
    weak var presenter: PlayerProtocol?
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var pipController: AVPictureInPictureController?
    private var containerView: UIView?
    
    private var disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupTappedGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTappedGesture() {
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.handleEvent(.playerTapped)
            })
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.bounds
    }
}

extension PlayerView: PlayerViewProtocol {
    func handleEvent(_ event: PlayerViewUIUpdateEvent) {
        switch event {
        case .set(let playerLayer):
            Task { @MainActor in
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    try AVAudioSession.sharedInstance().setActive(true)
                }
                catch {
                    // Error
                }
                
                self.playerLayer = playerLayer
                layer.addSublayer(self.playerLayer!)
                self.setNeedsLayout()
            }

        case .update(let player):
            playerLayer?.player = player
            
        case .updateLayout:
            // TODO: 뷰 업데이트가 필요하면 작성
            break
        }
    }
    
    func setPip(isUse: Bool) {
        if  isUse &&
                pipController == nil &&
                AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(playerLayer: self.playerLayer!)
            pipController?.requiresLinearPlayback = true
            pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        }
        else {
            pipController = nil
        }
    }
}
