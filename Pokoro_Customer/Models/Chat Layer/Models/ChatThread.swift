//
//  ChatThread.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-04.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class ChatThread<M: Messages>: Threads {
    
    var id: String
    var userId: String?
    var userName: String?
    var timeStamp: Int64
    var namespaceId: String?
    var namespaceName: String?
    var hasUnseenMessage: Bool = false
    var nameSpaceOwner: String?
    var lastMessage: M?
    
    required init(apiResponse: ChatsBusinessModel.Chat) {
        self.id = apiResponse.id
        self.userId = apiResponse.other_user.id
        self.userName = apiResponse.other_user.name
        self.timeStamp = apiResponse.updated_at
        self.namespaceId = apiResponse.namespace.id
        self.namespaceName = apiResponse.namespace.name
        self.hasUnseenMessage = apiResponse.unread_messages_count != 0
        self.nameSpaceOwner = apiResponse.namespace.creator.name
        self.lastMessage = M(lastMessage: apiResponse.last_message)
    }
    
    required init(incomeMessage: IncomeMessageBusinessModel) {
        self.id = incomeMessage.chat_id
        self.userId = incomeMessage.user_id
        self.lastMessage = M(socketMessage: incomeMessage)
        self.timeStamp = incomeMessage.timestamp
        self.userName = nil
        self.namespaceId = incomeMessage.namespace_id
        self.hasUnseenMessage = true
    }
    
    required init(namespace: CheckNamespaceBusinessModel.Fetch.Response) {
        self.id = ""
        self.namespaceId = namespace.id
        self.timeStamp = 0
        self.userName = namespace.creator.name
        self.namespaceName = namespace.name
        self.nameSpaceOwner = namespace.creator.id
    }
    
}
