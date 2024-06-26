//
//  DataService.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol DataServiceInterface {}

final public class DataService: DataServiceInterface {
    
    struct Configuration {
        
    }
    
    let configuration: Configuration
    
    init(
        configuration: Configuration
    ) {
        self.configuration = configuration
    }
}
