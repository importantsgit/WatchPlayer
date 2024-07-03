//
//  OnboardingModuleTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 7/2/24.
//

import XCTest
import RxTest
@testable import WatchPlayer

final class OnboardingModuleTests: XCTestCase {
    
    var dataRepository: DataRepositoryMock!
    var interactor: OnboardingInteractorMock!
    var presenter: OnboardingPresenterMock!
    var router: OnboardingRouterMock!

    var sub: OnboardingViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        
        self.dataRepository = .init(dataService: DataServiceMock())
        
        self.interactor = .init(dataRepository: dataRepository)
        
        self.router = .init(
            actions: .init(finishFlow: .init())
        )
        
        self.presenter = .init(
            interactor: interactor,
            router: router
        )
        
        self.sub = .init(
            presenter: presenter
        )
    }

    override func tearDownWithError() throws {
        dataRepository = nil
        interactor = nil
        presenter = nil
        router = nil
        sub = nil
        try super.tearDownWithError()
    }

    func testConfirmButtonTapped() {
        // Given
        
        // When
        sub.confirmButtonTapped()
        
        // Then
        let routerCount = router.dismissOnboardingViewCallCount
        let presenterCount = presenter.confirmButtonTappedCallCount
        
        XCTAssertEqual(presenterCount, 1)
        XCTAssertEqual(routerCount, 1)
    }
}
