//
//  RootCoordinatorTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 6/26/24.
//

import XCTest
@testable import WatchPlayer

final class RootCoordinatorTests: XCTestCase {
    var navigationViewController: UINavigationController!
    var appDIContainerDoc: AppDIContainerMock!
    var sut: RootCoordinator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        navigationViewController = .init()
        
        appDIContainerDoc = .init()
        
        sut = .init(
            navigationController: navigationViewController,
            dependencies: appDIContainerDoc
        )
    }

    override func tearDownWithError() throws {
        navigationViewController = nil
        appDIContainerDoc = nil
        sut = nil
        
        try super.tearDownWithError()
    }
    
    // 시나리오: 앱 처음 진입(설치)한 상황
    func testMakeIntroDenpendecies() {
        // Given
        
        // When
        sut.start()
        
        // Then
        let introDependenciesCount = appDIContainerDoc.makeIntroDependenciesCallCount
        XCTAssertEqual(introDependenciesCount, 1)
        
        let mainDependenciesCount = appDIContainerDoc.makeMainDependenciesCallCount
        XCTAssertEqual(mainDependenciesCount, 0)
    }
    
    // 시나리오: 권한 페이지를 닫은 상황
    func testMakeIntroDenpendeciesWhenDismissPermissionView() {
        // Given
        appDIContainerDoc.dataService.dismissPermissionViewForever()
        
        // When
        sut.start()
        
        // Then
        let introDependenciesCount = appDIContainerDoc.makeIntroDependenciesCallCount
        XCTAssertEqual(introDependenciesCount, 1)
        
        let mainDependenciesCount = appDIContainerDoc.makeMainDependenciesCallCount
        XCTAssertEqual(mainDependenciesCount, 0)
    }
    
    // 시나리오: 권한 페이지와 가이드 페이지를 닫은 상황
    func testMakeMainDenpendeciesWhenDismissPermissionViewAndOnboardingView() {
        // Given
        appDIContainerDoc.dataService.dismissPermissionViewForever()
        appDIContainerDoc.dataService.dismissOnboardingViewForever()
        
        // When
        sut.start()
        
        // Then
        let introDependenciesCount = appDIContainerDoc.makeIntroDependenciesCallCount
        XCTAssertEqual(introDependenciesCount, 0)
        
        let mainDependenciesCount = appDIContainerDoc.makeMainDependenciesCallCount
        XCTAssertEqual(mainDependenciesCount, 1)
    }
    
    // 시나리오: 권한 페이지를 보지 않고 가이드 페이지로 넘어간 상황
    func testMakeIntroDenpendeciesWhenDismissOnboardingView() {
        // Given
        appDIContainerDoc.dataService.dismissOnboardingViewForever()
        
        // When
        sut.start()
        
        // Then
        let introDependenciesCount = appDIContainerDoc.makeIntroDependenciesCallCount
        XCTAssertEqual(introDependenciesCount, 1)
        
        let mainDependenciesCount = appDIContainerDoc.makeMainDependenciesCallCount
        XCTAssertEqual(mainDependenciesCount, 0)
    }
    
}
