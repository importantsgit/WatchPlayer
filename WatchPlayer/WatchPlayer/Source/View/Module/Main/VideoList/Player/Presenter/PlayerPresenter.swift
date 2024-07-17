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

protocol PlayerPresenterInputProtocol {
    func viewDidLoad()
    func backButtonTapped()
    func deleteButtonTapped()
}

protocol PlayerPresenterOutputProtocol {

}

typealias PlayerPresenterProtocol = PlayerPresenterInputProtocol & PlayerPresenterOutputProtocol

final class PlayerPresenter: NSObject, PlayerPresenterProtocol {
    
    let router: PlayerRouterProtocol
    let interactor: PlayerInteractorProtocol
    let asset: PHAsset
    
    // MARK: - PlayerView, Controller Binding with Handler
    weak var playerViewController: PlayerViewControllerProtocol?
    weak var playerView: PlayerViewProtocol?
    weak var controllerView: PlayerControllerViewProtocol?
    weak var audioControllerView: PlayerAudioControllerViewProtocol?
    weak var settingView: PlayerSettingViewProtocol?
    weak var settingPopup: PlayerSettingViewProtocol?
    
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
        
        let title = asset.creationDate?.getDateString() ?? Date.getCurrentDateString()
        playerViewController?.handle(event: .setTitle(title: title))
        controllerView?.handleEvent(.setTitle(title: title))
        audioControllerView?.handleEvent(.setTitle(title: title))
        
        
        Task {
            do {
                let item = try await interactor.fetchAVPlayerItem(asset)
            
                let player = AVPlayer(playerItem: item)
                let playerLayer = AVPlayerLayer(player: player)
                
                // 이 Task는 Main 스레드에서 실행되지 않기 때문에 UIUpdate를 하기 위해 MainActor.run를 적용시켜야 한다
                await MainActor.run {
                    playerView?.handleEvent(.set(playerLayer: playerLayer))
                    playerViewController?.handle(event: .didLoadPlayer)
                }
                
                let getServiceEvent = interactor.set(player: player)
                getServiceEvent
                    .subscribe(on: MainScheduler.instance)
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
    
    func backButtonTapped() {
        interactor.handleEvent(.backButtonTapped)
        router.dismissView()
        
        currentLayoutStyle = .portrait
        AppDelegate.orientationLock = currentLayoutStyle.getOrientation()
    }
    
    func deleteButtonTapped() {
        router.showDeletePopup()
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .backgroundTapped, .dismissed:
                    // TODO: DO SomeThing
                    break
                    
                case .buttonTapped(let index):
                    guard index == 1
                    else { return }
                    
                    self?.interactor.deleteAsset()
                    self?.router.dismissView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showControllerView() {
        playerViewController?.handle(event: .updateControllerVisibility(isVisible: .show))
        playerViewController?.handle(event: .updateControllerVisibility(isVisible: .hideDelay))
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
        
        playerViewController?.handle(event: .updateLayout(style: currentLayoutStyle))
        controllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
        audioControllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
    }
    
    // Portrait <-> Landscape
    func updateToLandscape() {
        guard currentLayoutStyle != .landscape
        else { return }

        currentLayoutStyle = .landscape
        
        AppDelegate.orientationLock = currentLayoutStyle.getOrientation()
        playerViewController?.handle(event: .updateLayout(style: currentLayoutStyle))
        controllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
        audioControllerView?.handleEvent(.updateLayout(style: currentLayoutStyle))
    }
    
    // Portrait <-> FullPortrait
    private func updateToFullPortrait() {
        guard currentLayoutStyle != .fullPortrait
        else { return }
        
        currentLayoutStyle = .fullPortrait

        playerViewController?.handle(event: .updateLayout(style: currentLayoutStyle))
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
                
                playerViewController?.handle(event: currentLayoutStyle == .landscape ?
                    .updateSettingViewVisibility(isVisible: isShowSettingView) :
                    .updateSettingPopupVisibility(isVisible: isShowSettingView)
                )
                
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
            playerViewController?.handle(event: .updateControllerVisibility(isVisible: .hideImmediately))
            
        case .backButtonTapped:
            updateToPortrait()
            
        case .playButtonTapped:
            playerViewController?.handle(event: .updateControllerVisibility(isVisible: .hideDelay))
            return interactor.handleEvent(.playButtonTapped)
            
        case .rewindButtonTapped:
            playerViewController?.handle(event: .updateControllerVisibility(isVisible: .hideDelay))
            interactor.handleEvent(.seek(.rewind(count: 1)))
            
        case .forwardButtonTapped:
            playerViewController?.handle(event: .updateControllerVisibility(isVisible: .hideDelay))
            interactor.handleEvent(.seek(.forward(count: 1)))
            
        case .showAudioButtonTapped:
            interactor.handleEvent(.audioButtonTapped(isUse: true))
            playerView?.handleEvent(.update(player: nil))
            playerViewController?.handle(event: .updateAudioControllerVisibility(isVisible: true))
            playerViewController?.handle(event: .updateControllerVisibility(isVisible: .hideImmediately))
            
        case .settingButtonTapped:
            isShowSettingView = true
            
            playerViewController?.handle(event: currentLayoutStyle == .landscape ?
                .updateSettingViewVisibility(isVisible: isShowSettingView) :
                .updateSettingPopupVisibility(isVisible: isShowSettingView)
            )
            
            playerViewController?.handle(event: .updateControllerVisibility(isVisible: .hideImmediately))
            
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
            playerViewController?.handle(event: .updateAudioControllerVisibility(isVisible: false))
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
            settingPopup?.handleEvent(.updateSettingData(selectedIndexPaths: selectedIndexPaths))
            
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
            settingView?.handleEvent(.updateSettingData(selectedIndexPaths: selectedIndexPaths))
            settingPopup?.handleEvent(.updateSettingData(selectedIndexPaths: selectedIndexPaths))
            
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
            settingView?.handleEvent(.updateSettingData(selectedIndexPaths: selectedIndexPaths))
            settingPopup?.handleEvent(.updateSettingData(selectedIndexPaths: selectedIndexPaths))
            
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
            
            playerViewController?.handle(event: currentLayoutStyle == .landscape ?
                .updateSettingViewVisibility(isVisible: isShowSettingView) :
                .updateSettingPopupVisibility(isVisible: isShowSettingView)
            )
            
        }
        return nil
    }
}

enum AssetError: Error {
    case invaild
}
