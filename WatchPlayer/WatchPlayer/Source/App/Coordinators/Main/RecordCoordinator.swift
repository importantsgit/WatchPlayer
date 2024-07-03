//
//  RecordCoordinator.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/2/24.
//

import UIKit
import RxSwift
import RxRelay

protocol RecordRouterManageable: LeafCoordinator {
    var navigationController: UINavigationController? { get }
    var rootViewController: UIViewController? { get }
}

final public class RecordCoordinator: RecordRouterManageable {
    
    weak public private(set) var navigationController: UINavigationController?
    public private(set) var rootViewController: UIViewController?
    private let dependencies: RecordDependencies
    var disposeBag = DisposeBag()
    
    init(
        navigationController: UINavigationController?,
        dependencies: RecordDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func makeRecordRouterActions(
    ) -> RecordRouterActions {
        return .init()
    }
    
    func start() {
        showRecordView()
    }
    
    func showRecordView() {
        let recordViewController = dependencies.makeRecordViewController(
            actions: makeRecordRouterActions()
        )
        rootViewController = recordViewController
    }
    
}



