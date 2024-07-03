//
//  LibraryService.swift
//  WatchPlayer
//
//  Created by Importants on 7/3/24.
//

import Foundation
import Photos

protocol LibraryServiceInterface {
    func fetchVideos(
    ) async throws -> ([PHAsset], Bool)
}

final public class LibraryService: LibraryServiceInterface {
    
    struct Configuration {
        let fetchLimit: Int
    }
    
    private var lastFetchedAsset: PHAsset?
    
    let configuration: Configuration
    
    init(
        configuration: Configuration
    ) {
        self.configuration = configuration
    }
    
    func fetchVideos(
    ) async throws -> ([PHAsset], Bool) {
        // TODO: 에러 메세지
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized
        else { throw DataLibraryError.notAuthorized }
        
        return await withCheckedContinuation { continuation in
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.fetchLimit = configuration.fetchLimit
            
            if let lastAsset = self.lastFetchedAsset {
                fetchOptions.predicate = NSPredicate(format: "creationDate < %@", lastAsset.creationDate! as NSDate)
            }
            
            
            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
            
            var videos: [PHAsset] = []
            fetchResult.enumerateObjects { (asset, _, _) in
                videos.append(asset)
            }
            
            // 5. 마지막으로 가져온 에셋 업데이트
            self.lastFetchedAsset = videos.last
            
            // 6. 더 가져올 비디오가 있는지 확인
            let isLastPage = videos.count < configuration.fetchLimit
            
            return continuation.resume(returning: (videos, isLastPage))
        }
    }
}
