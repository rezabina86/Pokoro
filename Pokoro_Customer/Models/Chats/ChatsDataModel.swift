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
import AVFoundation

class ChatsDataModel: ObservableObject {
    
    private let manager = PKSocketManager.shared
    @Published var threads: [Thread] = []
    @Published var messages: [Message] = []
    @Published var unseenThreads: Int = 0
    @Published var newMessageRecieved: Int = 0
    @Published var socketStatus: SocketClientEvent = .disconnect
    public var selectedThread: Thread?
    private var unsentMessages: [OutgoingMessageBusinessModel] = []
    
    private var paginationEnded: Bool = false
    private var lastMessageId: String?
    
    init() {
        manager.delegate = self
    }
    
    public func connect() {
        manager.connect()
    }
    
    public func disconnect() {
        manager.disconnect()
    }
    
    public func setup(apiResponse: ChatsBusinessModel.Fetch.Response) {
        self.threads = apiResponse.results.map({ Thread(apiResponse: $0) })
        self.updateUnseenMessages()
        self.refreshThreads()
    }
    
    public func saveIncomeMessage(message: IncomeMessageBusinessModel) {
        updateThread(with: message, completion: { [weak self] in
            guard let `self` = self else { return }
            switch message.isOutgoingMessage {
            case true:
                self.messages.insert(Message(socketMessage: message), at: 0)
                self.seenAllMessageIn(threadId: message.chat_id)
            case false:
                if message.chat_id == self.selectedThread?.id {
                    self.messages.insert(Message(socketMessage: message), at: 0)
                    self.seenAllMessageIn(threadId: message.chat_id)
                    AudioServicesPlayAlertSound(SystemSoundID(1117))
                } else {
                    self.newMessageRecieved += 1
                }
            }
            self.updateUnseenMessages()
        })
    }
    
    private func updateThread(with message: IncomeMessageBusinessModel, completion: @escaping () -> Void) {
        guard let editingThread = findThread(id: message.chat_id) else {
            getChatDetail(chatId: message.chat_id) { [weak self] (result) in
                guard let `self` = self else { return }
                let newThread = Thread(incomeMessage: message)
                newThread.userName = result.other_user.name
                newThread.hasUnseenMessage = true
                newThread.nameSpaceOwner = result.namespace.creator.id
                newThread.namespaceName = result.namespace.name
                newThread.namespaceId = result.namespace.id
                if self.selectedThread?.isThreadTemp ?? false { self.selectedThread = newThread }
                self.threads.insert(contentsOf: [newThread], at: 0)
                self.refreshThreads()
                completion()
            }
            return
        }
        let newThread = Thread(thread: editingThread.thread)
        newThread.updateThread(with: message)
        threads.remove(at: editingThread.offset)
        threads.insert(contentsOf: [newThread], at: 0)
        refreshThreads()
        completion()
    }
    
    public func select(thread: Thread?) {
        paginationEnded = false
        lastMessageId = thread?.lastMessageId
        selectedThread = thread
        seenAllMessageIn(threadId: thread?.id)
        messages.removeAll()
        updateUnseenMessages()
    }
    
    private func refreshThreads() {
        let newOrder = threads.sorted(by: { $0.lastMessageDate > $1.lastMessageDate })
        threads = newOrder
    }
    
    private func seenAllMessageIn(threadId: String?) {
        guard let id = threadId, let editingThread = findThread(id: id) else { return }
        editingThread.thread.hasUnseenMessage = false
        threads.remove(at: editingThread.offset)
        threads.insert(contentsOf: [editingThread.thread], at: editingThread.offset)
    }
    
    public func fetchThreadFromAPI(completion: @escaping () -> Void) {
        guard let selectedThread = selectedThread, let lastMessageId = lastMessageId, paginationEnded == false else { return }
        if messages.isEmpty { messages.append(Message(thread: selectedThread)) }
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
    
    public func sendMessage(_ message: String, completion: @escaping (_ success: Bool) -> Void) {
        guard let selectedThread = selectedThread, let namespaceId = selectedThread.namespaceId else { return }
        let message = OutgoingMessageBusinessModel(namespace_id: namespaceId, user_id: selectedThread.userId, message: message)
        handleSendMessage(message, completion: { success in
            completion(success)
        })
    }
    
    private func handleSendMessage(_ message: OutgoingMessageBusinessModel, completion: (_ success: Bool) -> Void) {
        if socketStatus == .connect {
            manager.sendMessage(model: message)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    private func findThread(with namespaceId: String) -> Thread? {
        return threads.first(where: { $0.namespaceId == namespaceId })
    }
    
    private func findThread(id: String) -> (offset: Int, thread: Thread)? {
        guard let thread = threads.enumerated().first(where: { $0.element.id == id }) else { return nil }
        return (thread.offset, thread.element)
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
    
    private func updateUnseenMessages() {
        var unseenTotal = 0
        threads.forEach({
            if $0.hasUnseenMessage { unseenTotal += 1 }
        })
        unseenThreads = unseenTotal
    }
    
    class Thread {
        var id: String
        var userId: String?
        var userName: String?
        var lastMessage: String?
        var timeStamp: Int64
        var lastMessageId: String?
        var namespaceId: String?
        var namespaceName: String?
        var lastMessageUserId: String?
        var hasUnseenMessage: Bool = false
        var nameSpaceOwner: String?
        
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
            self.namespaceName = apiResponse.namespace.name
            self.nameSpaceOwner = apiResponse.namespace.creator.id
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
            self.namespaceName = thread.namespaceName
            self.nameSpaceOwner = thread.nameSpaceOwner
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
            self.namespaceName = namespace.name
            self.nameSpaceOwner = namespace.creator.id
        }
        
        var isThreadTemp: Bool {
            return id.count == 0
        }
        
        var stringDate: String? {
            return Date(timeIntervalSince1970: TimeInterval(timeStamp / 1000)).stringFormat
        }
        
        var lastMessageDate: Date {
            return Date(timeIntervalSince1970: TimeInterval(timeStamp / 1000))
        }
        
        func updateThread(with incomeMessage: IncomeMessageBusinessModel) {
            lastMessage = incomeMessage.message
            lastMessageUserId = incomeMessage.user_id
            lastMessageId = incomeMessage.id
            timeStamp = incomeMessage.timestamp
            id = incomeMessage.chat_id
            hasUnseenMessage = true
        }
        
        var isUserOwnerOfTheNamespace: Bool {
            guard let ownerId = nameSpaceOwner, let userId = PKUserManager.shared.userId else { return false }
            return ownerId == userId
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
        
        var stringDate: String? {
            return Date(timeIntervalSince1970: TimeInterval(self.timestamp / 1000)).stringFormat
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
        socketStatus = event
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
