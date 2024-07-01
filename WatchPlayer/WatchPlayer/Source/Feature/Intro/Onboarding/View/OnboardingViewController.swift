//
//  OnboardingViewController.swift
//  WatchPlayer
//
//  Created by 이재훈 on 6/26/24.
//

import UIKit

final class OnboardingViewController: DefaultViewController {
    
    let presenter: OnboardingPresenterProtocol
    
    init(
        presenter: OnboardingPresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        let confirmButton = UIButton()
        var confirmButtonTitle = AttributedString("권한을 허용할게요")
        confirmButtonTitle.font = .systemFont(ofSize: 16, weight: .medium)
        confirmButtonTitle.foregroundColor = .white
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        var confirmButtonConfig = UIButton.Configuration.filled()
        confirmButtonConfig.attributedTitle = confirmButtonTitle
        confirmButtonConfig.cornerStyle = .capsule
        confirmButtonConfig.baseBackgroundColor = .primary
        confirmButton.configuration = confirmButtonConfig
        confirmButton.isEnabled = false
        
        let pageVC = OnboardingPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal
        )
        
        pageVC.didMove(toParent: self)
        addChild(pageVC)
        
        [pageVC.view, confirmButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            pageVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            confirmButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
            confirmButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            confirmButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    @objc func confirmButtonTapped(){
        
    }
}



final class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    lazy var pages: [UIViewController] = {
        return [
            OnboardingContentViewController(
                imageName: "image1",
                title: "Welcome",
                description: "Welcome to our app!"
            ),
            OnboardingContentViewController(
                imageName: "image1",
                title: "Welcome",
                description: "Welcome to our app!"
            ),
            OnboardingContentViewController(
                imageName: "image1",
                title: "Welcome",
                description: "Welcome to our app!"
            ),
        ]
    }()
    

    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .lightGray
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            pageControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32)
        ])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard pages.count != nextIndex else {
            return nil
        }
        
        guard pages.count > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewController = viewControllers?.first, let index = pages.firstIndex(of: viewController) {
            pageControl.currentPage = index
        }
    }
}


final class OnboardingContentViewController: UIViewController {
    let imageView: UIImageView
    let titleLabel: UILabel
    let descriptionLabel: UILabel
    
    init(
        imageName: String,
        title: String,
        description: String
    ) {
        self.imageView = UIImageView(image: UIImage(named: imageName))
        self.titleLabel = UILabel()
        self.titleLabel.text = title
        self.descriptionLabel = UILabel()
        self.descriptionLabel.text = description
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    func setupLayout() {
        [titleLabel, descriptionLabel, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        
    }
}
