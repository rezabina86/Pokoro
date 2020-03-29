//
//  ChatsDataModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-28.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation
import Combine

class ChatsDataModel: ObservableObject {
    
    @Published var threads: [Thread] = []
    @Published var messages: [Message] = []
    var selectedThread: Thread?
    
    private var paginationEnded: Bool = false
    private var lastMessageId: String?
    
    init(apiResponse: ChatsBusinessModel.Fetch.Response) {
        self.threads = apiResponse.results.map({ Thread(apiResponse: $0) })
    }
    
    private func isThreadFound(id: String) -> Bool {
        return threads.first(where: { $0.id == id }) != nil
    }
    
    public func saveIncomeMessage(message: IncomeMessageBusinessModel) {
        if isThreadFound(id: message.chat_id) {
            threads.first(where: { $0.id == message.chat_id })?.lastMessage = message.message
            threads.first(where: { $0.id == message.chat_id })?.lastMessageId = message.id
            threads.first(where: { $0.id == message.chat_id })?.timeStamp = message.timestamp
            if message.chat_id == selectedThread?.id {
                messages.insert(Message(socketMessage: message), at: 0)
            }
        } else {
            
        }
    }
    
    public func select(thread: Thread?) {
        paginationEnded = false
        lastMessageId = thread?.lastMessageId
        selectedThread = thread
        messages.removeAll()
    }
    
    public func fetchThreadFromAPI() {
        guard let selectedThread = selectedThread, let lastMessageId = lastMessageId, paginationEnded == false else { return }
        NetworkManager().getThread(request: ThreadBusinessModel.Fetch.Request(id: selectedThread.id, last_message: lastMessageId, direction: .backward)) { [weak self] (response, error) in
            guard let `self` = self else { return }
            if let error = error {
                Logger.log(message: error, event: .error)
            } else if let response = response {
                if response.messages.count == 0 {
                    self.paginationEnded = true
                    return
                }
                self.messages.append(contentsOf: response.messages.map({ ChatsDataModel.Message(apiResponse: $0) }).reversed())
                self.lastMessageId = self.messages.last?.id
            }
        }
    }
    
    class Thread {
        let id: String
        let userId: String
        let userName: String
        var lastMessage: String
        var timeStamp: Date
        var lastMessageId: String
        
        init(apiResponse: ChatsBusinessModel.Chat) {
            self.id = apiResponse.id
            self.userId = apiResponse.other_user.id
            self.lastMessage = apiResponse.last_message.message
            self.timeStamp = apiResponse.last_message.timestamp
            self.userName = apiResponse.other_user.name
            self.lastMessageId = apiResponse.last_message.id
        }
    }
    
    class Message: Hashable {
        
        let id: String
        let user_id: String
        let message: String
        var lastMessageId: String?
        let timestamp: Date
        
        init(socketMessage: IncomeMessageBusinessModel) {
            self.id = socketMessage.id
            self.user_id = socketMessage.user_id
            self.message = socketMessage.message
            self.timestamp = socketMessage.timestamp
            self.lastMessageId = socketMessage.last_message_id
        }
        
        init(apiResponse: ThreadBusinessModel.Message) {
            self.id = apiResponse.id
            self.user_id = apiResponse.user_id
            self.message = apiResponse.message
            self.timestamp = apiResponse.timestamp
        }
        
        var isIncomeMessage: Bool {
            return user_id != PKUserManager.shared.userId
        }
        
        static func == (lhs: ChatsDataModel.Message, rhs: ChatsDataModel.Message) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
}
