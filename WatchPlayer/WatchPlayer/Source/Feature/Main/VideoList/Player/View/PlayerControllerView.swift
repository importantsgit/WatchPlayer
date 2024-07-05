//
//  PlayerControllerView.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/4/24.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import RxSwift
import RxGesture
import RxCocoa

enum SendFromControllerEvent {
    case playViewTapped
    case controllerTapped
    
    case audioButtonTapped
    case settingButtonTapped
    case rotationButtonTapped
    case backButtonTapped
    
    case playButtonTapped
}

enum ReceiveByControllerEvent {
    case setPlayButton(state: PlayerState)
    case setTime(current: CMTime, duration: CMTime)
    case setLayout(style: LayoutStyle)
}

protocol PlayerControllerViewProtocol: AnyObject {
    func handleEvent(_ event: ReceiveByControllerEvent)
}

class PlayerControllerView: UIView {
    weak var presenter: PlayerControllerProtocol?
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .title
        
        return label
    }()
    
    private let topControlView = UIStackView()
    private let middleControlView = UIStackView()
    private let bottomControlView = UIStackView()
    private let seekbarView = UIView()
    private let seekbar = UIView()
    private var backButton = UIButton()
    private var audioButton = UIButton()
    private var settingButton = UIButton()
    private var playButton = UIButton()
    private var timeLabel = UILabel()
    private var rotationButton = UIButton()
    
    
    private var disposeBag = DisposeBag()
    
    private var layoutConstraints: [NSLayoutConstraint]?
    
    init() {
        super.init(frame: .zero)
        
        setupTappedGesture()
        setupButtons()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTappedGesture() {
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.handleContollerEvent(.controllerTapped)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtons() {
        [backButton, audioButton, settingButton, playButton, rotationButton].forEach{
            $0.configuration = .plain()
            $0.configuration?.imagePlacement = .all
        }
        
        backButton.rx.tap.bind { [weak self] in
            self?.presenter?.handleContollerEvent(.backButtonTapped)
        }
        .disposed(by: disposeBag)

        audioButton.rx.tap.bind { [weak self] in
            self?.presenter?.handleContollerEvent(.audioButtonTapped)
        }
        .disposed(by: disposeBag)
        
        settingButton.rx.tap.bind { [weak self] in
            self?.presenter?.handleContollerEvent(.settingButtonTapped)
        }
        .disposed(by: disposeBag)
        
        playButton.rx.tap.bind { [weak self] in
            guard let state = self?.presenter?.handleContollerEvent(.playButtonTapped) as? PlayerState
            else { return }
            self?.setPlayButton(state: state)
        }
        .disposed(by: disposeBag)
        
        rotationButton.rx.tap.bind { [weak self] in
            self?.presenter?.handleContollerEvent(.rotationButtonTapped)
        }
        .disposed(by: disposeBag)
        
        playButton.configuration?.image = UIImage(named: "pause")?
            .resized(to: .init(width: 42, height: 42))
    }
    
    private func setupLayout() {
        
        self.backgroundColor = UIColor(hex: "000000", alpha: 0.4)
        
        titleLabel.textAlignment = .center
        
        [backButton, titleLabel, audioButton, settingButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topControlView.addArrangedSubview($0)
        }
        
        [playButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            middleControlView.addArrangedSubview($0)
        }
        
        [seekbarView, rotationButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bottomControlView.addArrangedSubview($0)
        }
        
        seekbar.backgroundColor = .primary
        
        timeLabel.textAlignment = .right
        
        [timeLabel, seekbar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            seekbarView.addSubview($0)
        }
        
        seekbar.layer.cornerRadius = 2
        
        [topControlView, middleControlView, bottomControlView].forEach{
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .bottom
            $0.distribution = .fill
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        [backButton, audioButton, settingButton, rotationButton].forEach{
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 42),
                $0.heightAnchor.constraint(equalToConstant: 42)
            ])
        }
        
        layoutConstraints = setInitialLayout()
         NSLayoutConstraint.activate(layoutConstraints!)
    }
    
    private func setInitialLayout() -> [NSLayoutConstraint] {
        if frame.width > frame.height {
            return setLayoutToLandscape()
        } else {
            return setLayoutToPortrait()
        }
    }
    
    func setLayoutToPortrait(
    ) -> [NSLayoutConstraint] {
        let imageSize: CGFloat = 32
        backButton.configuration?.image = UIImage(named: "back")?
            .resized(to: .init(width: imageSize, height: imageSize))
        audioButton.configuration?.image = UIImage(named: "audio")?
            .resized(to: .init(width: imageSize, height: imageSize))
        settingButton.configuration?.image = UIImage(named: "setting")?
            .resized(to: .init(width: imageSize, height: imageSize))
        rotationButton.configuration?.image = UIImage(named: "expand")?
            .resized(to: .init(width: imageSize, height: imageSize))
        
        return [
            topControlView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            topControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            topControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            middleControlView.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleControlView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomControlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            bottomControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            bottomControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            seekbarView.heightAnchor.constraint(equalToConstant: 42),
            
            timeLabel.topAnchor.constraint(equalTo: seekbarView.topAnchor),
            timeLabel.leftAnchor.constraint(equalTo: seekbarView.leftAnchor),
            
            seekbar.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: -2),
            seekbar.bottomAnchor.constraint(equalTo: seekbarView.bottomAnchor, constant: -8),
            seekbar.leftAnchor.constraint(equalTo: seekbarView.leftAnchor),
            seekbar.rightAnchor.constraint(equalTo: seekbarView.rightAnchor),
            seekbar.heightAnchor.constraint(equalToConstant: 4),
        ]
    }
    
    func setLayoutToLandscape(
    ) -> [NSLayoutConstraint] {
        let imageSize: CGFloat = 42
        backButton.configuration?.image = UIImage(named: "back")?
            .resized(to: .init(width: imageSize, height: imageSize))
        audioButton.configuration?.image = UIImage(named: "audio")?
            .resized(to: .init(width: imageSize, height: imageSize))
        settingButton.configuration?.image = UIImage(named: "setting")?
            .resized(to: .init(width: imageSize, height: imageSize))
        rotationButton.configuration?.image = UIImage(named: "expand")?
            .resized(to: .init(width: imageSize, height: imageSize))
        
        return [
            topControlView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            topControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            topControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32),
            
            middleControlView.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleControlView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomControlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            bottomControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 32),
            bottomControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -32),
            
            seekbarView.heightAnchor.constraint(equalToConstant: 42),
            
            timeLabel.topAnchor.constraint(equalTo: seekbarView.topAnchor),
            timeLabel.leftAnchor.constraint(equalTo: seekbarView.leftAnchor),
            
            seekbar.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: -2),
            seekbar.bottomAnchor.constraint(equalTo: seekbarView.bottomAnchor, constant: -8),
            seekbar.leftAnchor.constraint(equalTo: seekbarView.leftAnchor),
            seekbar.rightAnchor.constraint(equalTo: seekbarView.rightAnchor),
            seekbar.heightAnchor.constraint(equalToConstant: 4),
        ]
    }
    
    func setPlayButton(state: PlayerState) {
        let buttonImage: UIImage
        switch state {
        case .playing: buttonImage = .pause
        case .paused: buttonImage = .play
        case .ended: buttonImage = .rotate
        }
        
        playButton.configuration?.image = buttonImage
    }
}

