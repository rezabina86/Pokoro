//
//  ChatMessageModel+CoreDataClass.swift
//  
//
//  Created by Reza Bina on 2020-04-06.
//
//

import UIKit
import CoreData

@objc(ChatMessageModel)
public class ChatMessageModel: NSManagedObject, ManagedObjectConvertible {
    
    typealias T = ChatMessage
    
    func toObject() -> ChatMessage {
        Logger.log(message: id, event: .error)
        Logger.log(message: chatId, event: .error)
        return ChatMessage(id: id!, chatId: chatId!, userId: userId, message: message, lastMessageId: lastMessageId, timestamp: timestamp, isSeen: isSeen, messageDate: messageDate, identifier: identifier)
    }
    
    func from(object: ChatMessage) {
        id = object.id
        chatId = object.chatId
        userId = object.userId
        message = object.message
        lastMessageId = object.lastMessageId
        timestamp = object.timestamp
        isSeen = object.isSeen
        messageDate = object.date
    }

}
