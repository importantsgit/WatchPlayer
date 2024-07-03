//
//  TranslationRepositoryMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

final public class TranslationRepositoryMock: TranslationRepositoryInterface {
    let translationService: TranslationServiceMock
    
    init(
        translationService: TranslationServiceMock
    ) {
        self.translationService = translationService
    }
}
