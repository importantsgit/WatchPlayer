//
//  PermissionInteractorMock.swift
//  WatchPlayer
//
//  Created by Importants on 6/28/24.
//

import Foundation

final class PermissionInteractorMock: PermissionInteractorProtocol {

    let dataRepository: DataRepositoryMock
    
    init(
        dataRepository: DataRepositoryMock
    ) {
        self.dataRepository = dataRepository
    }
    
    var showPermissionPopupCallCount = 0
    func showPermissionPopup() async {
        showPermissionPopupCallCount += 1
        dataRepository.dismissPermissionViewForever()
    }
}
