//
//   TranslationService.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol TranslationServiceInterface {
    
}

final public class TranslationService: TranslationServiceInterface {
    
    struct TranslationConfiguration {
        
    }
    
    let configuration: TranslationConfiguration
    
    init(
        configuration: TranslationConfiguration
    ) {
        self.configuration = configuration
    }
}
