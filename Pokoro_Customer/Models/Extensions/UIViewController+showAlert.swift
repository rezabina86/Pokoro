//
//  UIViewController+showAlert.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-27.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import SwiftMessages

enum NotificationType {
    case error
    case warning
    case success
}

extension UIViewController {
    
    func showAlert(message: String, type: NotificationType) {
        let view = RKAlertView(frame: CGRect.zero)
        view.message = message
        switch type {
        case .error:
            view.title = "Error".localized
            view.typeImage = UIImage(named: "error")
        case .warning:
            view.title = "Warning".localized
            view.typeImage = UIImage(named: "warning")
        case .success:
            view.title = "Success".localized
            view.typeImage = UIImage(named: "success")
        }
        
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        config.presentationContext = .window(windowLevel: .statusBar)
        config.dimMode = .gray(interactive: true)
        config.interactiveHide = true
        config.duration = .seconds(seconds: .infinity)
        config.preferredStatusBarStyle = .default
        DispatchQueue.main.async {
            SwiftMessages.show(config: config, view: view)
        }
    }
    
}
