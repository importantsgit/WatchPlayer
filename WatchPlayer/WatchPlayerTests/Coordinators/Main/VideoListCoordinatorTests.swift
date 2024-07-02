//
//  VideoListCoordinatorTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 7/2/24.
//

import XCTest
@testable import WatchPlayer

final class VideoListCoordinatorTests: XCTestCase {
    var navigationViewController: UINavigationController!
    var videoListDIContainerDoc: VideoListDIContainerMock!
    var videoListContainerDocDependencies: VideoListDIContainerMock.Dependencies!
    var sut: VideoListCoordinator!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        navigationViewController = nil
        videoListDIContainerDoc = nil
        videoListContainerDocDependencies = nil
        sut = nil
        try super.tearDownWithError()
    }


}
