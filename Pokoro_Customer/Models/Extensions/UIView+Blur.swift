//
//  UIView+Blur.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-20.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
}
