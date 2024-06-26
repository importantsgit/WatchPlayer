//
//  SceneDelegate.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let viewController = UIViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
    }
}

