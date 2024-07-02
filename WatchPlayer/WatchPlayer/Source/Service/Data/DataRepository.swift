//
//  DataRepository.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import Foundation

protocol DataRepositoryInterface {
    func dismissPermissionViewForever()
    func dismissOnboardingViewForever()
}

final public class DataRepository: DataRepositoryInterface {
    
    private let dataService: DataServiceInterface
    
    init(
        dataService: DataServiceInterface
    ) {
        self.dataService = dataService
    }
    
    func dismissPermissionViewForever(){
        dataService.dismissPermissionViewForever()
    }
    
    func dismissOnboardingViewForever() {
        dataService.dismissOnboardingViewForever()
    }
}
