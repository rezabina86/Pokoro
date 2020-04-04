//
//  ChatMessage.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-04.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class ChatMessage: Messages {
    
    var id: String
    var userId: String?
    var message: String?
    var lastMessageId: String?
    var timestamp: Int64
    var isSeen: Bool
    
    required init(socketMessage: IncomeMessageBusinessModel) {
        self.id = socketMessage.id
        self.userId = socketMessage.user_id
        self.message = socketMessage.message
        self.timestamp = socketMessage.timestamp
        self.lastMessageId = socketMessage.last_message_id
        self.isSeen = false
    }
    
    required init(apiResponse: ThreadBusinessModel.Message) {
        self.id = apiResponse.id
        self.userId = apiResponse.user_id
        self.message = apiResponse.message
        self.timestamp = apiResponse.timestamp
        self.isSeen = true
    }
    
    required init(lastMessage: ChatsBusinessModel.LastMessage) {
        self.id = lastMessage.id
        self.userId = lastMessage.user_id
        self.message = lastMessage.message
        self.timestamp = lastMessage.timestamp
        self.isSeen = false
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
