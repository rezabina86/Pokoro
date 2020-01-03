//
//  InboxNavigationViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-03.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class InboxNavigationViewController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [InboxViewController()]
        interactivePopGestureRecognizer?.delegate = nil
        isNavigationBarHidden = true
    }

}
