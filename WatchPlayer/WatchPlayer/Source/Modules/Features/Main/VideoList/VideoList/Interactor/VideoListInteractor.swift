//
//  VideoListInteractor.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import Foundation
import Photos

protocol VideoListInteractorProtocol {
    func fetchVideos(
    ) async throws -> ([PHAsset], Bool)
}

final class VideoListInteractor: VideoListInteractorProtocol {
    
    let libraryRepository: LibraryRepositoryInterface
    
    init(
        libraryRepository: LibraryRepositoryInterface
    ) {
        self.libraryRepository = libraryRepository
    }
    
    func fetchVideos(
    ) async throws -> ([PHAsset], Bool) {
        do {
            let result = try await libraryRepository.fetchVideos()
            return result
        }
        catch {
            // FIXME: 수정
            throw DataLibraryError.notAuthorized
            // Error Handler
        }
        
    }
}
