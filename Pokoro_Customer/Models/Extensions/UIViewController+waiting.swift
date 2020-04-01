//
//  UIViewController+waiting.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-01.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import SwiftOverlays

extension UIViewController {
    
    func showWaiting() {
        self.showWaitOverlay()
    }
    
    func hideWaiting() {
        self.removeAllOverlays()
    }
    
    func showWaitingWithText(_ text: String) {
        self.showWaitOverlayWithText(text)
    }
    
}
