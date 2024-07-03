//
//  VideoListInteractorMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation
import Photos

final class VideoListInteractorMock: VideoListInteractorProtocol {

    let libraryRepository: LibraryRepositoryMock
    
    init(
        libraryRepository: LibraryRepositoryMock
    ) {
        self.libraryRepository = libraryRepository
    }
    
    var fetchVideosCallCount = 0
    func fetchVideos(
    ) async throws -> ([PHAsset], Bool) {
        fetchVideosCallCount += 1
        do {
            return try await libraryRepository.fetchVideos()
        }
        catch {
            throw DataLibraryError.notAuthorized
        }
        
    }
    
    
}
