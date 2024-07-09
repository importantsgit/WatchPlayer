//
//  PlayerPresenter.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import Foundation
import RxRelay
import RxSwift
import Photos

protocol PlayerProtocol: AnyObject {
    @discardableResult
    func handleEvent(_ event: PlayerEvent) -> Any?
}

protocol PlayerControllerProtocol: AnyObject {
    @discardableResult
    func handleEvent(_ event: ControllerEvent) -> Any?
}

protocol PlayerAudioControllerProtocol: AnyObject {
    @discardableResult
    func handleEvent(_ event: AudioControllerEvent) -> Any?
}

protocol PlayerSettingProtocol: AnyObject {
    @discardableResult
    func handleEvent(_ event: SettingEvent) -> Any?
}

protocol PlayerPresenterProtocolInput {
    func viewDidLoad()
    func backButtonTapped()
}

protocol PlayerPresenterProtocolOutput {
    var playerTitle: PublishRelay<String> { get }
    var didLoadPlayer: PublishRelay<Void> { get }

    var hideControllerDelay: PublishSubject<Void> { get }
    var hideControllerImmediately: PublishSubject<Void> { get }
    var showController: PublishRelay<Void> { get }
    var showAudioController: PublishRelay<Bool> { get }
    var showSettingView: PublishRelay<Bool> { get }
    var showSettingPopup: PublishRelay<Bool> { get }
    
    var setLayout: PublishRelay<LayoutStyle> { get }
}

typealias PlayerPresenterProtocol = PlayerPresenterProtocolInput & PlayerPresenterProtocolOutput

final class PlayerPresenter: NSObject, PlayerPresenterProtocol {
    
    let router: PlayerRouterProtocol
    let interactor: PlayerInteractorProtocol
    let asset: PHAsset
    
    // MARK: - PlayerView, Controller Binding with Handler
    weak var playerView: PlayerViewProtocol?
    weak var controllerView: PlayerControllerViewProtocol?
    weak var audioControllerView: PlayerAudioControllerViewProtocol?
    weak var settingView: PlayerSettingViewProtocol?
    weak var settingPopup: PlayerSettingPopupProtocol?
    
    // MARK: - PlayerViewController Binding with RxSwift
    let playerTitle = PublishRelay<String>()
    
    let didLoadPlayer = PublishRelay<Void>()
    
    // 컨트롤러 노출 여부
    let hideControllerDelay = PublishSubject<Void>()
    let hideControllerImmediately = PublishSubject<Void>()
    let showController = PublishRelay<Void>()
    
    let showSettingView = PublishRelay<Bool>()
    let showSettingPopup = PublishRelay<Bool>()
    let showAudioController = PublishRelay<Bool>()
    
    //레이아웃 관련
    let setLayout = PublishRelay<LayoutStyle>()
    private var currentLayoutStyle: LayoutStyle = .portrait
    
    // 세팅뷰가 노출된 상태에서 플레이어를 터치 시의 분기 처리 위함
    private var isShowSettingView = false
    
    var selectedIndexPaths = [
        IndexPath(row: 0, section: 0),
        IndexPath(row: 1, section: 0),
        IndexPath(row: 0, section: 0)
    ]
    
    let disposeBag = DisposeBag()
    
    init(
        router: PlayerRouterProtocol,
        interactor: PlayerInteractorProtocol,
        asset: PHAsset
    ) {
        self.router = router
        self.interactor = interactor
        self.asset = asset
        
    }
    
