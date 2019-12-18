//
//  Theme.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-18.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

public protocol Theme: Codable {
    var primaryColor : UIColor { get }
    var secondaryColor : UIColor { get }
    var backgroundColor : UIColor { get }
    var sepratorColor : UIColor { get }
    var textColor: UIColor { get }
}