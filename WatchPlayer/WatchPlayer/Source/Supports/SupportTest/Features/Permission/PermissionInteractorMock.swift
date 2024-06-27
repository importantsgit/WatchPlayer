//
//  PermissionInteractorMock.swift
//  WatchPlayer
//
//  Created by Importants on 6/28/24.
//

import Foundation

final class PermissionInteractorMock: PermissionInteractorProtocol {
    
    let dataRepository: DataRepositoryInterface
    
    init(
        dataRepository: DataRepositoryInterface
    ) {
        self.dataRepository = dataRepository
    }
}
