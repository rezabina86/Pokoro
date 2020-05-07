//
//  PasswordGenerator.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-23.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class PasswordGenerator: NSObject {
    
    static func generate(with length: Int) -> String {
        let pswdChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@#$&!?"
        return String((0..<length).compactMap{ _ in pswdChars.randomElement() })
    }
    
}
