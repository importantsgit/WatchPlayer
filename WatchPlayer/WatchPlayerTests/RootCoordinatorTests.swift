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
    
    func testMakePermission() {
        // Given
        
        // When
        sut.startMainFlow()
        
        // Then
        let mainDependenciesCount = appDIContainerDoc.makeMainDependenciesCount
        XCTAssertEqual(mainDependenciesCount, 1)
    }
    
    func testMakeIntro() {
        
    }
    
    func testMakeMainFlow() {
        
    }
    
}
