//
//  DataRepositoryMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

final public class DataRepositoryMock: DataRepositoryInterface {
    
    let dataService: DataServiceInterface
    
    init(
        dataService: DataServiceInterface
    ) {
        self.dataService = dataService
    }
    
}
