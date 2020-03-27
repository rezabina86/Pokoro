//
//  PKButton.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-27.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class PKButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = ThemeManager.shared.theme?.primaryButtonColor
        titleLabel?.font = UIFont.PKFonts.LargeSB
    }

}
