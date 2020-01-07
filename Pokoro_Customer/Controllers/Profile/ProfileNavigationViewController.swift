//
//  ProfileNavigationViewController.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-07.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class ProfileNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
        viewControllers = [ProfileViewController()]
        isNavigationBarHidden = true
    }

}