    func viewDidLoad() {
        
        settingView?.handleEvent(
            .updateSettingData(selectedIndexPaths: selectedIndexPaths)
        )
        settingPopup?.handleEvent(
            .updateSettingData(selectedIndexPaths: selectedIndexPaths)
        )
        
        let quality = PlayerQuality.getValueFromIndex(selectedIndexPaths[0].row)
        interactor.handleEvent(.updateQuality(quality))
        
        let speed = PlayerSpeed.getValueFromIndex(selectedIndexPaths[1].row)
        interactor.handleEvent(.updateSpeed(speed))
        
        let gravity = PlayerGravity.getValueFromIndex(selectedIndexPaths[2].row)
        playerView?.handleEvent(.updateGravity(gravity: gravity))
        
        
        Task {
            do {
                playerTitle.accept(asset.creationDate?.getDateString() ?? Date.getCurrentDateString())
                let item = try await requestAVPlayerItem(asset)
            
                let player = AVPlayer(playerItem: item)
                let playerLayer = AVPlayerLayer(player: player)
                playerView?.handleEvent(.set(playerLayer: playerLayer))
                didLoadPlayer.accept(())
                
                let getServiceEvent = interactor.set(player: player)
                getServiceEvent
                    .subscribe(onNext: { [weak self] (event, param) in
                        switch event {
                        case .playerStatus(let status):
                            self?.controllerView?.handleEvent(.updatePlayButton(state: status))
                            self?.audioControllerView?.handleEvent(.updatePlayButton(state: status))
                            
                        case .setTimes:
                            guard let times = param as? (CMTime?, CMTime?),
                                  let current = times.0,
                                  let duration = times.1
                            else { return }
                            
                            self?.controllerView?.handleEvent(.updateTime(current: current, duration: duration))
                        }
                    })
                    .disposed(by: disposeBag)
            }
            catch {
                print(error)
            }
        }
    
    }
        
    private func requestAVPlayerItem(
        _ asset: PHAsset
    ) async throws -> AVPlayerItem {
        
        return try await withCheckedThrowingContinuation { continuation in
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .automatic
            
            // MARK: - 클라우드에서 받는 경우도 있기에 true로 해야 item != nil
            options.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestPlayerItem(
                forVideo: asset,
                options: options
            ) { item, info in
                if let error = info?["PHImageErrorKey"] as? Error {
                    continuation.resume(throwing: error)
                }
                guard let item = item
                        // FIXME: 에러 처리
                else {
                    continuation.resume(throwing: AssetError.invaild)
                    return
                }
                continuation.resume(returning: item)
            }
        }
    }
    
    func backButtonTapped() {
        interactor.handleEvent(.backButtonTapped)
        router.backButtonTapped()
        
        currentLayoutStyle = .portrait
        AppDelegate.orientationLock = currentLayoutStyle.getOrientation()
    }
    
    private func showControllerView() {
        showController.accept(())
        hideControllerDelay.onNext(())
    }
    
    // View is Updated based on Orientation
    
    // Portrait <-> Landscape
    private func updateToPortrait() {
        guard [.landscape, .fullPortrait].contains(currentLayoutStyle)
        else { return }
        
        let previousLayoutStyle = currentLayoutStyle
        currentLayoutStyle = .portrait
        
        if previousLayoutStyle == .landscape {
            // FullPortrait는 변경시키지 않아도 되기 때문에 분기 처리
            AppDelegate.orientationLock = currentLayoutStyle.getOrientation()
        }
        
        setLayout.accept(currentLayoutStyle)
        controllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
        audioControllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
    }
    
    // Portrait <-> Landscape
    func updateToLandscape() {
        guard currentLayoutStyle != .landscape
        else { return }

        currentLayoutStyle = .landscape
        
        AppDelegate.orientationLock = currentLayoutStyle.getOrientation()
        setLayout.accept(currentLayoutStyle)
        controllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
        audioControllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
    }
    
    // Portrait <-> FullPortrait
    private func updateToFullPortrait() {
        guard currentLayoutStyle != .fullPortrait
        else { return }
        
        currentLayoutStyle = .fullPortrait

        setLayout.accept(currentLayoutStyle)
        controllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
        audioControllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
    }
    
}

extension PlayerPresenter: PlayerProtocol {
    
    // 플레이어 뷰에서 입력된 이벤트
    func handleEvent(_ event: PlayerEvent) -> Any? {
        switch event {
        case .playerTapped:
            if isShowSettingView {
                
                isShowSettingView = false
                
                if currentLayoutStyle == .landscape {
                    showSettingView.accept(isShowSettingView)
                }
                else {
                    showSettingPopup.accept(isShowSettingView)
                }
                
                settingView?.handleEvent(.reset)
            }
            else {
                showControllerView()
            }
        }
        
        return nil
    }
    
}

extension PlayerPresenter: PlayerControllerProtocol {
    
