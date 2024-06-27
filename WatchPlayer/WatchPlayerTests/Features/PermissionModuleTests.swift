//
//  PermissionModuleTests.swift
//  WatchPlayerTests
//
//  Created by 이재훈 on 6/27/24.
//

import XCTest
@testable import WatchPlayer

final class PermissionModuleTests: XCTestCase {
    var interactor: PermissionInteractorMock!
    var presenter: PermissionPresenterMock!
    var router: PermissionRouterMock!
    var view: PermissionViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let dataRepositoryMock = DataRepositoryMock(
            dataService: DataServiceMock()
        )
        
        let permissionRouterActionsMock = PermissionRouterActions()
        
        interactor = .init(
            dataRepository: dataRepositoryMock
        )
        
        router = .init(actions: permissionRouterActionsMock)
        
        presenter = .init(
            interator: interactor,
            router: router
        )
        
        view = .init(presenter: presenter)
    }

    override func tearDownWithError() throws {
        interactor = nil
        presenter = nil
        router = nil
        view = nil
        
        try super.tearDownWithError()
    }
}
