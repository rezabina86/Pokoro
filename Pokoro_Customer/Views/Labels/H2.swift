//
//  H2.swift
//  Ronaker-Customer
//
//  Created by Reza Bina on 3/28/19.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class H2: UILabel {

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
        self.font = UIFont.PKFonts.H2Font
        self.numberOfLines = 0
    }

}
