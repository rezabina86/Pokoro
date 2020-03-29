//
//  ThreadBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-28.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

struct ThreadBusinessModel {
    
    struct Fetch {
        
        struct Request {
            let id: String
            let last_message: String?
            let direction: Direction?
            
            init(id: String, last_message: String? = nil, direction: Direction? = nil) {
                self.id = id
                self.last_message = last_message
                self.direction = direction
            }
            
            var parameters: Parameters? {
                var params: Parameters = [:]
                if let last_message = last_message { params["last_message"] = last_message }
                if let direction = direction { params["direction"] = direction.rawValue }
                return params.count == 0 ? nil : params
            }
        }
        
        struct Response: Codable {
            let id: String
            let other_user: OtherUser
            let namespace: Namespace
            let messages: [Message]
        }
        
    }
    
    struct Message: Codable {
        let id: String
        let user_id: String
        let namespace_id: String
        let message: String
        let timestamp: Date
    }
    
    struct OtherUser: Codable {
        let id: String
        let name: String
    }
    
    struct Namespace: Codable {
        let id: String
        let name: String
        let creator: Creator
    }
    
    struct Creator: Codable {
        let id: String
        let name: String?
    }
    
    enum Direction: String {
        case backward = "backward"
    }
    
}
