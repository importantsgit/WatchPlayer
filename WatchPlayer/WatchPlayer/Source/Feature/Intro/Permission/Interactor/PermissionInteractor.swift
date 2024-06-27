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
    
    init(
        dataRepository: DataRepositoryInterface
    ) {
        self.dataRepository = dataRepository
    }
}

// UseCase
// 1. 카메라
// 2. 마이크
// 3. 갤러리
