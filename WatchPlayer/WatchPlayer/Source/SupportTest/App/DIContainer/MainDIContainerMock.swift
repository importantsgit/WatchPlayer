//
//  MainDIContainerMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

final public class MainDIContainerMock: MainDependencies {
    
    struct Depedencies {
        let translationService: TranslationServiceInterface
        let dataService: DataServiceInterface
    }
    
    let depedencies: Depedencies
    
    init(
        depedencies: Depedencies
    ) {
        self.depedencies = depedencies
    }
}

