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

// 컨트롤러에서 presenter로 전달되는 이벤트
enum ControllerEvent {
    case controllerTapped
    case showAudioButtonTapped
    case settingButtonTapped
    case rotationButtonTapped
    case backButtonTapped
    case playButtonTapped
    case rewindButtonTapped
    case forwardButtonTapped
}

// presenter에서 컨트롤러로 전달되는 UIUpdate 이벤트
enum PlayerControllerViewUIUpdateEvent {
    case setTitle(title: String)
    case updateLayout(style: LayoutStyle)
    case updatePlayButton(state: PlayerState)
    case updateTime(current: CMTime, duration: CMTime)
}

protocol PlayerControllerViewProtocol: AnyObject {
    func handleEvent(_ event: PlayerControllerViewUIUpdateEvent)
}

final class PlayerControllerView: UIView {
    
    weak var presenter: PlayerControllerProtocol?
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        
        return label
    }()
    
    // TOP
    private let topControlView = UIStackView()
    private let spacer = UIView()
    private var backButton = UIButton()
    private var audioButton = UIButton()
    private var settingButton = UIButton()
    
    // MIDDLE
    private let middleControlView = UIStackView()
    private var playButton = UIButton()
    private var rewindButton = UIButton()
    private var forwardButton = UIButton()
    
    // BOTTOM
    private let bottomControlView = UIStackView()
    private let seekbarView = UIView()
    private let seekbar = UIView()
    private let currentSeekbar = UIView()
    private var timeLabel = UILabel()
    private var rotationButton = UIButton()
    
    private var layoutConstraints: [NSLayoutConstraint]?
    private var currentSeekbarWidthConstraint: NSLayoutConstraint!
    
    private var style: LayoutStyle = .portrait
    
    private var disposeBag = DisposeBag()
    
    private var time: CGFloat = 0.0
    
    init() {
        super.init(frame: .zero)
        
        setupTappedGesture()
        setupButtons()
        setupLayout()
        
        // 가로 <> 세로 회전 시, seekbar의 frame이 바뀌기 때문에 frame > bind
        bindSeekBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateSeekbarWidth() {
        let seekBarWidth = time * seekbar.bounds.width
        if seekBarWidth.isFinite {
            currentSeekbarWidthConstraint.constant = seekBarWidth
        }
    }
    
    deinit{
        print("PlayerControllerView deinit")
    }
}

extension PlayerControllerView {
    
