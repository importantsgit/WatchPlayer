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

protocol PlayerControllerViewProtocol {
    
}

class PlayerControllerView: UIView {
    private var presenter: PlayerControllerProtocol
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .title
        
        return label
    }()
    
    private var backButton = UIButton()
    private var audioButton = UIButton()
    private var settingButton = UIButton()
    
    private var playButton = UIButton()
    
    private var rotationButton = UIButton()
    
    
    private var disposeBag = DisposeBag()
    
    init(
        presenter: PlayerControllerProtocol
    ) {
        self.presenter = presenter
        super.init(frame: .zero)
        
        setupTappedGesture()
        setupLayout()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTappedGesture() {
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.presenter.controllerTapped()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupButtons() {
        let imageSize: CGFloat = 42
        [backButton, audioButton, settingButton, playButton, rotationButton].forEach{
            $0.configuration = .plain()
            $0.configuration?.imagePlacement = .all
        }
        
        backButton.configuration?.image = UIImage(named: "back")?
            .resized(to: .init(width: imageSize, height: imageSize))
        backButton.rx.tap.bind { [weak self] in
            self?.presenter.backButtonTapped()
        }
        .disposed(by: disposeBag)
        
        audioButton.configuration?.image = UIImage(named: "audio")?
            .resized(to: .init(width: imageSize, height: imageSize))
        audioButton.rx.tap.bind { [weak self] in
            self?.presenter.audioButtonTapped()
        }
        .disposed(by: disposeBag)
        
        settingButton.configuration?.image = UIImage(named: "setting")?
            .resized(to: .init(width: imageSize, height: imageSize))
        settingButton.rx.tap.bind { [weak self] in
            self?.presenter.settingButtonTapped()
        }
        .disposed(by: disposeBag)
        
        playButton.configuration?.image = UIImage(named: "pause")?
            .resized(to: .init(width: imageSize, height: imageSize))
        playButton.rx.tap.bind { [weak self] in
            self?.presenter.playButtonTapped()
        }
        .disposed(by: disposeBag)
        
        rotationButton.configuration?.image = UIImage(named: "expand")?
            .resized(to: .init(width: imageSize, height: imageSize))
        rotationButton.rx.tap.bind { [weak self] in
            self?.presenter.expandButtonTapped()
        }
        .disposed(by: disposeBag)
        
    }
    
    private func setupLayout() {
        
        self.backgroundColor = UIColor(hex: "000000", alpha: 0.4)
        
        titleLabel.textAlignment = .center
        
        let topControlView = UIStackView()
        
        
        
        [backButton, titleLabel, audioButton, settingButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            topControlView.addArrangedSubview($0)
        }
        
        let middleControlView = UIStackView()
        
        [playButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            middleControlView.addArrangedSubview($0)
        }
        
        let bottomControlView = UIStackView()
        
        let seekbarView = UIView()

        [seekbarView, rotationButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bottomControlView.addArrangedSubview($0)
        }
        
        let seekbar = UIView()
        seekbar.backgroundColor = .primary
        
        seekbar.translatesAutoresizingMaskIntoConstraints = false
        seekbarView.addSubview(seekbar)
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
        
        NSLayoutConstraint.activate([
            topControlView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            topControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            topControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            middleControlView.centerYAnchor.constraint(equalTo: centerYAnchor),
            middleControlView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bottomControlView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            bottomControlView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            bottomControlView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            seekbarView.heightAnchor.constraint(equalToConstant: 42),
            
            seekbar.bottomAnchor.constraint(equalTo: seekbarView.bottomAnchor, constant: -8),
            seekbar.leftAnchor.constraint(equalTo: seekbarView.leftAnchor),
            seekbar.rightAnchor.constraint(equalTo: seekbarView.rightAnchor),
            seekbar.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
    
    @objc func viewTapped(){
        presenter.controllerTapped()
    }
}
