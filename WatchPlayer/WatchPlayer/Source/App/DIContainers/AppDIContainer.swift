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

    func makeIntroDependencies(
    ) -> IntroDIContainerProtocol {
        IntroDIContainer(
            dependencies: .init(
                translationService: translationService,
                dataService: dataService
            )
        )
    }
    
    func makeMainDependencies(
    ) -> MainDIContainerProtocol {
        MainDIContainer(
            dependencies: .init(
                translationService: translationService,
                dataService: dataService
            )
        )
    }
}
