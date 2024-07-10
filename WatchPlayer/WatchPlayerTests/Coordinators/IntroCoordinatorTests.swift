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
        let permissionViewisRootView = sut.rootViewController is PermissionViewController
        let onboardingViewisRootView = sut.rootViewController is OnboardingViewController
        
        XCTAssertTrue(permissionViewisRootView)
        XCTAssertFalse(onboardingViewisRootView)
        
        let permissionCount = introContainerDoc.makePermissionModuleCallCount
        XCTAssertEqual(permissionCount, 1)
        
        let onboardingCount = introContainerDoc.makeOnboardModuleCallCount
        XCTAssertEqual(onboardingCount, 0)
    }
    
    func testShowOnboardingView() {
        // Given
        introContainerDoc.dependencies.dataService.dismissPermissionViewForever()
        // When
        sut.start()
        // Then
        let permissionViewisRootView = sut.rootViewController is PermissionViewController
        let onboardingViewisRootView = sut.rootViewController is OnboardingViewController
        
        XCTAssertFalse(permissionViewisRootView)
        XCTAssertTrue(onboardingViewisRootView)
        
        let permissionCount = introContainerDoc.makePermissionModuleCallCount
        XCTAssertEqual(permissionCount, 0)
        
        let onboardingCount = introContainerDoc.makeOnboardModuleCallCount
        XCTAssertEqual(onboardingCount, 1)
    }
}
