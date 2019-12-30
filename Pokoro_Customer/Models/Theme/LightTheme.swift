//
//  LightTheme.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-18.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

struct LightTheme: Theme {
    var primaryColor: UIColor { return UIColor.PKColors.green }
    var secondaryColor: UIColor { return UIColor.PKColors.navy }
    var backgroundColor: UIColor { return .white }
    var sepratorColor: UIColor { return UIColor.systemGray }
    var textColor: UIColor { return UIColor.PKColors.navy }
    var tabBarUnselectedItemTintColor: UIColor { return UIColor.PKColors.ashGrey }
    var tabBarTintColor: UIColor { return UIColor.PKColors.navy }
    var navBarBackgroundColor: UIColor { return UIColor.PKColors.navy }
    var tableViewSeparatorInset: UIEdgeInsets { return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0) }
    var tableViewSeparatorColor: UIColor? { return nil }
}
