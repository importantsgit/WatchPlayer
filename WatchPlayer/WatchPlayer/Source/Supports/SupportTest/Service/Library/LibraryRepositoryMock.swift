//
//  LibraryRepositoryMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import Foundation
import Photos

final class LibraryRepositoryMock: LibraryRepositoryInterface {

    let libraryService: LibraryServiceMock
    
    init(
        libraryService: LibraryServiceMock
    ) {
        self.libraryService = libraryService
    }
    
    var fetchVideosCallCount = 0
    func fetchVideos(
    ) async throws -> ([PHAsset], Bool) {
        fetchVideosCallCount += 1
        return try await libraryService.fetchVideos()
    }
}
