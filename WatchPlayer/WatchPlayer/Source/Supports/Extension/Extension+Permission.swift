//
//  Permission.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/1/24.
//

import Foundation
import AVFoundation
import Photos

extension AVCaptureDevice {
    @discardableResult
    static func hasPermissionToVideo(
    ) async -> Bool {
        return await withCheckedContinuation { continuation in
            self.requestAccess(for: .video) { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}

extension PHPhotoLibrary {
    @discardableResult
    static func hasPermissionToLibrary(
    ) async -> Bool {
        return await withCheckedContinuation { continuation in
            let status = self.authorizationStatus(for: .readWrite)
            if status != .authorized || status != .limited {
                self.requestAuthorization(for: .readWrite) { status in
                    switch status {
                    case .limited, .authorized:
                        return continuation.resume(returning: true)
                    default:
                        return continuation.resume(returning: false)
                    }
                }
            }
            else {
                continuation.resume(returning: true)
            }
        }
    }
}

extension AVAudioSession {
    @discardableResult
    static func hasPermissionToMicrophone(
    ) async -> Bool {
        return await withCheckedContinuation { continuation in
            self.sharedInstance().requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}

@available(iOS 17.0, *)
extension AVAudioApplication {
    @discardableResult
    static func hasPermissionToMicrophone(
    ) async -> Bool {
        return await withCheckedContinuation { continuation in
            self.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}
