//
//  PlayerAudioControllerView.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/5/24.
//

import UIKit
import RxSwift
import RxGesture
import RxCocoa

// 컨트롤러에서 presenter로 전달되는 이벤트
enum AudioControllerEvent {
    case dismissAudioButtonTapped
    case backButtonTapped
    case playButtonTapped
}

// presenter에서 컨트롤러로 전달되는 UIUpdate 이벤트
enum PlayerAudioControllerViewUIUpdateEvent {
    case setTitle(title: String)
    case updateLayout(style: LayoutStyle)
    case updatePlayButton(state: PlayerState)
}

protocol PlayerAudioControllerViewProtocol: AnyObject {
    var events: Observable<AudioControllerEvent> { get }
    func handleEvent(_ event: PlayerAudioControllerViewUIUpdateEvent)
}

final class PlayerAudioControllerView: UIView {
    private let eventSubject = PublishSubject<AudioControllerEvent>()
    var events: Observable<AudioControllerEvent> { eventSubject.asObservable() }
    
    weak var presenter: PlayerAudioControllerProtocol?
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    private let topControlView = UIStackView()
    private let spacer = UIView()
    private let backButton = UIButton()
    private let audioButton = UIButton()
    
    private let middleControlView = UIStackView()
    private let playButton = UIButton()
    
    private let audioTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "오디오 모드입니다."
        
        return label
    }()
    
    
    private var layoutConstraints: [NSLayoutConstraint]?
    
    private var disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupButtons()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("PlayerAudioControllerView deinit")
    }
}

extension PlayerAudioControllerView {
    private func setupButtons() {
        [backButton, audioButton, playButton].forEach {
            $0.configuration = .plain()
            $0.configuration?.imagePlacement = .all
        }
        
        backButton.configuration?.image = UIImage(named: "back")?
            .resized(to: .init(width: 42, height: 42))
        
        playButton.configuration?.image = UIImage(named: "pause")?
            .resized(to: .init(width: 54, height: 54))
        
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { AudioControllerEvent.backButtonTapped }
            .bind (to: eventSubject)
            .disposed(by: disposeBag)
        
        audioButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { AudioControllerEvent.dismissAudioButtonTapped }
            .bind (to: eventSubject)
            .disposed(by: disposeBag)
        
        playButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
            guard let state = self?.presenter?.handleEvent(.playButtonTapped) as? PlayerState
            else { return }
            self?.setPlayButton(state: state)
        }
        .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        self.backgroundColor = UIColor(hex: "000000", alpha: 0.4)
        
        self.titleLabel.textAlignment = .left
        
        [spacer, backButton, titleLabel, audioButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topControlView.addArrangedSubview($0)
        }
        
        [playButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            middleControlView.addArrangedSubview($0)
            
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 56),
                $0.heightAnchor.constraint(equalToConstant: 56)
            ])
        }
        
        [topControlView, middleControlView].forEach {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        [topControlView, middleControlView, audioTextLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        [backButton, audioButton].forEach {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 42),
                $0.heightAnchor.constraint(equalToConstant: 42)
            ])
        }
        
        layoutConstraints = setInitialLayout()
         NSLayoutConstraint.activate(layoutConstraints!)
    }
    
    private func setInitialLayout(
    ) -> [NSLayoutConstraint] {
        if frame.width > frame.height {
            return setLayoutToLandscape()
        } else {
            return setLayoutToPortrait()
        }
    }
    
    func setLayoutToPortrait(
    ) -> [NSLayoutConstraint] {
        let imageSize: CGFloat = 32
        backButton.isHidden = true
        titleLabel.isHidden = true
        spacer.isHidden = false
        
        audioTextLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        audioButton.configuration?.image = UIImage(named: "audio_disable")?
            .resized(to: .init(width: imageSize, height: imageSize))
        
        return [
            topControlView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            topControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            topControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            middleControlView.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleControlView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            audioTextLabel.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
            audioTextLabel.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: -4)
        ]
    }
    
    func setLayoutToLandscape(
    ) -> [NSLayoutConstraint] {
        let imageSize: CGFloat = 42
        backButton.isHidden = false
        titleLabel.isHidden = false
        spacer.isHidden = true
        
        audioTextLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        audioButton.configuration?.image = UIImage(named: "audio_disable")?
            .resized(to: .init(width: imageSize, height: imageSize))
        
        return [
            topControlView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            topControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            topControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32),
            
            middleControlView.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleControlView.centerXAnchor.constraint(equalTo: centerXAnchor),
        
            
            audioTextLabel.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
            audioTextLabel.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10)
        ]
    }
    
    func setLayoutToFullPortrait(
    ) -> [NSLayoutConstraint] {
        let imageSize: CGFloat = 42
        backButton.isHidden = false
        titleLabel.isHidden = false
        spacer.isHidden = true
        
        audioTextLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        audioButton.configuration?.image = UIImage(named: "audio_disable")?
            .resized(to: .init(width: imageSize, height: imageSize))
        
        return [
            topControlView.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            topControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            topControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            middleControlView.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleControlView.centerXAnchor.constraint(equalTo: centerXAnchor),
        
            
            audioTextLabel.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
            audioTextLabel.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10)
        ]
    }
    
    func setPlayButton(state: PlayerState) {
        let buttonImage: UIImage
        let size: CGFloat = 54
        switch state {
        case .playing: buttonImage = .pause
        case .paused: buttonImage =  .play
        case .ended: buttonImage =  .rotate
        }

        playButton.configuration?.image = buttonImage.resized(to: .init(width: size, height: size))
    }
}


extension PlayerAudioControllerView: PlayerAudioControllerViewProtocol {
    
    func handleEvent(_ event: PlayerAudioControllerViewUIUpdateEvent) {
        switch event {
        case .updateLayout(let style):
            NSLayoutConstraint.deactivate(self.layoutConstraints ?? [])
            
            let newConstraints: [NSLayoutConstraint]
            switch style {
            case .landscape:
                newConstraints = self.setLayoutToLandscape()
                topControlView.spacing = 12
                middleControlView.spacing = 24
                
            case .portrait:
                newConstraints = self.setLayoutToPortrait()
                topControlView.spacing = 4
                middleControlView.spacing = 8
                
            case .fullPortrait:
                newConstraints = self.setLayoutToFullPortrait()
                topControlView.spacing = 4
                middleControlView.spacing = 16
            }
            
            NSLayoutConstraint.activate(newConstraints)
            self.layoutConstraints = newConstraints
            
        case .setTitle(let title):
            titleLabel.text = title
            
        case .updatePlayButton(let state):
            setPlayButton(state: state)
        }
    }
}
