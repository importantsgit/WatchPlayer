//
//  MainDIContainerMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

final public class MainDIContainerMock: MainDIContainerProtocol, MainDependencies {

    struct Dependencies {
        let translationService: TranslationServiceMock
        let dataService: DataServiceMock
        let recordService: RecordServiceMock
        let libraryService: LibraryServiceMock
        let playerService: PlayerServiceMock
    }
    
    let dependencies: Dependencies
    
    init(
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
    }
    
    var makeMainCoordinatorCallCount = 0
    func makeMainCoordinator(
        navigationController: UINavigationController?
    ) -> MainCoordinator {
        makeMainCoordinatorCallCount += 1
        return .init(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    var makeVideoListDependenciesCallCount = 0
    func makeVideoListDependencies(
    ) -> VideoListDIContainerProtocol {
        makeVideoListDependenciesCallCount += 1
        return VideoListDIContainerMock(
            dependencies: .init(
                translationService: dependencies.translationService,
                dataService: dependencies.dataService,
                recordService: dependencies.recordService,
                libraryService: dependencies.libraryService, 
                playerService: dependencies.playerService
            )
        )
    }
    
    var makeRecordDependenciesCallCount = 0
    func makeRecordDependencies(
    ) -> RecordDIContainerProtocol {
        makeRecordDependenciesCallCount += 1
        return RecordDIContainerMock(
            dependencies: .init(
                translationService: dependencies.translationService,
                dataService: dependencies.dataService,
                recordService: dependencies.recordService
            )
        )
    }
    
    var makeSettingDependenciesCallCount = 0
    func makeSettingDependencies(
    ) -> SettingDIContainerProtocol {
        makeSettingDependenciesCallCount += 1
        return SettingDIContainerMock(
            dependencies: .init(
                translationService: dependencies.translationService,
                dataService: dependencies.dataService,
                recordService: dependencies.recordService
            )
        )
    }
}

