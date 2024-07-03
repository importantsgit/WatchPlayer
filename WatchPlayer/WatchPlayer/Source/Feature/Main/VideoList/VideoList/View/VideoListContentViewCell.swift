//
//  VideoListContentViewCell.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import UIKit
import Photos

final class VideoListContentViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private var activityIndicator: UIActivityIndicatorView? = UIActivityIndicatorView()
    private var requestID: PHImageRequestID?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        activityIndicator?.startAnimating()
        if let requestID = requestID {
            PHImageManager.default().cancelImageRequest(requestID)
        }
    }
    
    func setupLayout() {
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.style = .medium
        
        imageView.contentMode = .scaleToFill
        
        [activityIndicator!, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            activityIndicator!.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator!.leftAnchor.constraint(equalTo: leftAnchor),
            activityIndicator!.rightAnchor.constraint(equalTo: rightAnchor),
            activityIndicator!.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(
        with asset: PHAsset,
        targetSize: CGSize
    ) {
        activityIndicator?.startAnimating()
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self = self else { return }
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            options.resizeMode = .exact
            options.isSynchronous = false
            
            let image = try await self.requestImage(
                for: asset,
                targetSize: targetSize,
                options: options
            )
            
            await MainActor.run {
                self.imageView.image = image
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
    private func requestImage(
        for asset: PHAsset,
        targetSize: CGSize,
        options: PHImageRequestOptions
    ) async throws -> UIImage? {
        return await withCheckedContinuation { continuation in
            self.requestID = PHImageManager.default().requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: options,
                resultHandler: { image, info in
                    continuation.resume(returning: image)
                }
            )
        }
    }
}

