//
//  MainTabBarViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-24.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit
import Combine
import AVFoundation

class MainTabBarViewController: UITabBarController {
    
    public var chatManager: PkChatManager<ChatThread<ChatMessage>, ChatMessage>?
    private var cancellables = Set<AnyCancellable>()
    private var pageLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        chatManager = PkChatManager()
        setupTabBar()
        setupListener()
        
        
            
    }
    
    private func setupListener() {
        chatManager?.$unseenThreads.sink(receiveValue: { [weak self] (unseen) in
            guard let `self` = self else { return }
            guard let items = self.tabBar.items else { return }
            items[0].badgeValue = unseen == 0 ? nil : "\(unseen)"
            items[0].badgeColor = .systemRed
            UIApplication.shared.applicationIconBadgeNumber = unseen
        }).store(in: &cancellables)
//
//        chatData?.$newMessageRecieved.sink(receiveValue: { [weak self] (_) in
//            guard let `self` = self else { return }
//            if self.pageLoaded { AudioServicesPlayAlertSound(SystemSoundID(1312)) }
//            self.pageLoaded = true
//        }).store(in: &cancellables)
//
        PKUserManager.shared.$pushNotificationChatId.sink { [weak self] (id) in
            guard let `self` = self, let id = id else { return }
            self.handlePushNotification(id: id)
        }.store(in: &cancellables)
    }
    
    private func setupTabBar() {
        
        let tab1 = InboxNavigationViewController()
        tab1.chatManager = chatManager
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
    
    private func handlePushNotification(id: String) {
        NetworkManager().getChats { [weak self] (threads, error) in
            guard let `self` = self else { return }
            if let threads = threads {
                guard let selectedThread = threads.results.first(where: { $0.id == id }) else { return }
                let thread = ChatThread<ChatMessage>(apiResponse: selectedThread)
                self.showPushThread(thread: thread)
            }
        }
    }
    
    private func showPushThread(thread: ChatThread<ChatMessage>) {
        chatManager?.selectThread(thread)
        let messageController = MessageViewController()
        messageController.delegate = self
        messageController.chatManager = chatManager
        messageController.hidesBottomBarWhenPushed = true
        if let selectedNavigationController = selectedViewController as? InboxNavigationViewController {
            selectedNavigationController.popToRootViewController(animated: true)
            selectedNavigationController.pushViewController(messageController, animated: true)
        } else if let selectedNavigationController = selectedViewController as? ProfileNavigationViewController {
            selectedNavigationController.popToRootViewController(animated: true)
            selectedNavigationController.pushViewController(messageController, animated: true)
        }
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        let userInterfaceStyle = self.traitCollection.userInterfaceStyle
//        Logger.log(message: PKUserManager.shared.theme, event: .warning)
//        Logger.log(message: userInterfaceStyle.rawValue, event: .warning)
//        if PKUserManager.shared.isThemeChanged(newTheme: (userInterfaceStyle == .dark) ? .dark : .light) {
//            Logger.log(message: "Changed", event: .info)
//            switch userInterfaceStyle {
//            case .dark:
//                ThemeManager.shared.set(theme: DarkTheme())
//            default:
//                ThemeManager.shared.set(theme: LightTheme())
//            }
//            setupTabBar()
//        }
//    }
    
    private func showChat(namespace: CheckNamespaceBusinessModel.Fetch.Response) {
        chatManager?.startThread(with: namespace)
        let messageController = MessageViewController()
        messageController.chatManager = chatManager
        messageController.delegate = self
        messageController.hidesBottomBarWhenPushed = true
        if let selectedNavigationController = selectedViewController as? InboxNavigationViewController {
            selectedNavigationController.popToRootViewController(animated: true)
            selectedNavigationController.pushViewController(messageController, animated: true)
        } else if let selectedNavigationController = selectedViewController as? ProfileNavigationViewController {
            selectedNavigationController.popToRootViewController(animated: true)
            selectedNavigationController.pushViewController(messageController, animated: true)
        }
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
        chatManager?.selectThread(nil)
        controller.navigationController?.popViewController(animated: true)
    }
    
}
