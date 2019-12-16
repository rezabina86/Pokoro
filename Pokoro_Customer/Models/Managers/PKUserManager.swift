//
//  PKUserManager.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2019-12-16.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class PKUserManager: NSObject {
    
    static let shared = PKUserManager()
    
    public var token: String? {
        set { UserDefaults.standard.set(newValue, forKey: "token") }
        get { return UserDefaults.standard.value(forKey: "token") as? String }
    }
    
    public var isUserLoggedIn: Bool {
        get { return token != nil }
    }
    
}
