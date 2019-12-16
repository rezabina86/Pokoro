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
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        if PKUserManager.shared.isUserLoggedIn {
            router.present(ViewController(), animated: true, onDismissed: nil)
        } else {
            router.present(LoginViewController(), animated: true, onDismissed: nil)
        }
    }
}
