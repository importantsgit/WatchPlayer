//
//  LibraryRepository.swift
//  WatchPlayer
//
//  Created by Importants on 7/3/24.
//

import Foundation

protocol LibraryRepositoryInterface {}

final public class LibraryRepository: LibraryRepositoryInterface {
    
    let recordService: RecordServiceInterface
    
    init(
        recordService: RecordServiceInterface
    ) {
        self.recordService = recordService
    }
}
