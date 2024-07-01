//
//  IntroCoordinatorTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 6/27/24.
//

import XCTest
@testable import WatchPlayer

final class IntroCoordinatorTests: XCTestCase {
    var navigationViewController: UINavigationController!
    var introContainerDoc: IntroDIContainerMock!
    var introContainerDocDependencies: IntroDIContainerMock.Dependencies!
    var sut: IntroCoordinator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        navigationViewController = .init()
        
        introContainerDocDependencies = .init(
            translationService: TranslationServiceMock(),
            dataService: DataServiceMock(),
            recordService: RecordServiceMock()
        )
        
        introContainerDoc = .init(
            dependencies: introContainerDocDependencies
        )
        
        sut = .init(
            navigationController: navigationViewController,
            dependencies: introContainerDoc,
            actions: .init(finishFlow: .init())
        )
    }

    override func tearDownWithError() throws {
        introContainerDocDependencies = nil
        navigationViewController = nil
        introContainerDoc = nil
        sut = nil
        
        try super.tearDownWithError()
    }

    func testShowPermissionView() {
        // Given
        
        // When
        sut.start()
        
        // Then
        let permissionViewCount = introContainerDoc.makePermissionViewCallCount
        let permissionRouterCount = introContainerDoc.makePermissionRouterCallCount
        let permissionPresenterCount = introContainerDoc.makePermissionPresenterCallCount
        let permissionInteractorCount = introContainerDoc.makePermissionInteractorCallCount
        
        XCTAssertEqual(permissionViewCount, 1)
        XCTAssertEqual(permissionRouterCount, 1)
        XCTAssertEqual(permissionPresenterCount, 1)
        XCTAssertEqual(permissionInteractorCount, 1)
        
    }
}
