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
    
    var recordService: RecordServiceInterface = {
        let mock = RecordServiceMock()
        return mock
    }()
    
    var makeIntroDependenciesCallCount = 0
    func makeIntroDependencies(
    ) -> IntroDIContainerProtocol {
        makeIntroDependenciesCallCount += 1
        return IntroDIContainerMock(
            dependencies: .init(
                translationService: translationService,
                dataService: dataService,
                recordService: recordService
            )
        )
    }
    
    var makeMainDependenciesCallCount = 0
    func makeMainDependencies(
    ) -> MainDIContainerProtocol {
        makeMainDependenciesCallCount += 1
        return MainDIContainerMock(
            dependencies: .init(
                translationService: translationService,
                dataService: dataService,
                recordService: recordService
            )
        )
    }
}
