//
//  SettingCoordinatorTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 7/2/24.
//

import XCTest
@testable import WatchPlayer

final class SettingCoordinatorTests: XCTestCase {
    var navigationViewController: UINavigationController!
    var settingDIContainerDoc: SettingDIContainerMock!
    var recordContainerDocDependencies: SettingDIContainerMock.Dependencies!
    var sut: SettingCoordinator!

    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        navigationViewController = nil
        settingDIContainerDoc = nil
        recordContainerDocDependencies = nil
        sut = nil
        try super.tearDownWithError()
    }


}
