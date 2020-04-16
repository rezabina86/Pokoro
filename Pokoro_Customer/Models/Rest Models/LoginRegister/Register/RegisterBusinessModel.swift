//
//  RegisterBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-31.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

struct RegisterBusinessModel {
    
    struct Fetch {
        
        struct Request: Codable {
            let email: String
            let name: String
            let password: String = "123456"
            let ios_user_identifier: String
        }
        
        struct RequestWithEmail: Codable {
            let email: String
            let name: String
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
