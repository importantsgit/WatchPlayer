//
//  VideoListDataSource.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/3/24.
//

import UIKit
import Photos

enum Section: CaseIterable {
    case list
}

final class VideoListDataSource: UICollectionViewDiffableDataSource<Section, PHAsset> {
    
    private var snapshot: NSDiffableDataSourceSnapshot<Section, PHAsset>!
    
    func setupSnapshot() {
        let snapShot = NSDiffableDataSourceSnapshot<Section, PHAsset>()
        self.snapshot = snapShot
        self.snapshot.appendSections([.list])

        apply(self.snapshot, animatingDifferences: false)
    }
    
    func updateSnapshot(with noticeList: [PHAsset]) {
        snapshot.appendItems(noticeList, toSection: .list)
        self.apply(snapshot, animatingDifferences: true)
    }
}

