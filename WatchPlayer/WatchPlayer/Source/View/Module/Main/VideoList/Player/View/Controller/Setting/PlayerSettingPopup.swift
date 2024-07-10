//
//  PlayerSettingPopup.swift
//  WatchPlayer
//
//  Created by 이재훈 on 7/9/24.
//

import UIKit
import RxSwift
import RxRelay

protocol PlayerSettingPopupProtocol: AnyObject {
    func handleEvent(_ event: PlayerSettingUIUpdateEvent)
    
}

final class PlayerSettingPopup: UIView {
    weak var presenter: PlayerSettingProtocol?
    
    public let categorys = ["화질", "재생 속도", "화면 비율"]
    
    public let settingsData: [String: [String]] = [
        "화질": ["자동", "1080p", "720p", "480p"],
        "재생 속도": ["0.5배", "1.0배", "1.25배", "1.5배", "2.0배"],
        "화면 비율": ["원본 비율", "꽉찬 화면"]
    ]
    
    private var selectedIndexPath: [IndexPath] = [
        IndexPath(row: 0, section: 0),
        IndexPath(row: 1, section: 0),
        IndexPath(row: 0, section: 0)
    ]
    
    private var selectedCategory: String?

    private let tableView = UITableView()
    private let headerView = PlayerSettingHeaderView(style: .popup)
    private let contentsView = UIView()
    private let backgroundView = UIView()
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        setupLayout()
        setupTappedGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit{
        print("PlayerSettingPopup deinit")
    }
}

extension PlayerSettingPopup {
    private func setupTappedGesture() {
        backgroundView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.handleEvent(.closeView)
            })
            
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
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
                self?.updateTableViewHeight()
            }
        })
        .disposed(by: disposeBag)
        
        headerView.setupHeaderViewActions(.init(closeButtonTapped: closeButtonTapped))
    }
    
    private func setupLayout() {
        backgroundView.backgroundColor = UIColor(hex: "000000", alpha: 0.4)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        contentsView.backgroundColor = .white
        contentsView.layer.cornerRadius = 16
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentsView)
        
        [headerView, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentsView.addSubview($0)
        }
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 150)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentsView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            contentsView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            contentsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            
            headerView.topAnchor.constraint(equalTo: contentsView.topAnchor, constant: 16),
            headerView.leftAnchor.constraint(equalTo: contentsView.leftAnchor, constant: 16),
            headerView.rightAnchor.constraint(equalTo: contentsView.rightAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 54),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: contentsView.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: contentsView.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor, constant: -32),
            tableViewHeightConstraint
        ])
    }
    
    private func updateTableViewHeight() {
        Task {
            self.tableViewHeightConstraint.constant = self.tableView.contentSize.height
            self.layoutIfNeeded()
        }
    }
}

extension PlayerSettingPopup: PlayerSettingPopupProtocol {
    func handleEvent(_ event: PlayerSettingUIUpdateEvent) {
        switch event {
        case .reset:
            selectedCategory = nil
            tableView.reloadData()
            updateTableViewHeight()
            
        case .updateSettingData(let selectedIndexPath):
            self.selectedIndexPath = selectedIndexPath
            tableView.reloadData()
            updateTableViewHeight()
        }
    }
}

extension PlayerSettingPopup: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

extension PlayerSettingPopup: UITableViewDataSource {
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
            
            if let index = categorys.firstIndex(where: { $0 == selectedCategory }),
               indexPath == selectedIndexPath[index] {
                cell.setTapped(isChecked: true)
            }
            else {
                cell.setTapped(isChecked: false)
            }
            
            if let data = settingsData[selectedCategory] {
                cell.set(.popup)
                cell.configuration(title: data[indexPath.row])
                
                return cell
            }
        }
        
        // 1_depth
        else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "PlayerSettingSectionCell",
                for: indexPath
            ) as? PlayerSettingSectionCell
            else { return .init() }
            
            let selectedIndexPath = selectedIndexPath[indexPath.row]
            let title = categorys[indexPath.row]
            
            cell.set(.popup)
            cell.configuration(
                title: title,
                detail: settingsData[title]![selectedIndexPath.row]
            )
            
            return cell
        }
        
        return .init()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedCategory == nil {
            self.selectedCategory = categorys[indexPath.row]
            headerView.updateTitle(self.selectedCategory ?? "")
            tableView.reloadData()
            updateTableViewHeight()
        }
        else if let selectedCategory = selectedCategory,
                let cell = tableView.cellForRow(at: indexPath) as? PlayerSettingDetailCell {
            if let index = categorys.firstIndex(where: { $0 == selectedCategory }) {
                let selectedIndexPath = selectedIndexPath[index]
                
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
                updateTableViewHeight()
            }
        }
    }
}


