//
//  SceneDelegateRouter.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-16.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class SceneDelegateRouter: Routers {
    public let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        UIApplication.switchRootViewController(rootViewController: viewController, animated: true, completion: nil)
        window.makeKeyAndVisible()
    }
    
    func dismiss(animated: Bool) {
        // Don't do anything
    }
}