    private func setupTappedGesture() {
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.handleEvent(.controllerTapped)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSeekBar() {
        seekbar.rx.observe(\.bounds)
            .map { $0.width }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] width in
                self?.updateSeekbarWidth()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtons() {
        [backButton, audioButton, settingButton, rewindButton, playButton, forwardButton, rotationButton].forEach{
            $0.configuration = .plain()
            $0.configuration?.imagePlacement = .all
        }
        
        backButton.configuration?.image = UIImage(named: "back")?
            .resized(to: .init(width: 42, height: 42))
        
        playButton.configuration?.image = UIImage(named: "pause")?
            .resized(to: .init(width: 54, height: 54))
        
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.presenter?.handleEvent(.backButtonTapped)
            }
            .disposed(by: disposeBag)
        
        audioButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.presenter?.handleEvent(.showAudioButtonTapped)
            }
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.presenter?.handleEvent(.settingButtonTapped)
            }
            .disposed(by: disposeBag)
        
        playButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                guard let state = self?.presenter?.handleEvent(.playButtonTapped) as? PlayerState
                else { return }
                self?.setPlayButton(state: state)
            }
            .disposed(by: disposeBag)
        
        rewindButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.presenter?.handleEvent(.rewindButtonTapped)
            }
            .disposed(by: disposeBag)
        
        forwardButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.presenter?.handleEvent(.forwardButtonTapped)
            }
            .disposed(by: disposeBag)
        
        rotationButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.presenter?.handleEvent(.rotationButtonTapped)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        self.backgroundColor = UIColor(hex: "000000", alpha: 0.4)
        
        [spacer, backButton, titleLabel, audioButton, settingButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topControlView.addArrangedSubview($0)
        }
        
        [rewindButton, playButton, forwardButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            middleControlView.addArrangedSubview($0)
            
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 56),
                $0.heightAnchor.constraint(equalToConstant: 56)
            ])
        }
        
        [seekbarView, rotationButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bottomControlView.addArrangedSubview($0)
        }
        
        seekbar.backgroundColor = .lightGray
        currentSeekbar.backgroundColor = .primary
        
        timeLabel.textAlignment = .right
        
        [timeLabel, seekbar, currentSeekbar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            seekbarView.addSubview($0)
        }
        
        seekbar.layer.cornerRadius = 2
        currentSeekbar.layer.cornerRadius = 2
        
        currentSeekbarWidthConstraint = currentSeekbar.widthAnchor.constraint(equalToConstant: 0)
        currentSeekbarWidthConstraint.isActive = true
        
        [topControlView, middleControlView, bottomControlView].forEach{
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .fill
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
        
        audioButton.configuration?.image = UIImage(named: "audio")?
            .resized(to: .init(width: imageSize, height: imageSize))
        settingButton.configuration?.image = UIImage(named: "setting")?
            .resized(to: .init(width: imageSize, height: imageSize))
        rotationButton.configuration?.image = UIImage(named: "expand")?
            .resized(to: .init(width: imageSize, height: imageSize))
        
        rewindButton.configuration?.image = UIImage(named: "rewind")?
            .resized(to: .init(width: 40, height: 40))
        forwardButton.configuration?.image = UIImage(named: "forward")?
            .resized(to: .init(width: 40, height: 40))
        
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
            
            currentSeekbar.topAnchor.constraint(equalTo: seekbar.topAnchor),
            currentSeekbar.leftAnchor.constraint(equalTo: seekbar.leftAnchor),
            currentSeekbar.bottomAnchor.constraint(equalTo: seekbar.bottomAnchor),
            
        ]
    }
    
    func setLayoutToLandscape(
    ) -> [NSLayoutConstraint] {
        let imageSize: CGFloat = 42
        backButton.isHidden = false
        titleLabel.isHidden = false
        spacer.isHidden = true
        
        audioButton.configuration?.image = UIImage(named: "audio")?
            .resized(to: .init(width: imageSize, height: imageSize))
        settingButton.configuration?.image = UIImage(named: "setting")?
            .resized(to: .init(width: imageSize, height: imageSize))
        rotationButton.configuration?.image = UIImage(named: "shrink")?
            .resized(to: .init(width: imageSize, height: imageSize))
        
        rewindButton.configuration?.image = UIImage(named: "rewind")?
            .resized(to: .init(width: 48, height: 48))
        forwardButton.configuration?.image = UIImage(named: "forward")?
            .resized(to: .init(width: 48, height: 48))
        
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
            
            currentSeekbar.topAnchor.constraint(equalTo: seekbar.topAnchor),
            currentSeekbar.leftAnchor.constraint(equalTo: seekbar.leftAnchor),
            currentSeekbar.bottomAnchor.constraint(equalTo: seekbar.bottomAnchor),
            
        ]
    }
    
    func setLayoutToFullPortrait(
    ) -> [NSLayoutConstraint] {
        let imageSize: CGFloat = 42
        backButton.isHidden = false
        titleLabel.isHidden = false
        spacer.isHidden = true
        
        audioButton.configuration?.image = UIImage(named: "audio")?
            .resized(to: .init(width: imageSize, height: imageSize))
        settingButton.configuration?.image = UIImage(named: "setting")?
            .resized(to: .init(width: imageSize, height: imageSize))
        rotationButton.configuration?.image = UIImage(named: "shrink")?
            .resized(to: .init(width: imageSize, height: imageSize))
        
        rewindButton.configuration?.image = UIImage(named: "rewind")?
            .resized(to: .init(width: 48, height: 48))
        forwardButton.configuration?.image = UIImage(named: "forward")?
            .resized(to: .init(width: 48, height: 48))
        
        return [
            topControlView.topAnchor.constraint(equalTo: topAnchor, constant: 64),
            topControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            topControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            middleControlView.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleControlView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomControlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -64),
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
            
            currentSeekbar.topAnchor.constraint(equalTo: seekbar.topAnchor),
            currentSeekbar.leftAnchor.constraint(equalTo: seekbar.leftAnchor),
            currentSeekbar.bottomAnchor.constraint(equalTo: seekbar.bottomAnchor),
            
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

extension PlayerControllerView: PlayerControllerViewProtocol {
    
        
    func handleEvent(_ event: PlayerControllerViewUIUpdateEvent) {
        switch event {
        case .updateLayout(let style):
            self.style = style
            NSLayoutConstraint.deactivate(self.layoutConstraints ?? [])
            
            let newConstraints: [NSLayoutConstraint]
            switch style {
            case .landscape:
                newConstraints = self.setLayoutToLandscape()
                [topControlView, bottomControlView].forEach{ $0.spacing = 12 }
                middleControlView.spacing = 24
                
            case .portrait:
                newConstraints = self.setLayoutToPortrait()
                [topControlView, bottomControlView].forEach{ $0.spacing = 4 }
                middleControlView.spacing = 8
                
            case .fullPortrait:
                newConstraints = self.setLayoutToFullPortrait()
                [topControlView, bottomControlView].forEach{ $0.spacing = 4 }
                middleControlView.spacing = 16
            }
        
            NSLayoutConstraint.activate(newConstraints)
            self.layoutConstraints = newConstraints
            
        case .updatePlayButton(let state):
            setPlayButton(state: state)
            if state == .ended {
                [rewindButton, forwardButton].forEach { $0.isHidden = true }
            }
            else {
                [rewindButton, forwardButton].forEach { $0.isHidden = false }
            }
            
        case .updateTime(current: let current, duration: let duration):
            set(times: (current, duration))
            
            let durationSeconds = CMTimeGetSeconds(duration)
            let currentSeconds = CMTimeGetSeconds(current)
            
            // NaN 또는 inf가 발생하지 않도록 안전하게 나누기 수행
            time = durationSeconds > 0 ?
            CGFloat(currentSeconds / durationSeconds) :
            0
            
            updateSeekbarWidth()
            
        case .setTitle(let title):
            titleLabel.text = title
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
