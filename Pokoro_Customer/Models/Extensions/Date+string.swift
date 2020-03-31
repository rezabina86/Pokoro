//
//  Date+string.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-31.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

extension Date {
    
    var stringFormat: String? {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .long
        formatter1.timeStyle = .short
        return formatter1.string(from: self)
    }
    
}
