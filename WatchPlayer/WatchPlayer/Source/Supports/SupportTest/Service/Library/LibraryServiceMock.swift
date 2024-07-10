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
    
    var deleteCallCount = 0
    func delete(asset: PHAsset) async throws {
        deleteCallCount += 1
    }
    
    var saveAssetCallCount = 0
    func saveAsset(url: URL) async throws {
        saveAssetCallCount += 1
    }
    
}
