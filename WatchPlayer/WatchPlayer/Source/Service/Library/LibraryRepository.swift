//
//  LibraryRepository.swift
//  WatchPlayer
//
//  Created by Importants on 7/3/24.
//

import Foundation
import Photos

protocol LibraryRepositoryInterface {
    func fetchVideos(
    ) async throws -> ([PHAsset], Bool)
}

final public class LibraryRepository: LibraryRepositoryInterface {
    
    let libraryService: LibraryServiceInterface
    
    init(
        libraryService: LibraryServiceInterface
    ) {
        self.libraryService = libraryService
    }
    
    func fetchVideos(
    ) async throws -> ([PHAsset], Bool) {
        try await libraryService.fetchVideos()
    }
}