extension PlayerControllerView: PlayerControllerViewProtocol {
    func handleEvent(_ event: ReceiveByControllerEvent) {
        switch event {
        case .setLayout(let style):
            self.setNeedsUpdateConstraints()
            NSLayoutConstraint.deactivate(self.layoutConstraints ?? [])
            
            let newConstraints: [NSLayoutConstraint]
            switch style {
            case .landscape:
                newConstraints = self.setLayoutToLandscape()
            case .portrait:
                newConstraints = self.setLayoutToPortrait()
            }
            
            NSLayoutConstraint.activate(newConstraints)
            self.layoutConstraints = newConstraints
            
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
            
        case .setPlayButton(let state):
            setPlayButton(state: state)
            
        case .setTime(current: let current, duration: let duration):
            set(times: (current, duration))
        }
    }
        
    func set(
        times: (current: CMTime, duration: CMTime)
    ) {
        timeLabel.attributedText = NSAttributedStringBuilder()
            .add(
                string: "\(times.current.convertCMTimeToString()) / ",
                color: .white,
                font: .systemFont(ofSize: 13, weight: .bold),
                lineHeight: 14
            )
            .add(
                string: "\(times.duration.convertCMTimeToString())",
                color: .time,
                font: .systemFont(ofSize: 13, weight: .medium),
                lineHeight: 14
            )
            .buildNSAttributedString()
    }
}
