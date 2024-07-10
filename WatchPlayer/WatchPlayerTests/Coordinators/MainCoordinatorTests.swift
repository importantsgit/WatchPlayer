//
//  MainCoordinatorTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 7/2/24.
//

import XCTest
@testable import WatchPlayer

final class MainCoordinatorTests: XCTestCase {
    var navigationViewController: UINavigationController!
    var mainDIContainerDoc: MainDIContainerMock!
    var mainContainerDocDependencies: MainDIContainerMock.Dependencies!
    var sut: MainCoordinator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        navigationViewController = .init()
        
        mainContainerDocDependencies = .init(
            translationService: TranslationServiceMock(),
            dataService: DataServiceMock(),
            recordService: RecordServiceMock(),
            libraryService: LibraryServiceMock(),
            playerService: PlayerServiceMock()
        )
        
        mainDIContainerDoc = .init(dependencies: mainContainerDocDependencies)
        
        sut = .init(
            navigationController: navigationViewController,
            dependencies: mainDIContainerDoc
        )
    }

    override func tearDownWithError() throws {
        navigationViewController = nil
        mainDIContainerDoc = nil
        mainContainerDocDependencies = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testMainFlowStart() {
        // Given
        
        // When
        sut.start()
        
        // Then
        let tabbarIsRootView = sut.rootViewController is UITabBarController
        let recordDIContainerCount = mainDIContainerDoc.makeRecordDependenciesCallCount
        let videoListDIContainerCount = mainDIContainerDoc.makeVideoListDependenciesCallCount
        let settingDIContainerCount = mainDIContainerDoc.makeSettingDependenciesCallCount
        
        XCTAssertTrue(tabbarIsRootView)
        XCTAssertEqual(recordDIContainerCount, 1)
        XCTAssertEqual(videoListDIContainerCount, 1)
        XCTAssertEqual(settingDIContainerCount, 1)
    }

}
