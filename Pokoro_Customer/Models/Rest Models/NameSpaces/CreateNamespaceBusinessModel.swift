//
//  CreateNamespaceBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-01.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

struct CreateNamespaceBusinessModel {
    
    struct Fetch {
        
        struct Request: Codable {
            let name: String
        }
        
        struct Response: Codable {
            let id: String
            let name: String
            let creator_id: String
        }
        
    }
    
}
