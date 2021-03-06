//
//  ChatThread.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-04.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class ChatThread<M: Messages>: Threads {
    
    private (set) var identifier: String?
    var id: String
    var userId: String?
    var userName: String?
    var timeStamp: Int64
    var namespaceId: String?
    var namespaceName: String?
    var numberOfUnreadMessages: Int = 0
    var nameSpaceOwner: String?
    var lastMessage: M?
    
    init(id: String, userId: String?, userName: String?, timeStamp: Int64, namespaceId: String?, namespaceName: String?, numberOfUnreadMessages: Int = 0, nameSpaceOwner: String?, lastMessage: M?) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.timeStamp = timeStamp
        self.namespaceId = namespaceId
        self.namespaceName = namespaceName
        self.numberOfUnreadMessages = numberOfUnreadMessages
        self.nameSpaceOwner = nameSpaceOwner
        self.lastMessage = lastMessage
    }
    
    required init(apiResponse: ChatsBusinessModel.Chat) {
        self.id = apiResponse.id
        self.userId = apiResponse.other_user.id
        self.userName = apiResponse.other_user.name
        self.timeStamp = apiResponse.last_message.timestamp
        self.namespaceId = apiResponse.namespace.id
        self.namespaceName = apiResponse.namespace.name
        self.numberOfUnreadMessages = apiResponse.unread_messages_count
        self.nameSpaceOwner = apiResponse.namespace.creator.id
        self.lastMessage = M(chat: apiResponse)
    }
    
    required init(incomeMessage: IncomeMessageBusinessModel) {
        self.id = incomeMessage.chat_id
        self.userId = incomeMessage.user_id
        self.lastMessage = M(socketMessage: incomeMessage)
        self.timeStamp = incomeMessage.timestamp
        self.userName = nil
        self.namespaceId = incomeMessage.namespace_id
        self.numberOfUnreadMessages += 1
    }
    
    required init(namespace: CheckNamespaceBusinessModel.Fetch.Response) {
        self.id = ""
        self.namespaceId = namespace.id
        self.timeStamp = 0
        self.userName = namespace.creator.name
        self.namespaceName = namespace.name
        self.nameSpaceOwner = namespace.creator.id
    }
    
    func update(with detail: ThreadBusinessModel.Fetch.Response) {
        self.userName = detail.other_user.name
        self.numberOfUnreadMessages = detail.messages.filter({ !$0.is_seen }).count
        self.nameSpaceOwner = detail.namespace.creator.id
        self.namespaceName = detail.namespace.name
        self.namespaceId = detail.namespace.id
    }
    
    func update(with incomeMessage: IncomeMessageBusinessModel) {
        self.numberOfUnreadMessages += 1
        lastMessage = M(socketMessage: incomeMessage)
        id = incomeMessage.chat_id
        timeStamp = incomeMessage.timestamp
    }
    
    func resetCounter() {
        numberOfUnreadMessages = 0
    }
    
    static func == (lhs: ChatThread<M>, rhs: ChatThread<M>) -> Bool {
        return lhs.id == rhs.id
    }
    
}
