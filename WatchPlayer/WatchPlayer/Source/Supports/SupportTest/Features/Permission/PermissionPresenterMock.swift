//
//  PermissionPresenterMock.swift
//  WatchPlayer
//
//  Created by Importants on 6/28/24.
//

import Foundation

final class PermissionPresenterMock: PermissionPresenterProtocol {

    let interator: PermissionInteractorProtocol
    let router: PermissionRouterProtocol
    
    init(
        interator: PermissionInteractorProtocol,
        router: PermissionRouterProtocol
    ) {
        self.interator = interator
        self.router = router
    }
    
    var viewDidLoadCallCount = 0
    func viewDidLoad() {
        viewDidLoadCallCount += 1
    }
    
    var permissionButtonTappedCallCount = 0
    func permissionButtonTapped() async {
        permissionButtonTappedCallCount += 1
        await interator.showPermissionPopup()
        router.showOnboardingView()
    }
}