    // 컨트롤러에서 입력된 이벤트
    @discardableResult
    func handleEvent(_ event: ControllerEvent) -> Any? {
        switch event {
        case .controllerTapped:
            print("controllerTapped")
            hideControllerImmediately.onNext(())
            
        case .backButtonTapped:
            updateToPortrait()
            
        case .playButtonTapped:
            hideControllerDelay.onNext(())
            return interactor.handleEvent(.playButtonTapped)
            
        case .rewindButtonTapped:
            interactor.handleEvent(.seek(.rewind(count: 1)))
            hideControllerDelay.onNext(())
            
        case .forwardButtonTapped:
            interactor.handleEvent(.seek(.forward(count: 1)))
            hideControllerDelay.onNext(())
            
        case .showAudioButtonTapped:
            interactor.handleEvent(.audioButtonTapped(isUse: true))
            playerView?.handleEvent(.update(player: nil))
            showAudioController.accept(true)
            hideControllerImmediately.onNext(())
            
        case .settingButtonTapped:
            isShowSettingView = true
            
            if currentLayoutStyle == .landscape {
                showSettingView.accept(isShowSettingView)
            }
            else {
                showSettingPopup.accept(isShowSettingView)
            }
            
            //TODO: 세로뷰일 때, 세팅 팝업 뜨게
            hideControllerImmediately.onNext(())
            
        case .rotationButtonTapped:
            if asset.pixelWidth < asset.pixelHeight {
                currentLayoutStyle == .portrait ? updateToFullPortrait() : updateToPortrait()
            }
            else {
                // 가로일 때, 세로로 전환 / 세로일 때, 가로로 전환
                currentLayoutStyle == .portrait ? updateToLandscape() : updateToPortrait()
            }
        }
        
        return nil
    }
}

extension PlayerPresenter: PlayerAudioControllerProtocol {
    
    // 오디오 컨트롤러에서 입력된 이벤트
    @discardableResult
    func handleEvent(_ event: AudioControllerEvent) -> Any? {
        switch event {
        case .dismissAudioButtonTapped:
            guard let player = interactor.handleEvent(.audioButtonTapped(isUse: false)) as? AVPlayer
            else {
                fatalError()
            }
            playerView?.handleEvent(.update(player: player))
            showAudioController.accept(false)
            showControllerView()
            
        case .backButtonTapped:
            updateToPortrait()
            
        case .playButtonTapped:
            return interactor.handleEvent(.playButtonTapped)
        }
        
        return nil
    }
}

extension PlayerPresenter: PlayerSettingProtocol {

    @discardableResult
    func handleEvent(_ event: SettingEvent) -> Any? {
        switch event {
            
        case .updateGravity(let indexPath):
            selectedIndexPaths[2] = indexPath
            let index = indexPath.row
            let gravity = PlayerGravity.getValueFromIndex(index)
            playerView?.handleEvent(.updateGravity(gravity: gravity))
            settingView?.handleEvent(.updateSettingData(selectedIndexPaths: selectedIndexPaths))
            
            switch index {
            case 0:
                print("원본 비율")
            case 1:
                print("꽉찬 화면")
            default:
                break
            }
            
        case .updateQuality(let indexPath):
            selectedIndexPaths[0] = indexPath
            let index = indexPath.row
            let quality = PlayerQuality.getValueFromIndex(index)
            interactor.handleEvent(.updateQuality(quality))
            
            switch index {
            case 0:
                print("자동")
                
            case 1:
                print("1080p")
                
            case 2:
                print("720p")
                
            case 3:
                print("480p")
                
            default:
                break
            }
            
        case .updateSpeed(let indexPath):
            selectedIndexPaths[1] = indexPath
            let index = indexPath.row
            let speed = PlayerSpeed.getValueFromIndex(index)
            interactor.handleEvent(.updateSpeed(speed))
            
            switch index {
            case 0:
                print("0.5배")
                
            case 1:
                print("1.0배")
                
            case 2:
                print("1.25배")
                
            case 3:
                print("1.5배")
                
            case 4:
                print("2.0배")
                
            default:
                break
            }
            break
            
        case .closeView:
            isShowSettingView = false
            
            if currentLayoutStyle == .landscape {
                showSettingView.accept(isShowSettingView)
            }
            else {
                showSettingPopup.accept(isShowSettingView)
            }
            
        }
        return nil
    }
}

enum AssetError: Error {
    case invaild
}
