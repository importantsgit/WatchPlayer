//
//  PermissionModuleTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 6/27/24.
//

import XCTest
import RxTest
@testable import WatchPlayer

final class PermissionModuleTests: XCTestCase {
    var interactor: PermissionInteractorMock!
    var presenter: PermissionPresenterMock!
    var router: PermissionRouterMock!
    var view: PermissionViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let dataRepositoryMock = DataRepositoryMock(
            dataService: DataServiceMock()
        )
        
        let permissionRouterActionsMock = PermissionRouterActions(
            showOnboardingView: .init()
        )
        
        interactor = .init(
            dataRepository: dataRepositoryMock
        )
        
        router = .init(actions: permissionRouterActionsMock)
        
        presenter = .init(
            interator: interactor,
            router: router
        )
        
        view = .init(presenter: presenter)
    }

    override func tearDownWithError() throws {
        interactor = nil
        presenter = nil
        router = nil
        view = nil
        
        try super.tearDownWithError()
    }
    
    func testShowPermissionPopup() async {
        // Given
        
        // When
        await view.presenter.permissionButtonTapped()
        
        // Then
        let presenterCount = presenter.permissionButtonTappedCallCount
        let interactorCount = interactor.showPermissionPopupCallCount
        let dataRepositoryCount = interactor.dataRepository.dismissPermissionViewForeverCallCount
        let dataServiceCount = interactor.dataRepository.dataService.dismissPermissionViewForeverCallCount
        let routerCount = router.showOnboardingViewCallCount
        
        XCTAssertEqual(presenterCount, 1)
        XCTAssertEqual(interactorCount, 1)
        XCTAssertEqual(dataRepositoryCount, 1)
        XCTAssertEqual(dataServiceCount, 1)
        XCTAssertEqual(routerCount, 1)
        
        
    }
}
