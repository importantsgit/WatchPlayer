//
//  MainDIContainerMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

final public class MainDIContainerMock: MainDIContainerProtocol, MainDependencies {

    struct Dependencies {
        let translationService: TranslationServiceInterface
        let dataService: DataServiceInterface
        let recordService: RecordServiceInterface
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
        return VideoListDIContainer(
            dependencies: .init(
                translationService: dependencies.translationService,
                dataService: dependencies.dataService,
                recordService: dependencies.recordService
            )
        )
    }
    
    var makeRecordDependenciesCallCount = 0
    func makeRecordDependencies(
    ) -> RecordDIContainerProtocol {
        makeRecordDependenciesCallCount += 1
        return RecordDIContainer(
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
        return SettingDIContainer(
            dependencies: .init(
                translationService: dependencies.translationService,
                dataService: dependencies.dataService,
                recordService: dependencies.recordService
            )
        )
    }
}

