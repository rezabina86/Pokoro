//
//  ChatThreadModel+CoreDataClass.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-15.
//  Copyright © 2020 Reza Bina. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ChatThreadModel)
public class ChatThreadModel: NSManagedObject, ManagedObjectConvertible {
    
    typealias T = ChatThread<ChatMessage>
    
    func from(object: ChatThread<ChatMessage>) {
        id = object.id
        userId = object.userId
        userName = object.userName
        timeStamp = object.timeStamp
        namespaceId = object.namespaceId
        namespaceName = object.namespaceName
        numberOfUnreadMessages = Int64(object.numberOfUnreadMessages)
        nameSpaceOwner = object.nameSpaceOwner
        threadDate = object.lastMessageDate
    }
    
    func toObject() -> ChatThread<ChatMessage> {
        let thread = ChatThread<ChatMessage>(id: id!, userId: userId, userName: userName, timeStamp: timeStamp, namespaceId: namespaceId, namespaceName: namespaceName, numberOfUnreadMessages: Int(numberOfUnreadMessages), nameSpaceOwner: nameSpaceOwner, lastMessage: nil)
        if let lastMessage = lastMessage?.toObject() { thread.lastMessage = lastMessage }
        return thread
    }
    
}
