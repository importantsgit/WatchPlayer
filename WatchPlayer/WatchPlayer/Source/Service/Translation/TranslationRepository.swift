//
//  TranslationRepository.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol TranslationRepositoryInterface {
    
}

final public class TranslationRepository: TranslationRepositoryInterface {
    
    let translationService: TranslationServiceInterface
    
    init(
        translationService: TranslationServiceInterface
    ) {
        self.translationService = translationService
    }
    
}
