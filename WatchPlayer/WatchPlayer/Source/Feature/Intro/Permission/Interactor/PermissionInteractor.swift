//
//  PermissionInteractor.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import Foundation

protocol PermissionInteractorProtocol {}

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
}

// UseCase
// 1. 카메라
// 2. 마이크
// 3. 갤러리
