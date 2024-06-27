//
//  CameraRepository.swift
//  WatchPlayer
//
//  Created by Importants on 6/28/24.
//

import Foundation

protocol RecordRepositoryInterface {}

final public class RecordRepository: RecordRepositoryInterface {
    
    let recordService: RecordServiceInterface
    
    init(
        recordService: RecordServiceInterface
    ) {
        self.recordService = recordService
    }
}
