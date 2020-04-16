//
//  PasswordBusinessModel.swift
//  Ronaker-Customer
//
//  Created by Reza Bina on 3/30/19.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class PasswordBusinessModel: NSObject {
    
    var password : String
    
    init(password : String) {
        self.password = password
    }
    
    func isValid() -> Bool {
        guard password.count > 5 else { return false }
        return true
    }
    
}
