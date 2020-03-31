//
//  ChatsDataModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-28.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation
import Combine
import SocketIO

class ChatsDataModel: ObservableObject {
    
    private let manager = PKSocketManager.shared
    @Published var threads: [Thread] = []
    @Published var messages: [Message] = []
    private var selectedThread: Thread?
    public var name: String?
    
    private var paginationEnded: Bool = false
    private var lastMessageId: String?
    
    init() {
        manager.delegate = self
        manager.connect()
    }
    
    public func setup(apiResponse: ChatsBusinessModel.Fetch.Response) {
        self.threads = apiResponse.results.map({ Thread(apiResponse: $0) })
    }
    
    private func isThreadFound(id: String) -> Bool {
        return threads.first(where: { $0.id == id }) != nil
    }
    
    public func saveIncomeMessage(message: IncomeMessageBusinessModel) {
        updateThread(with: message, completion: { [weak self] in
            guard let `self` = self else { return }
            switch message.isOutgoingMessage {
            case true:
                self.messages.insert(Message(socketMessage: message), at: 0)
                if let affectedThread = self.threads.first(where: { $0.id == message.chat_id }) {
                    self.seenAllMessageIn(thread: affectedThread)
                }
            case false:
                if self.isThreadFound(id: message.chat_id) {
                    if message.chat_id == self.selectedThread?.id {
                        self.messages.insert(Message(socketMessage: message), at: 0)
                    } else {
                        if let affectedThread = self.threads.first(where: { $0.id == message.chat_id }) {
                            self.seenAllMessageIn(thread: affectedThread)
                        }
                    }
                }
            }
        })
    }
    
    private func updateThread(with message: IncomeMessageBusinessModel, completion: @escaping () -> Void) {
        guard let effectedThread = threads.enumerated().first(where: { $0.element.id == message.chat_id }) else {
            getChatDetail(chatId: message.chat_id) { [weak self] (result) in
                guard let `self` = self else { return }
                let newThread = Thread(incomeMessage: message)
                newThread.userName = result.other_user.name
                newThread.hasUnseenMessage = true
                if self.selectedThread?.isThreadTemp ?? false { self.selectedThread = newThread }
                self.threads.insert(contentsOf: [newThread], at: 0)
                completion()
            }
            return
        }
        let newThread = Thread(thread: effectedThread.element)
        newThread.lastMessage = message.message
        newThread.lastMessageUserId = message.user_id
        newThread.lastMessageId = message.id
        newThread.timeStamp = message.timestamp
        newThread.id = message.chat_id
        newThread.hasUnseenMessage = true
        threads.remove(at: effectedThread.offset)
        threads.insert(contentsOf: [newThread], at: 0)
        completion()
    }
    
    public func select(thread: Thread?) {
        paginationEnded = false
        lastMessageId = thread?.lastMessageId
        selectedThread = thread
        seenAllMessageIn(thread: thread)
        name = selectedThread?.userName
        messages.removeAll()
    }
    
    private func seenAllMessageIn(thread: Thread?) {
        guard let affectedThread = threads.enumerated().first(where: { $0.element.id == thread?.id }) else { return }
        affectedThread.element.hasUnseenMessage = false
        threads.remove(at: affectedThread.offset)
        threads.insert(contentsOf: [affectedThread.element], at: affectedThread.offset)
    }
    
    public func fetchThreadFromAPI(completion: @escaping () -> Void) {
        guard let selectedThread = selectedThread, let lastMessageId = lastMessageId, paginationEnded == false else { return }
        if messages.isEmpty {
            let firstMessage = Message(thread: selectedThread)
            Logger.log(message: firstMessage.user_id, event: .error)
            messages.append(firstMessage)
        }
        NetworkManager().getThread(request: ThreadBusinessModel.Fetch.Request(id: selectedThread.id, last_message: lastMessageId, direction: .backward)) { [weak self] (response, error) in
            guard let `self` = self else { return }
            if let error = error {
                Logger.log(message: error, event: .error)
                completion()
            } else if let response = response {
                if response.messages.count == 0 {
                    self.paginationEnded = true
                    completion()
                    return
                }
                self.messages.append(contentsOf: response.messages.map({ ChatsDataModel.Message(apiResponse: $0) }).reversed())
                self.lastMessageId = self.messages.last?.id
                completion()
            }
        }
    }
    
    public func seenMessage(_ message: Message) {
        guard !message.isSeen, let selectedThread = selectedThread else { return }
        manager.seenMessage(model: SeenMessageBusinessModel(chat_id: selectedThread.id, message_id: message.id))
    }
    
    public func sendMessage(_ message: String) {
        guard let selectedThread = selectedThread, let namespaceId = selectedThread.namespaceId else { return }
        manager.sendMessage(model: OutgoingMessageBusinessModel(namespace_id: namespaceId, user_id: selectedThread.userId, message: message))
    }
    
