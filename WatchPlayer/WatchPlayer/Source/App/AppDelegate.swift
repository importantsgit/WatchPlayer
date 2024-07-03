//
//  AppDelegate.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


    static var orientationRotate = UIInterfaceOrientationMask.portrait {
        didSet {
            UIApplication.shared.connectedScenes.forEach { scene in
                if let windowScene = scene as? UIWindowScene {
                    windowScene.requestGeometryUpdate(
                        .iOS(interfaceOrientations: orientationRotate))
                }
            }
            UIViewController.attemptRotationToDeviceOrientation()
        }
        
    }
    

    /**
     회전할 수 있는 방향을 지정하는 변수, 첫 진입시 portrait 고정
     */
    static var orientationLock: UIInterfaceOrientationMask = .portrait {
        didSet{
            if let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene{
                if let rootViewController = firstScene.windows.first?.rootViewController{
                    rootViewController.setNeedsUpdateOfSupportedInterfaceOrientations()
                }
            }
        }
    }
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }

}

