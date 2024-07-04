//
//  VideoListViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit
import Photos
import RxSwift

final class VideoListViewController: DefaultViewController {
    
    let navigationBar: NavigationBarProtocol = NavigationBarView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        view.backgroundColor = .systemBackground
        
        
        view.register(
            VideoListContentViewCell.self,
            forCellWithReuseIdentifier: "VideoListContentViewCell"
        )
        view.delegate = self
        
        return view
    }()
    
    private var finishedFirstfetch = false
    
    private var dataSource: VideoListDataSource!
    
    private let presenter: VideoListPresenterProtocol
    
    init(
        presenter: VideoListPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        self.dataSource = VideoListDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, asset in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoListContentViewCell", for: indexPath) as? VideoListContentViewCell
            else { return UICollectionViewCell() }
            
            cell.setupLayout()
            let width = self?.view.frame.width ?? 300
            cell.configure(with: asset, targetSize: CGSize(width: width/3, height: width/3))
            
            return cell
        }
        self.dataSource.setupSnapshot()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(with: presenter)
        presenter.viewDidLoad()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        let navigationBar = navigationBar as! UIView
        
        [collectionView, navigationBar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 56),
            
            collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
        
        collectionView.isScrollEnabled = false
    }
    
    override func setupNavigationBar() {
        navigationBar.setTitle("동영상 리스트")
    }
}

extension VideoListViewController {
    func bind(with presenter: VideoListPresenterProtocol) {
        presenter.fetchVideoList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] assets in
                if self?.finishedFirstfetch == false {
                    self?.collectionView.isScrollEnabled = true
                }
                self?.finishedFirstfetch = true
                self?.dataSource.updateSnapshot(with: assets)
            })
            .disposed(by: disposeBag)
    }
}

extension VideoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = view.frame.size.width/3 - 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectedVideo(indexPath.row)
    }
}

extension VideoListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard finishedFirstfetch == true
        else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY >= contentHeight - height {
            presenter.fetchVideos()
        }
    }
}
