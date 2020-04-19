//
//  DefaultTheme.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-19.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

struct DefaultTheme: Theme {
    
    var primaryColor: UIColor { return UIColor.PKColors.green }
    
    var secondaryColor: UIColor { return UIColor.PKColors.navy }
    
    var backgroundColor: UIColor {
        UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .black : .white
        }
    }
    
    var sepratorColor: UIColor {
        UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .systemGray4 : UIColor.systemGray2
        }
    }
    
    var textColor: UIColor {
        UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .white : UIColor.PKColors.navy
        }
    }
    
    var tabBarUnselectedItemTintColor: UIColor { return UIColor.PKColors.ashGrey }
    
    var tabBarTintColor: UIColor {
        UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .white : UIColor.PKColors.navy
        }
    }
    
    var navBarBackgroundColor: UIColor { return .white }
    
    var tableViewSeparatorInset: UIEdgeInsets { return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0) }
    
    var tableViewSeparatorColor: UIColor? {
        UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? .systemGray4 : UIColor.systemGray2
        }
    }
    
    var primaryButtonColor: UIColor? {
        UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? UIColor.PKColors.navy : UIColor.PKColors.green
        }
    }
    
    var barcodeLabelColor: UIColor? {
        UIColor { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? UIColor.PKColors.green : UIColor.PKColors.navy
        }
    }
    
}


