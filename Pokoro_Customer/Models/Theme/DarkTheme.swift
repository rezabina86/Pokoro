//
//  DarkTheme.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-24.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class DarkTheme: Theme {
    var primaryColor: UIColor { return UIColor.PKColors.green }
    var secondaryColor: UIColor { return UIColor.PKColors.navy }
    var backgroundColor: UIColor { return .black }
    var sepratorColor: UIColor { return UIColor.systemGray }
    var textColor: UIColor { return UIColor.white }
    var tabBarUnselectedItemTintColor: UIColor { return UIColor.PKColors.ashGrey }
    var tabBarTintColor: UIColor { return UIColor.white }
    var navBarBackgroundColor: UIColor { return UIColor.black }
    var tableViewSeparatorInset: UIEdgeInsets { return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0) }
    var tableViewSeparatorColor: UIColor? { return UIColor.systemGray3 }
}
