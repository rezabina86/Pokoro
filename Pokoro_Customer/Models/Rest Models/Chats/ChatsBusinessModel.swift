//
//  ChatsBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-28.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

struct ChatsBusinessModel {
    
    struct Fetch {
        
        struct Response: Codable {
            let from_timestamp: Date
            let to_timestamp: Date
            let results: [Chat]
        }
        
    }
    
    struct Chat:Codable {
        let id: String
        let unread_messages_count: Int
        let updated_at: Int64
        let other_user: OtherUser
        let namespace: Namespace
        let last_message: LastMessage
    }
    
    struct OtherUser:Codable {
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
    
    struct LastMessage: Codable {
        let id: String
        let user_id: String
        let namespace_id: String
        let message: String
        let timestamp: Int64
    }
    
}
