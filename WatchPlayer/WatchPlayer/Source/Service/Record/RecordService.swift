//
//  CameraService.swift
//  WatchPlayer
//
//  Created by Importants on 6/28/24.
//

import Foundation
import AVFoundation

protocol RecordServiceInterface {}

final public class RecordService: RecordServiceInterface {
    
    struct Configuration {
        
    }
    
    let configuration: Configuration
    
    init(
        configuration: Configuration
    ) {
        self.configuration = configuration
    }
    
    func checkPermisison() {
        
    }
}
