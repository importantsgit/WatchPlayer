//
//  AppDIContainerMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

final public class AppDIContainerMock: AppDependencies {
    
    var dataService: DataServiceInterface = {
        let mock = DataServiceMock()
        return mock
    }()
    
    var translationService: TranslationServiceInterface = {
        let mock = TranslationServiceMock()
        return mock
    }()
    
    var makeMainDependenciesCount = 0
    func makeMainDependencies(
    ) -> MainDependencies {
        makeMainDependenciesCount += 1
        return MainDIContainerMock(
            depedencies: .init(
                translationService: translationService,
                dataService: dataService
            )
        )
    }
    
}