    private func findThread(with namespaceId: String) -> Thread? {
        return threads.first(where: { $0.namespaceId == namespaceId })
    }
    
    public func startThread(with namespace: CheckNamespaceBusinessModel.Fetch.Response) {
        if let namespace = findThread(with: namespace.id) {
            select(thread: namespace)
        } else {
            select(thread: Thread(namespace: namespace))
        }
    }
    
    private func getChatDetail(chatId: String, completion: @escaping (ThreadBusinessModel.Fetch.Response) -> Void) {
        NetworkManager().getThread(request: ThreadBusinessModel.Fetch.Request(id: chatId)) { (response, _) in
            if let response = response { completion(response) }
        }
    }
    
    class Thread {
        var id: String
        var userId: String?
        var userName: String?
        var lastMessage: String?
        var timeStamp: Int64
        var lastMessageId: String?
        var namespaceId: String?
        var lastMessageUserId: String?
        var hasUnseenMessage: Bool = false
        
        init(apiResponse: ChatsBusinessModel.Chat) {
            self.id = apiResponse.id
            self.userId = apiResponse.other_user.id
            self.lastMessage = apiResponse.last_message.message
            self.timeStamp = apiResponse.last_message.timestamp
            self.userName = apiResponse.other_user.name
            self.lastMessageId = apiResponse.last_message.id
            self.namespaceId = apiResponse.namespace.id
            self.lastMessageUserId = apiResponse.last_message.user_id
            self.hasUnseenMessage = apiResponse.unread_messages_count != 0
        }
        
        init(thread: Thread) {
            self.id = thread.id
            self.userId = thread.userId
            self.lastMessage = thread.lastMessage
            self.timeStamp = thread.timeStamp
            self.userName = thread.userName
            self.lastMessageId = thread.lastMessageId
            self.namespaceId = thread.namespaceId
            self.lastMessageUserId = thread.lastMessageUserId
        }
        
        init(incomeMessage: IncomeMessageBusinessModel) {
            self.id = incomeMessage.chat_id
            self.userId = incomeMessage.user_id
            self.lastMessage = incomeMessage.message
            self.timeStamp = incomeMessage.timestamp
            self.userName = nil
            self.lastMessageId = incomeMessage.id
            self.namespaceId = incomeMessage.namespace_id
            self.lastMessageUserId = incomeMessage.user_id
            self.hasUnseenMessage = true
        }
        
        init(namespace: CheckNamespaceBusinessModel.Fetch.Response) {
            self.id = ""
            self.namespaceId = namespace.id
            self.timeStamp = 0
            self.userName = namespace.creator.name
        }
        
        var isThreadTemp: Bool {
            return id.count == 0
        }
        
        var stringDate: String? {
            return Date(timeIntervalSince1970: TimeInterval(timeStamp / 1000)).stringFormat
        }
        
    }
    
    class Message: Hashable {
        
        let id: String
        let user_id: String?
        let message: String?
        var lastMessageId: String?
        let timestamp: Int64
        let isSeen: Bool
        
        init(thread: Thread) {
            self.id = thread.lastMessageId ?? ""
            self.user_id = thread.lastMessageUserId
            self.message = thread.lastMessage
            self.lastMessageId = thread.lastMessageId
            self.timestamp = thread.timeStamp
            self.isSeen = false
        }
        
        init(socketMessage: IncomeMessageBusinessModel) {
            self.id = socketMessage.id
            self.user_id = socketMessage.user_id
            self.message = socketMessage.message
            self.timestamp = socketMessage.timestamp
            self.lastMessageId = socketMessage.last_message_id
            self.isSeen = false
        }
        
        init(apiResponse: ThreadBusinessModel.Message) {
            self.id = apiResponse.id
            self.user_id = apiResponse.user_id
            self.message = apiResponse.message
            self.timestamp = apiResponse.timestamp
            self.isSeen = true
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

extension ChatsDataModel: PKSocketManagerDelegate {
    
    func pkSocketManagerClientStatusChanged(_ manager: PKSocketManager, event: SocketClientEvent) {
        if event == .connect {
            guard let session = PKUserManager.shared.token else {
                manager.disconnect()
                return
            }
            manager.authenticate(model: AuthenticateBusinessModel(session: session))
        }
    }
    
    func pkSocketManagerDidReceive(_ manager: PKSocketManager, _ message: IncomeMessageBusinessModel) {
        saveIncomeMessage(message: message)
    }
    
    func pkSocketManagerDidAuthenticate(_ manager: PKSocketManager) {
        Logger.log(message: "Authenticated", event: .info)
    }
    
}
