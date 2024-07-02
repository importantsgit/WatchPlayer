//
//  MainCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit
import RxSwift

protocol MainRouterManageable: NodeCoordinator {
    var navigationController: UINavigationController? { get }
    var rootViewController: UIViewController? { get }
}

final public class MainCoordinator: NSObject, MainRouterManageable {
    var childCoordinators: [BaseCoordinator] = []
    private var disposeBag = DisposeBag()
    
    weak public private(set) var navigationController: UINavigationController?
    weak public private(set) var rootViewController: UIViewController?
    
    private let dependencies: MainDependencies
    let tabbarController: UITabBarController
    
    init(
        navigationController: UINavigationController?,
        dependencies: MainDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.tabbarController = .init()
        
        super.init()
    }
    
    func start() {
        let scenes: [TabBarScene] = [.videoList, .record, .setting]
        let controllers: [DefaultViewController] = scenes.compactMap { getViewController($0)
        }
        prepareTabbarController(with: controllers)
    }
}

extension MainCoordinator {
    func getViewController(
        _ scene: TabBarScene
    ) -> DefaultViewController {
        let viewController: UIViewController?
        switch scene {
        case .videoList:
            let videoListDependencies = dependencies.makeVideoListDependencies()
            let videoListCoordinator = videoListDependencies.makeVideoListCoordinator(
                navigationController: navigationController
            )
            
            childCoordinators.append(videoListCoordinator)
            videoListCoordinator.start()
            viewController = videoListCoordinator.rootViewController
            
        case.record:
            let recordDependencies = dependencies.makeRecordDependencies()
            let recordCoordinator = recordDependencies.makeRecordCoordinator(
                navigationController: navigationController
            )
            
            childCoordinators.append(recordCoordinator)
            recordCoordinator.start()
            viewController = recordCoordinator.rootViewController
        
            
        case .setting:
            let settingDependencies = dependencies.makeSettingDependencies()
            let settingCoordinator = settingDependencies.makeSettingCoordinator(
                navigationController: navigationController
            )
            
            childCoordinators.append(settingCoordinator)
            settingCoordinator.start()
            viewController = settingCoordinator.rootViewController
        }
        
        
        guard let viewController = viewController as? DefaultViewController
        else {
            fatalError("TabBar에 포함될 \(scene)View가 없습니다.")
        }
        
        viewController.tabBarItem = .init(
            title: scene.getTitle(),
            image: scene.getTabIcon(),
            tag: scene.rawValue
        )
        
        return viewController
    }
    
    func prepareTabbarController(
        with tabs: [DefaultViewController]
    ) {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .primary
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        tabbarController.setViewControllers(tabs, animated: true)
        tabbarController.tabBar.isTranslucent = false
        tabbarController.tabBar.backgroundColor = .primary
        tabbarController.tabBar.tintColor = .white
        tabbarController.tabBar.unselectedItemTintColor = .disabled
        self.navigationController?.setViewControllers([tabbarController], animated: false)
        rootViewController = tabbarController
    }
}

enum TabBarScene: Int {
    case videoList = 0
    case record
    case setting
    
    func getTitle() -> String {
        switch self {
        case .videoList: return "비디오 리스트"
        case .record: return "영상 촬영"
        case .setting: return "설정"
        }
    }
    
    func getTabIcon() -> UIImage {
        switch self {
        case .videoList: return .camera
        case .record: return .camera
        case .setting: return .camera
        }
    }
}


