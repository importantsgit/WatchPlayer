//
//  PlayerSettingView.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/8/24.
//

import UIKit
import RxSwift
import RxRelay

enum SettingEvent {
    case closeView
    case updateSpeed(indexPath: IndexPath)
    case updateGravity(indexPath: IndexPath)
    case updateQuality(indexPath: IndexPath)
}

enum PlayerSettingUIUpdateEvent {
    case reset
    case updateSettingData(selectedIndexPaths: [IndexPath])
}

protocol PlayerSettingViewProtocol: AnyObject {
    func handleEvent(_ event: PlayerSettingUIUpdateEvent)
    
}

final class PlayerSettingView: UIView {
    weak var presenter: PlayerSettingProtocol?
    
    public let categorys = ["화질", "재생 속도", "화면 비율"]
    
    public let settingsData: [String: [String]] = [
        "화질": ["자동", "1080p", "720p", "480p"],
        "재생 속도": ["0.5배", "1.0배", "1.25배", "1.5배", "2.0배"],
        "화면 비율": ["원본 비율", "꽉찬 화면"]
    ]
    
    var selectedIndexPaths: [IndexPath] = [
        IndexPath(row: 0, section: 0),
        IndexPath(row: 1, section: 0),
        IndexPath(row: 0, section: 0)
    ]
    
    var selectedCategory: String?

    let tableView = UITableView()
    let headerView = PlayerSettingHeaderView(style: .view)
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("PlayerSettingView deinit")
    }

}

extension PlayerSettingView {
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 52
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PlayerSettingSectionCell.self, forCellReuseIdentifier: "PlayerSettingSectionCell")
        tableView.register(PlayerSettingDetailCell.self, forCellReuseIdentifier: "PlayerSettingDetailCell")
        
        let closeButtonTapped = PublishRelay<Void>()
        closeButtonTapped.subscribe(onNext: { [weak self] in
            if self?.selectedCategory == nil {
                self?.presenter?.handleEvent(.closeView)
            }
            else {
                self?.selectedCategory = nil
                self?.headerView.updateTitle("설정")
                self?.tableView.reloadData()
            }
        })
        .disposed(by: disposeBag)
        
        headerView.setupHeaderViewActions(.init(closeButtonTapped: closeButtonTapped))
    }
    
    func setupLayout() {
        backgroundColor = UIColor(hex: "000000", alpha: 0.8)
        
        [headerView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            headerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 18),
            headerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -50),
            headerView.heightAnchor.constraint(equalToConstant: 72),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor, constant: 18),
            tableView.rightAnchor.constraint(equalTo: rightAnchor, constant: -50),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension PlayerSettingView: PlayerSettingViewProtocol {
    func handleEvent(_ event: PlayerSettingUIUpdateEvent) {
        switch event {
        case .reset:
            selectedCategory = nil
            tableView.reloadData()
            
        case .updateSettingData(let selectedIndexPaths):
            self.selectedIndexPaths = selectedIndexPaths
            tableView.reloadData()
        }
    }
}

extension PlayerSettingView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PlayerSettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let category = selectedCategory {
            let data = settingsData[category]
            guard let data = data else { fatalError() }
            return data.count
        } else {
            return settingsData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2_depth
        if let selectedCategory = selectedCategory {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "PlayerSettingDetailCell",
                for: indexPath
            ) as? PlayerSettingDetailCell
            else { return .init() }
            
            guard let data = settingsData[selectedCategory]
            else { fatalError() }
            
            cell.configuration(title: data[indexPath.row])
            cell.set(.view)
            
            if let index = categorys.firstIndex(where: { $0 == selectedCategory }),
               indexPath == selectedIndexPaths[index] {
                cell.setTapped(isChecked: true)
            }
            else {
                cell.setTapped(isChecked: false)
            }
        
            return cell
        }
        
        // 1_depth
        else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "PlayerSettingSectionCell",
                for: indexPath
            ) as? PlayerSettingSectionCell
            else { return .init() }
            
            let selectedIndexPath = selectedIndexPaths[indexPath.row]
            let title = categorys[indexPath.row]
            
            cell.set(.view)
            cell.configuration(
                title: title,
                detail: settingsData[title]![selectedIndexPath.row]
            )
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedCategory == nil {
            self.selectedCategory = categorys[indexPath.row]
            headerView.updateTitle(self.selectedCategory ?? "")
            tableView.reloadData()
        }
        else if let selectedCategory = selectedCategory,
                let cell = tableView.cellForRow(at: indexPath) as? PlayerSettingDetailCell {
            if let index = categorys.firstIndex(where: { $0 == selectedCategory }) {
                let selectedIndexPath = selectedIndexPaths[index]
                
                if let previousSelectedCell = tableView.cellForRow(at: selectedIndexPath) as? PlayerSettingDetailCell {
                    previousSelectedCell.setTapped(isChecked: false)
                }
                
                cell.setTapped(isChecked: true)
                
                switch index {
                case 0:
                    presenter?.handleEvent(.updateQuality(indexPath: indexPath))
                    
                case 1:
                    presenter?.handleEvent(.updateSpeed(indexPath: indexPath))
                    
                case 2:
                    presenter?.handleEvent(.updateGravity(indexPath: indexPath))
                    
                default: fatalError()
                }
                
                self.selectedCategory = nil
                tableView.reloadData()
            }
        }
    }
}

