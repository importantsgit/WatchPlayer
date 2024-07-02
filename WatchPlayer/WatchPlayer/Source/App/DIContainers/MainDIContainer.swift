//
//  MainDIContainer.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

protocol MainDIContainerProtocol {
    func makeMainCoordinator(
        navigationController: UINavigationController?
    ) -> MainCoordinator
}

protocol MainDependencies {
    func makeVideoListDependencies(
    ) -> VideoListDIContainerProtocol
    
    func makeRecordDependencies(
    ) -> RecordDIContainerProtocol
    
    func makeSettingDependencies(
    ) -> SettingDIContainerProtocol
}

final public class MainDIContainer: MainDIContainerProtocol, MainDependencies {

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
    
    func makeMainCoordinator(
        navigationController: UINavigationController?
    ) -> MainCoordinator {
        .init(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    func makeVideoListDependencies(
    ) -> VideoListDIContainerProtocol {
        VideoListDIContainer(
            dependencies: .init(
                translationService: dependencies.translationService,
                dataService: dependencies.dataService,
                recordService: dependencies.recordService
            )
        )
    }
    
    func makeRecordDependencies(
    ) -> RecordDIContainerProtocol {
        RecordDIContainer(
            dependencies: .init(
                translationService: dependencies.translationService,
                dataService: dependencies.dataService,
                recordService: dependencies.recordService
            )
        )
    }
    
    func makeSettingDependencies(
    ) -> SettingDIContainerProtocol {
        SettingDIContainer(
            dependencies: .init(
                translationService: dependencies.translationService,
                dataService: dependencies.dataService,
                recordService: dependencies.recordService
            )
        )
    }
    
}
