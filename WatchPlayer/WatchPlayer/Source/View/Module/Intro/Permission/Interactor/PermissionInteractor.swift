//
//  PermissionInteractor.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import Foundation
import AVFoundation
import Photos

protocol PermissionInteractorProtocol {
    func showPermissionPopup() async
    
}

final class PermissionInteractor: PermissionInteractorProtocol {
    
    let dataRepository: DataRepositoryInterface
    let recordRepository: RecordRepositoryInterface
    
    init(
        dataRepository: DataRepositoryInterface,
        recordRepository: RecordRepositoryInterface
    ) {
        self.dataRepository = dataRepository
        self.recordRepository = recordRepository
    }
    
    func showPermissionPopup() async {
        await AVCaptureDevice.hasPermissionToVideo()
        await PHPhotoLibrary.hasPermissionToLibrary()
        
        if #available(iOS 17.0, *) {
            await AVAudioApplication.hasPermissionToMicrophone()
        }
        else {
            await AVAudioSession.hasPermissionToMicrophone()
        }
        
        dataRepository.dismissPermissionViewForever()
    }
}

// UseCase
// 1. 카메라
// 2. 마이크
// 3. 갤러리
