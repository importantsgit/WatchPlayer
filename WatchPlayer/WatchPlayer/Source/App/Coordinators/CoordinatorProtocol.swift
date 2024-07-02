//
//  CoordinatorProtocol.swift
//  WatchPlayer
//
//  Created by Importants on 6/27/24.
//

import UIKit
import RxRelay

protocol BaseCoordinator: AnyObject {
    func start()
}

protocol NodeCoordinator: BaseCoordinator {
    var childCoordinators: [BaseCoordinator] { get set }
}

protocol LeafCoordinator: BaseCoordinator {}

protocol CoordinatorActionsProtocol {
    var finishFlow: PublishRelay<Void> { get }
}
