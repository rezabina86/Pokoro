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
        
        struct Request: Codable {
            let ios_user_identifier: String
            let password: String = "123456"
        }
        
        struct RequestWithEmail: Codable {
            let email: String
            let password: String
        }
        
        struct Response: Codable {
            let id: String
            let name: String
            let token: String
            let email: Email
        }
        
    }
    
    struct Email: Codable {
        let address: String
        let is_verified: Bool
    }
    
}
