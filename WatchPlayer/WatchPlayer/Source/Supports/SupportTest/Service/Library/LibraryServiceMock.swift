//
//  LibraryServiceMock.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import Foundation
import Photos

final class LibraryServiceMock: LibraryServiceInterface {
    var fetchVideosCallCount = 0
    func fetchVideos(
    ) async throws -> ([PHAsset], Bool) {
        fetchVideosCallCount += 1
        return await withCheckedContinuation { continuation in
            let result = [PHAsset]()
            continuation.resume(returning: (result, true))
        }
    }
    
    
}
