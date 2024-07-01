//
//  RecordRepositoryMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/1/24.
//

import Foundation

final class RecordRepositoryMock: RecordRepositoryInterface {
    let recordService: RecordServiceInterface
    
    init(
        recordService: RecordServiceInterface
    ) {
        self.recordService = recordService
    }
}
