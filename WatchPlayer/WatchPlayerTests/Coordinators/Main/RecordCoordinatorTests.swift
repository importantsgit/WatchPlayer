//
//  RecordCoordinatorTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 7/2/24.
//

import XCTest
@testable import WatchPlayer

final class RecordCoordinatorTests: XCTestCase {
    var navigationViewController: UINavigationController!
    var recordDIContainerDoc: RecordDIContainerMock!
    var recordContainerDocDependencies: RecordDIContainerMock.Dependencies!
    var sut: RecordCoordinator!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        navigationViewController = nil
        recordDIContainerDoc = nil
        recordContainerDocDependencies = nil
        sut = nil
        try super.tearDownWithError()
    }


}
