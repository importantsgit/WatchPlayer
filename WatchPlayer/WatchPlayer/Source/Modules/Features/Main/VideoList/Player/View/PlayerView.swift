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
    case updateGravity(gravity: PlayerGravity)
    case updateLayout
    case updatePipMode(isVisible: Bool)
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
    
    deinit{
        print("PlayerView deinit")
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
                setupPictureInPicture()
                self.setNeedsLayout()
            }

        case .update(let player):
            playerLayer?.player = player
            
        case .updateGravity(let gravity):
            playerLayer?.videoGravity = gravity.getGravity()
            
        case .updateLayout:
            // TODO: 뷰 업데이트가 필요하면 작성
            break
            
        case .updatePipMode(let isVisible):
            print("isPictureInPicturePossible: \(pipController?.isPictureInPicturePossible)")
            
            isVisible ?
            pipController?.startPictureInPicture() :
            pipController?.stopPictureInPicture()
            
        }
    }
    
    func setupPictureInPicture() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            print("PiP is not supported on this device")
            return
        }
        player?.allowsExternalPlayback = true
        pipController?.requiresLinearPlayback = true
        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        
        pipController = AVPictureInPictureController(playerLayer: playerLayer!)
    }

}
