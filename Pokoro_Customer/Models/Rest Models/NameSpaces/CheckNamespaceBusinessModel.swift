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
        
        struct ViewModel {
            
            let id: String
            let name: String
            let creator: Creator
            
            init(response: Response) {
                self.id = response.id
                self.name = response.name
                self.creator = response.creator
            }
            
            var isValid: Bool {
                guard let userId = PKUserManager.shared.userId else { return false }
                guard userId != creator.id else { return false }
                return true
            }
            
        }
        
    }
    
    struct Creator: Codable {
        let id: String
        let name: String?
    }
    
}
