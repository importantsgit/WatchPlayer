//
//  VideoListModuleTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 7/3/24.
//

import XCTest
import RxSwift
@testable import WatchPlayer

final class VideoListModuleTests: XCTestCase {
    
    var libraryRepository: LibraryRepositoryMock!
    var interactor: VideoListInteractorMock!
    var router: VideoListRouterMock!
    var presenter: VideoListPresenterMock!
    
    var sub: VideoListViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        libraryRepository = .init(libraryService: LibraryServiceMock())
        
        interactor = .init(libraryRepository: libraryRepository)
        
        router = .init()
        
        presenter = .init(router: router, interactor: interactor)
        
        sub = .init(presenter: presenter)
        
    }

    override func tearDownWithError() throws {
        libraryRepository = nil
        interactor = nil
        router = nil
        presenter = nil
        sub = nil
        
        try super.tearDownWithError()
    }

    // FIXME: 수정바람
//    func testFetchVideoWhenViewDidLoad() async {
//        
//        // When
//        let expectation = XCTestExpectation(description: "await Test")
//        
//        await sub.viewDidLoad()
//        
//        // Then
//        await fulfillment(of: [expectation], timeout: 1.0)
//        let presenterViewDidLoadCount = presenter.viewDidLoadCallCount
//        let presenterFetchVideoCount = presenter.fetchVideosCallCount
//        let interactorCount = interactor.fetchVideosCallCount
//        let libraryRepositoryCount = libraryRepository.fetchVideosCallCount
//        let libraryServiceCount = libraryRepository.libraryService.fetchVideosCallCount
//        
//        XCTAssertEqual(presenterViewDidLoadCount, 1)
//        XCTAssertEqual(presenterFetchVideoCount, 1)
//        XCTAssertEqual(interactorCount, 1)
//        XCTAssertEqual(libraryRepositoryCount, 1)
//        XCTAssertEqual(libraryServiceCount, 1)
//    }
    
    // FIXME: 수정바람
//    func testFetchVideoWhenDidScroll() {
//        
//        
//        let scrollView = UIScrollView()
//        scrollView.contentSize = CGSize(width: 1000, height: 0)
//        scrollView.frame.size = CGSize(width: 1000, height: 0)
//        scrollView.contentOffset.y = 1000
//        
//        Task {
//            let expectation = XCTestExpectation(description: "await Test")
//            // When
//            await fulfillment(of: [expectation], timeout: 1.0)
//            await sub.scrollViewDidScroll(scrollView)
//            
//            // Then
//            let presenterCount = presenter.fetchVideosCallCount
//            let interactorCount = interactor.fetchVideosCallCount
//            let libraryRepositoryCount = libraryRepository.fetchVideosCallCount
//            let libraryServiceCount = libraryRepository.libraryService.fetchVideosCallCount
//            
//            XCTAssertEqual(presenterCount, 1)
//            XCTAssertEqual(interactorCount, 1)
//            XCTAssertEqual(libraryRepositoryCount, 1)
//            XCTAssertEqual(libraryServiceCount, 1)
//        }
//
//    }
    
}
