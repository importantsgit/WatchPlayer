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
    
    func delete(
        asset: PHAsset
    ) async throws
    
    func saveAsset(
        url: URL
    ) async throws
    
    func fetchAVPlayerItem(
        _ asset: PHAsset
    ) async throws -> AVPlayerItem
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
    
    func delete(
        asset: PHAsset
    ) async throws {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized
        else { throw DataLibraryError.notAuthorized }
            
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)
        }
    }
    
    func saveAsset(
        url: URL
    ) async throws {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized
        else { throw DataLibraryError.notAuthorized }
        
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }
    }
    
    func fetchAVPlayerItem(
        _ asset: PHAsset
    ) async throws -> AVPlayerItem {
        return try await withCheckedThrowingContinuation { continuation in
            let options = PHVideoRequestOptions()
            options.version = .current
            options.deliveryMode = .automatic
            
            // MARK: - 클라우드에서 받는 경우도 있기에 true로 해야 item != nil
            options.isNetworkAccessAllowed = true
            
            PHImageManager.default().requestPlayerItem(
                forVideo: asset,
                options: options
            ) { item, info in
                if let error = info?["PHImageErrorKey"] as? Error {
                    continuation.resume(throwing: error)
                }
                guard let item = item
                        // FIXME: 에러 처리
                else {
                    continuation.resume(throwing: AssetError.invaild)
                    return
                }
                continuation.resume(returning: item)
            }
        }
    }
    
}
