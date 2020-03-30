//
//  MainTabBarViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-24.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    public var chatData: ChatsDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        chatData = ChatsDataModel()
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        let tab1 = InboxNavigationViewController()
        tab1.chatData = chatData
        let tab2 = ScannerViewController()
        let tab3 = ProfileNavigationViewController()
        
        self.viewControllers = [tab1, tab2, tab3]
        tab1.tabBarItem = UITabBarItem(title: "inbox".localized, image: UIImage(named: "inbox"), tag: 0)
        tab2.tabBarItem = UITabBarItem(title: "scan".localized, image: UIImage(named: "scan"), tag: 1)
        tab3.tabBarItem = UITabBarItem(title: "profile".localized, image: UIImage(named: "profile"), tag: 2)
        
        tabBar.unselectedItemTintColor = ThemeManager.shared.theme?.tabBarUnselectedItemTintColor
        tabBar.tintColor = ThemeManager.shared.theme?.tabBarTintColor
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font : UIFont.PKFonts.SmallRegular]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
        self.delegate = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let userInterfaceStyle = self.traitCollection.userInterfaceStyle
        switch userInterfaceStyle {
        case .dark:
            ThemeManager.shared.set(theme: DarkTheme())
        default:
            ThemeManager.shared.set(theme: LightTheme())
        }
        setupTabBar()
    }
    
    private func showChat(namespace: CheckNamespaceBusinessModel.Fetch.Response) {
        let messageController = MessageViewController()
        chatData?.startThread(with: namespace)
        messageController.chatData = chatData
        messageController.delegate = self
        present(messageController, animated: true)
    }

}

extension MainTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: ScannerViewController.self) {
            let scannerController = ScannerViewController()
            scannerController.delegate = self
            present(scannerController, animated: true)
            return false
        }
        return true
    }
    
}

extension MainTabBarViewController: ScannerViewControllerDelegate {
    
    func scannerViewController(_ controller: ScannerViewController, didScan code: String) {
        controller.dismiss(animated: true)
        guard let url = URL(string: code), let host = url.host, host == "pokoro.app", let code = url.pathComponents.last else {
            showAlert(message: "invalidBarcode".localized, type: .error)
            return
        }
        NetworkManager().checkNameSpaces(request: CheckNamespaceBusinessModel.Fetch.Request(id: code)) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if error != nil {
                self.showAlert(message: "invalidBarcode".localized, type: .error)
            } else if let result = result {
                let viewModel = CheckNamespaceBusinessModel.Fetch.ViewModel(response: result)
                if viewModel.isValid {
                    self.showChat(namespace: result)
                } else { self.showAlert(message: "barcodeError".localized, type: .error) }
            }
        }
        
    }
    
    func scannerViewControllerBackButtonDidTapped(_ controller: ScannerViewController) {
        controller.dismiss(animated: true)
    }
    
}

extension MainTabBarViewController: MessageViewControllerDelegate {
    
    func messageViewControllerBackButtonDidTapped(_ controller: MessageViewController) {
        controller.dismiss(animated: true)
    }
    
}
