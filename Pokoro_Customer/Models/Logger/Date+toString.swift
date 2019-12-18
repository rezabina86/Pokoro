//
//  Date+toString.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-18.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self)
    }
}
