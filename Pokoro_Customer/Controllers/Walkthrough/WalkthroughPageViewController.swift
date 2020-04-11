//
//  WalkthroughPageViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-10.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIViewController {
    
    private var pageView: UIView = {
        let view = UIView()
        view.layer.zPosition = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var pageViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return controller
    }()
    
    private var pageController: UIPageControl = {
        let view = UIPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfPages = 4
        view.currentPageIndicatorTintColor = UIColor.PKColors.green
        view.pageIndicatorTintColor = UIColor.PKColors.navy
        view.layer.zPosition = 10
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private var skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor.PKColors.navy, for: .normal)
        button.layer.zPosition = 10
        return button
    }()
    
    private var stepControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSteps()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(self.pageView)
        pageView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 0).isActive = true
        pageView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0).isActive = true
        pageView.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor, constant: 0).isActive = true
        pageView.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: 0).isActive = true
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChild(pageViewController)
        pageView.addSubview(pageViewController.view)
        pageViewController.view.frame = pageView.bounds
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.didMove(toParent: self)
        pageViewController.setViewControllers([stepControllers.first!], direction: .forward, animated: true)
        
        view.addSubview(pageController)
        pageController.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -24).isActive = true
        pageController.centerXAnchor.constraint(equalTo: view.safeCenterXAnchor, constant: 0).isActive = true
        
        skipButton.addTarget(self, action: #selector(skipButtonDidTapped(_:)), for: .touchUpInside)
        view.addSubview(skipButton)
        skipButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 12).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -28).isActive = true
    }
    
    private func setupSteps() {
        let step1 = WalkthroughViewController()
        step1.stepImage = UIImage(named: "welcome")
        step1.messageTitle = "WelcomePokoro".localized
        step1.messageBody = "welcomeBody".localized
        
        let step2 = WalkthroughViewController()
        step2.stepImage = UIImage(named: "businessCard")
        step2.messageTitle = "businessCardTitle".localized
        step2.messageBody = "businessCardBody".localized
        
        let step3 = WalkthroughViewController()
        step3.stepImage = UIImage(named: "scanQR")
        step3.messageTitle = "scanQRTitle".localized
        step3.messageBody = "scanQRBody".localized
        
        let step4 = WalkthroughViewController()
        step4.stepImage = UIImage(named: "chatList")
        step4.messageTitle = "chatListTitle".localized
        step4.messageBody = "chatListBody".localized
        
        stepControllers = [step1, step2, step3, step4]
    }
    
    @objc private func skipButtonDidTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

}

extension WalkthroughPageViewController: UIPageViewControllerDataSource {
    
    //BACK
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentrIndex = stepControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentrIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard stepControllers.count > previousIndex else { return nil }
        return stepControllers[previousIndex]
    }
    
    //NEXT
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentrIndex = self.stepControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentrIndex + 1
        guard nextIndex < stepControllers.count else { return nil }
        guard stepControllers.count > nextIndex else { return nil }
        return stepControllers[nextIndex]
    }
    
}

extension WalkthroughPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextViewController = pendingViewControllers.first else { return }
        guard let currentrIndex = self.stepControllers.firstIndex(of: nextViewController) else { return }
        pageController.currentPage = currentrIndex
    }
    
}
