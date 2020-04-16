//
//  UserNameBusinessModel.swift
//  Ronaker
//
//  Created by Reza Bina on 2/13/19.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import UIKit

class NameBusinessModel: NSObject {
    
    var name : String
    
    init(name : String) {
        self.name = name
    }
    
    func isValid() -> Bool {
        guard name.count > 1 else { return false }
        return true
    }
    
}
