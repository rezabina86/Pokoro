//
//  LargeLight.swift
//  Ronaker-Customer
//
//  Created by Reza Bina on 3/29/19.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class LargeLight: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    func initializeLabel() {
        self.textColor = ThemeManager.shared.theme?.textColor
        self.font = UIFont.PKFonts.LargeLight
        self.numberOfLines = 0
    }

}
