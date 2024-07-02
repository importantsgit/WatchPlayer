//
//  OnboardingViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        return [
            OnboardingContentViewController(
                imageName: "image1",
                title: "Record Your Dream",
                description: "앱에서 동영상을 찍을 수 있어요.\n앱을 통해 자신만의 동영상을 찍어보세요!"
            ),
            OnboardingContentViewController(
                imageName: "image2",
                title: "Get Your Video",
                description: "갤러리내 동영상을 가져올 수 있어요.\n엄청 많은 동영상도 거뜬히 가져올 수 있죠."
            ),
            OnboardingContentViewController(
                imageName: "image3",
                title: "Custom Watch Player",
                description: "네이티브 플레이어로 영상을 볼 수 있어요\n원한다면 기능이 더 추가될 수도 있죠"
            ),
        ]
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.isUserInteractionEnabled = false
        control.currentPageIndicatorTintColor = .white
        control.pageIndicatorTintColor = .cDarkGray
        return control
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        var confirmButtonTitle = AttributedString("WatchPlayer 앱 사용하기")
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        var confirmButtonConfig = UIButton.Configuration.filled()
        confirmButtonConfig.attributedTitle = confirmButtonTitle
        confirmButtonConfig.cornerStyle = .capsule
        
        button.configuration = confirmButtonConfig
        button.isEnabled = false
        
        button.configurationUpdateHandler = { btn in

            switch btn.state {
            case .disabled:
                btn.configuration?.background.backgroundColor = .disabled
                var string = btn.configuration?.attributedTitle
                string?.font = .systemFont(ofSize: 16, weight: .regular)
                string?.foregroundColor = UIColor.lightGray
                btn.configuration?.attributedTitle = string
                
            default:
                
                btn.layer.shadowColor = UIColor.black.cgColor
                btn.layer.shadowOpacity = 0.2
                btn.layer.shadowRadius = 10
                
                var string = btn.configuration?.attributedTitle
                string?.font = .systemFont(ofSize: 16, weight: .bold)
                string?.foregroundColor = UIColor.darkPrimary
                btn.configuration?.attributedTitle = string
                UIView.animate(withDuration: 10) {
                    btn.configuration?.background.backgroundColor = .white
                }


            }
        }

        return button
    }()
    
    private let presenter: OnboardingPresenterProtocol
    
    init(
        presenter: OnboardingPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        setupLayout()
    }
    
    func setupLayout() {
        view.backgroundColor = .primary600
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        [pageControl, confirmButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pageControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            confirmButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            confirmButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            confirmButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    @objc func confirmButtonTapped(){
        presenter.confirmButtonTapped()
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController)
        else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0
        else { return nil }
        
        guard pages.count > previousIndex
        else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController)
        else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard pages.count != nextIndex
        else { return nil }
        
        guard pages.count > nextIndex
        else { return nil }
        
        return pages[nextIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let viewController = viewControllers?.first,
           let index = pages.firstIndex(of: viewController) {
            pageControl.currentPage = index
            if index == pages.count - 1 {
                confirmButton.isEnabled = true
            }
        }
    }
}
