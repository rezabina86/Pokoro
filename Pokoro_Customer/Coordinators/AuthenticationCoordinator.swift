//
//  AuthenticationCoordinator.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-16.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class AuthenticationCoordinator: Coordinator {
    
    var children: [Coordinator] = []
    var router: Routers
    
    init(router: Routers) {
        self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        if PKUserManager.shared.isUserLoggedIn {
            router.present(MainTabBarViewController(), animated: true, onDismissed: nil)
        } else {
            router.present(LoginViewController(), animated: true, onDismissed: nil)
        }
    }
    
}
