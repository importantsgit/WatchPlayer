//
//  DataRepository.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol DataRepositoryInterface {}

final public class DataRepository: DataRepositoryInterface {
    
    let dataService: DataServiceInterface
    
    init(
        dataService: DataServiceInterface
    ) {
        self.dataService = dataService
    }
    
}
