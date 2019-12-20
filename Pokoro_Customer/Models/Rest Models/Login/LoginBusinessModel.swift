//
//  LoginBusinessModel.swift
//  POKORO
//
//  Created by Reza Bina on 2019-11-25.
//  Copyright © 2019 Reza Bina. All rights reserved.
//

import Foundation

struct LoginBusinessModel {
    
    struct Fetch {
        
        struct Request: Encodable {
            let email: String
            let password: String
        }
        
        struct Response: Decodable {
            let token: String
        }
        
    }
    
}
