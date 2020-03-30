//
//  InboxNavigationViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-03.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class InboxNavigationViewController: UINavigationController {
    
    public var chatData: ChatsDataModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let inboxController = InboxViewController()
        inboxController.chatData = chatData
        viewControllers = [inboxController]
        interactivePopGestureRecognizer?.delegate = nil
        isNavigationBarHidden = true
    }

}
