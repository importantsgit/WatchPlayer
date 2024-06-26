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
    
    func makeIntroDependencies(
    ) -> IntroDIContainer
    
    func makeMainDependencies(
    ) -> MainDIContainer
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
    
    func makeIntroDependencies(
    ) -> IntroDIContainer {
        IntroDIContainer(
            dependencies: .init(
                translationService: translationService,
                dataService: dataService
            )
        )
    }
    
    func makeMainDependencies(
    ) -> MainDIContainer {
        MainDIContainer(
            dependencies: .init(
                translationService: translationService,
                dataService: dataService
            )
        )
    }
}
