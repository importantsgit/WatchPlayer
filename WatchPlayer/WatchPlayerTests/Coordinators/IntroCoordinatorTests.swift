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
        
        let permissionViewCount = introContainerDoc.makePermissionViewCallCount
        let permissionRouterCount = introContainerDoc.makePermissionRouterCallCount
        let permissionPresenterCount = introContainerDoc.makePermissionPresenterCallCount
        let permissionInteractorCount = introContainerDoc.makePermissionInteractorCallCount
        
        XCTAssertEqual(permissionViewCount, 1)
        XCTAssertEqual(permissionRouterCount, 1)
        XCTAssertEqual(permissionPresenterCount, 1)
        XCTAssertEqual(permissionInteractorCount, 1)
        
        let onboardingViewCount = introContainerDoc.makeOnboardingViewCallCount
        let onboardingRouterCount = introContainerDoc.makeOnboardingRouterCallCount
        let onboardingPresenterCount = introContainerDoc.makeOnboardingPresenterCallCount
        let onboardingInteractorCount = introContainerDoc.makeOnboardingInteractorCallCount
        
        XCTAssertEqual(onboardingViewCount, 0)
        XCTAssertEqual(onboardingRouterCount, 0)
        XCTAssertEqual(onboardingPresenterCount, 0)
        XCTAssertEqual(onboardingInteractorCount, 0)
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
        
        let permissionViewCount = introContainerDoc.makePermissionViewCallCount
        let permissionRouterCount = introContainerDoc.makePermissionRouterCallCount
        let permissionPresenterCount = introContainerDoc.makePermissionPresenterCallCount
        let permissionInteractorCount = introContainerDoc.makePermissionInteractorCallCount
        
        XCTAssertEqual(permissionViewCount, 0)
        XCTAssertEqual(permissionRouterCount, 0)
        XCTAssertEqual(permissionPresenterCount, 0)
        XCTAssertEqual(permissionInteractorCount, 0)
        
        let onboardingViewCount = introContainerDoc.makeOnboardingViewCallCount
        let onboardingRouterCount = introContainerDoc.makeOnboardingRouterCallCount
        let onboardingPresenterCount = introContainerDoc.makeOnboardingPresenterCallCount
        let onboardingInteractorCount = introContainerDoc.makeOnboardingInteractorCallCount
        
        XCTAssertEqual(onboardingViewCount, 1)
        XCTAssertEqual(onboardingRouterCount, 1)
        XCTAssertEqual(onboardingPresenterCount, 1)
        XCTAssertEqual(onboardingInteractorCount, 1)
    }
}
