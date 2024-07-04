//
//  AppDIContainer.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol AppDependencies {
    var dataService: DataServiceInterface { get }
    var translationService: TranslationServiceInterface { get }
    var recordService: RecordServiceInterface { get }
    var libraryService: LibraryServiceInterface { get }
    var playerService: PlayerServiceInterface { get }
    
    func makeIntroDependencies(
    ) -> IntroDIContainerProtocol
    
    func makeMainDependencies(
    ) -> MainDIContainerProtocol
}

final public class AppDIContainer: AppDependencies {
    
    lazy var appConfiguration: AppConfiguration = .init()
    
    lazy var dataService: DataServiceInterface = {
        let dataService = DataService(
            configuration: .init()
        )
        
        return dataService
    }()
    
    lazy var translationService: TranslationServiceInterface = {
        let translationService = TranslationService(
            configuration: .init()
        )
        
        return translationService
    }()
    
    lazy var recordService: RecordServiceInterface = {
        let recordService = RecordService(
            configuration: .init()
        )
        
        return recordService
    }()
    
    lazy var libraryService: LibraryServiceInterface = {
        let libraryService = LibraryService(
            configuration: .init(
                fetchLimit: appConfiguration.fetchLimit
            )
        )
        return libraryService
    }()
    
    lazy var playerService: PlayerServiceInterface = {
        let playerService = PlayerService()
        
        return playerService
    }()
    
    func makeIntroDependencies(
    ) -> IntroDIContainerProtocol {
        IntroDIContainer(
            dependencies: .init(
                translationService: translationService,
                dataService: dataService,
                recordService: recordService
            )
        )
    }
    
    func makeMainDependencies(
    ) -> MainDIContainerProtocol {
        MainDIContainer(
            dependencies: .init(
                translationService: translationService,
                dataService: dataService,
                recordService: recordService,
                libraryService: libraryService,
                playerService: playerService
            )
        )
    }
}
