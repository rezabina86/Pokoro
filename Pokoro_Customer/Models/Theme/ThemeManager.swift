//
//  ThemeManager.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-18.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class ThemeManager {
    
    var theme: Theme? = DefaultTheme()
    
    static let shared = {
        return ThemeManager()
    }()
    
//    func set(theme: Theme) {
//        self.theme = theme
//    }
    
}
