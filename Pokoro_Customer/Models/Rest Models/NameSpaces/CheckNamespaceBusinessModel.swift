//
//  CheckNamespaceBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-27.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

struct CheckNamespaceBusinessModel {
    
    struct Fetch {
        
        struct Request {
            let id: String
        }
        
        struct Response: Codable {
            let id: String
            let name: String
            let creator: Creator
        }
        
    }
    
    struct Creator: Codable {
        let id: String
        let name: String
    }
    
}
