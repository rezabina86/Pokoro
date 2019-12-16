//
//  UIApplication+SwitchRoot.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-16.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static public func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        guard let sceneDelegate = self.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
        guard let window = sceneDelegate.window else { return }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
    
}
