//
//  ChatMessage.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-04.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class ChatMessage: Messages, Hashable {
    
    private (set) var identifier: String?
    var id: String
    var chatId: String
    var userId: String?
    var message: String?
    var lastMessageId: String?
    var timestamp: Int64
    var isSeen: Bool
    var messageDate: Date?
    
    init(id: String,chatId: String, userId: String?, message: String?, lastMessageId: String?, timestamp: Int64, isSeen: Bool, messageDate: Date?, identifier: String? = nil) {
        self.id = id
        self.chatId = chatId
        self.userId = userId
        self.message = message
        self.lastMessageId = lastMessageId
        self.timestamp = timestamp
        self.isSeen = isSeen
        self.messageDate = messageDate
        self.identifier = identifier
    }
    
    required init(socketMessage: IncomeMessageBusinessModel) {
        self.id = socketMessage.id
        self.chatId = socketMessage.chat_id
        self.userId = socketMessage.user_id
        self.message = socketMessage.message
        self.timestamp = socketMessage.timestamp
        self.lastMessageId = socketMessage.last_message_id
        self.isSeen = false
    }
    
    required init(apiResponse: ThreadBusinessModel.Message, thread: ThreadBusinessModel.Fetch.Response) {
        self.id = apiResponse.id
        self.userId = apiResponse.user_id
        self.message = apiResponse.message
        self.timestamp = apiResponse.timestamp
        self.chatId = thread.id
        self.isSeen = false
    }
    
    required init(chat: ChatsBusinessModel.Chat) {
        self.id = chat.last_message.id
        self.chatId = chat.id
        self.userId = chat.last_message.user_id
        self.message = chat.last_message.message
        self.timestamp = chat.last_message.timestamp
        self.isSeen = false
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
