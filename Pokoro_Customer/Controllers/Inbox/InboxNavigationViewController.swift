//
//  InboxNavigationViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-03.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class InboxNavigationViewController: UINavigationController {
    
    public var chatManager: PkChatManager<ChatThread<ChatMessage>, ChatMessage>?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let inboxController = InboxViewController()
        inboxController.chatManager = chatManager
        viewControllers = [inboxController]
        interactivePopGestureRecognizer?.delegate = nil
        isNavigationBarHidden = true
        delegate = self
    }

}

extension InboxNavigationViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: InboxViewController.self) {
            chatManager?.selectThread(nil)
        }
    }
    
}
