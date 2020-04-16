//
//  EmailBusinessModel.swift
//  Ronaker-Customer
//
//  Created by Reza Bina on 3/30/19.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

class EmailBusinessModel: NSObject {
    
    var mail : String
    
    private let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
    
    init(mail : String) {
        self.mail = mail
    }
    
    func isValid() -> Bool {
        if !mail.isValid(regex: emailRegex) { return false }
        return true
    }
    
}

