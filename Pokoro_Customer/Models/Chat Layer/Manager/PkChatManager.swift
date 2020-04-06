//
//  PkChatManager.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-04.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation
import Combine
import SocketIO
import AVFoundation

class PkChatManager<T: Threads, M: Messages>: ObservableObject {
    
    //All the threads that come from server or create when user starts a new thread by scan a new QR
    @Published var threads: [T] = []
    
    //Messages are initially empty but when user selects a thread it'll be filled by all messages are in that thread.
    //Be sure clear messages when user left the thread
    @Published var messages: [M] = []
    
    //this publisher just tells view that socket connected or not.
    @Published var managerStatus: ManagerStatus = .disconnected
    
    @Published var unseenThreads: Int = 0
    
    private var socketStatus: SocketClientEvent = .disconnect
    
    //Initially nil but when user tapped on a thread, it'll be replaced by that thread.
    //When user left the thread it'll be nil
    public var selectedThread: T?
    
    ///Store manager that uses CoreData to save messages
    private var messageStore: MessageStore<M>!
    
    //This property will be false when the last message in a thread is fetched
    private var messagesPaginationEnded: Bool = false
    
    private var fetchInProgress: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    //This property sets within AppDelegate and PKUserManager.
    //When the app goes to background socket should be disconnected and when the app goes to foreground socket should be connected again and
    //the threads should be synced
    private var appInForeground: Bool = true
    
    //Socket Manager
    private let socketManager = PKSocketManager.shared
    
    //Once the chatManager initialized it tries to connect to the socket and if connection is successful it will get all threads from the server
    init() {
        messageStore = MessageStore()
        socketManager.delegate = self
        setupListeners()
    }
    
    private func setupListeners() {
        PKUserManager.shared.$isAppInForeground.sink { [weak self] (status) in
            guard let `self` = self else { return }
            self.appInForeground = status
            self.changeSocketStatus()
        }.store(in: &cancellables)
    }
    
    private func changeSocketStatus() {
        if PKUserManager.shared.isUserLoggedIn && appInForeground {
            connect()
        } else if !appInForeground || !PKUserManager.shared.isUserLoggedIn {
            disconnect()
        }
    }
    
    //Use this method to disconnect from socket if the app goes to background or user logged out
    public func disconnect() {
        socketManager.disconnect()
    }
    
    //This private method connects to socket only if user logged in and app is in foreground
    private func connect() {
        socketManager.connect()
    }
    
    public func selectThread(_ thread: T?) {
        selectedThread = thread
        messages.removeAll()
        messagesPaginationEnded = false
        fetchMessagesFromDB(for: thread)
        seenAllMessageInSelectedThread()
        updateUnseenThreads()
    }
    
    private func fetchMessagesFromDB(for thread: T?) {
        guard let thread = thread else { return }
        messages = messageStore.fetch(chatId: thread.id).reversed()
        syncMessageWithAPI()
    }
    
    private func syncMessageWithAPI() {
        guard let lastMessage = selectedThread?.lastMessage else { return }
        if messages.count == 0 {
            messages.append(lastMessage as! M)
            fetchMessagesBackward()
        } else {
            if lastMessage.id != messages.first?.id {
                fetchMessagesForward()
            }
        }
    }
    
    private func fetchMessagesForward() {
        guard let selectedThread = selectedThread, let lastMessageId = messages.first?.id, !fetchInProgress else { return }
        fetchInProgress = true
        NetworkManager().getThread(request: ThreadBusinessModel.Fetch.Request(id: selectedThread.id, last_message: lastMessageId)) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if error != nil {
                self.fetchInProgress = false
            } else if let result = result {
                let msgs = result.messages.reversed().map({ M(apiResponse: $0,thread: result) })
                self.messages.insert(contentsOf: msgs, at: 0)
                msgs.forEach { [weak self] (m) in
                    guard let `self` = self else { return }
                    self.messageStore.insert(m)
                }
                self.fetchInProgress = false
                self.syncMessageWithAPI()
            }
        }
    }
    
    private func fetchMessagesBackward() {
        guard let selectedThread = selectedThread, let lastMessageId = messages.last?.id, !messagesPaginationEnded, !fetchInProgress else { return }
        fetchInProgress = true
        NetworkManager().getThread(request: ThreadBusinessModel.Fetch.Request(id: selectedThread.id, last_message: lastMessageId, direction: .backward)) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if error != nil {
                self.fetchInProgress = false
            } else if let result = result {
                guard result.messages.count > 0 else {
                    self.messagesPaginationEnded = true
                    self.fetchInProgress = false
                    return
                }
                let msgs = result.messages.reversed().map({ M(apiResponse: $0,thread: result) })
                self.messages.append(contentsOf: msgs)
                msgs.forEach { [weak self] (m) in
                    guard let `self` = self else { return }
                    self.messageStore.insert(m)
                }
                self.fetchInProgress = false
            }
        }
    }
    
    //This method calls when socket connection authenticated.
    private func fetchThreads() {
        managerStatus = .updatingThreadList
        NetworkManager().getChats { [weak self] (result, error) in
            guard let `self` = self else { return }
            self.managerStatus = .connected
            if error != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                    guard let `self` = self else { return }
                    self.fetchThreads()
                }
            } else if let chats = result {
                self.threads = chats.results.map({ T(apiResponse: $0) })
                if let selectedThread = self.selectedThread {
                    self.selectedThread = self.threads.first(where: { $0 == selectedThread })
                    self.syncMessageWithAPI()
                }
                self.updateUnseenThreads()
            }
        }
    }
    
    //Call this method from Messages controller when user reached at the end of message list
    //This method reversed the messages list, but I should change it in the future.
    public func fetchThreadMessages() {
        guard let selectedThread = selectedThread, let lastMessageId = messages.last?.id, !messagesPaginationEnded, !fetchInProgress else { return }
        managerStatus = .updatingThread
        fetchInProgress = true
        NetworkManager().getThread(request: ThreadBusinessModel.Fetch.Request(id: selectedThread.id, last_message: lastMessageId, direction: .backward)) { [weak self] (result, error) in
            guard let `self` = self else { return }
            self.fetchInProgress = false
            self.managerStatus = .connected
            if let error = error {
                Logger.log(message: error, event: .error)
            } else if let result = result {
                guard result.messages.count > 0 else {
                    self.messagesPaginationEnded = true
                    return
                }
                let msgs = result.messages.reversed().map({ M(apiResponse: $0,thread: result) })
                msgs.forEach { [weak self] (m) in
                    guard let `self` = self else { return }
                    self.messageStore.insert(m)
                }
                self.messages.append(contentsOf: msgs)
            }
        }
    }
    
    private func findThread(with id: String) -> (offset: Int, thread: T)? {
        let foundThreads = threads.enumerated().filter({ $0.element.id == id })
        guard foundThreads.count < 2 else {
            fatalError("You couldn't have more than one thread with same id")
        }
        guard let firstFoundThread = foundThreads.first else { return nil }
        return (firstFoundThread.offset, firstFoundThread.element)
    }
    
    private func findThread(namespaceId: String) -> T? {
        return threads.first(where: { $0.namespaceId == namespaceId })
    }
    
    public func sendMessage(_ message: String, completion: @escaping (Bool) -> Void) {
        guard let selectedThread = selectedThread, let namespaceId = selectedThread.namespaceId else { return }
        let message = OutgoingMessageBusinessModel(namespace_id: namespaceId, user_id: selectedThread.userId, message: message)
        handleSendMessage(message, completion: { success in
            completion(success)
        })
    }
    
    private func handleSendMessage(_ message: OutgoingMessageBusinessModel, completion: (_ success: Bool) -> Void) {
        if socketStatus == .connect {
            socketManager.sendMessage(model: message)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    private func handleIncomeMessage(_ message: IncomeMessageBusinessModel) {
        if findThread(with: message.chat_id) != nil {
            saveIncomeMessage(message)
        } else {
            makeThreadForNewMessage(message)
        }
    }
    
    private func makeThreadForNewMessage(_ message: IncomeMessageBusinessModel) {
        NetworkManager().getThread(request: ThreadBusinessModel.Fetch.Request(id: message.chat_id)) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if error != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let `self` = self else { return }
                    self.makeThreadForNewMessage(message)
                }
            } else if let result = result {
                let newThread = T(incomeMessage: message)
                newThread.update(with: result)
                if self.selectedThread?.isThreadTemp ?? false { self.selectedThread = newThread }
                self.threads.append(newThread)
                self.sortThreads()
                self.handleIncomeMessage(message)
            }
        }
    }
    
    private func saveIncomeMessage(_ message: IncomeMessageBusinessModel) {
        guard let editingThread = findThread(with: message.chat_id) else { fatalError("editing thread can't be nil") }
        editingThread.thread.update(with: message)
        threads[editingThread.offset] = editingThread.thread
        if let selectedThread = selectedThread, selectedThread.id == message.chat_id {
            let newMessage = M(socketMessage: message)
            messageStore.insert(newMessage)
            messages.insert(newMessage, at: 0)
        }
        sortThreads()
        updateUnseenThreads()
    }
    
    public func startThread(with namespace: CheckNamespaceBusinessModel.Fetch.Response) {
        if let namespace = findThread(namespaceId: namespace.id) {
            selectThread(namespace)
        } else {
            selectThread(T(namespace: namespace))
        }
    }
    
    public func seenMessage(_ message: M) {
        guard !message.isSeen, let selectedThread = selectedThread else { return }
        socketManager.seenMessage(model: SeenMessageBusinessModel(chat_id: selectedThread.id, message_id: message.id))
        var seenMessage = message
        seenMessage.isSeen = true
        messageStore.update(seenMessage)
        seenAllMessageInSelectedThread()
    }
    
    private func seenAllMessageInSelectedThread() {
        guard let selectedThread = selectedThread, let seenThread = threads.enumerated().first(where: { $0.element == selectedThread }) else { return }
        var updatedThread = seenThread.element
        updatedThread.hasUnseenMessage = false
        threads.remove(at: seenThread.offset)
        threads.insert(contentsOf: [updatedThread], at: seenThread.offset)
    }
    
    private func updateUnseenThreads() {
        unseenThreads = threads.filter({ $0.hasUnseenMessage }).count
    }
    
    //Everytime this method is called, it'll sort the threads by date
    //Feel free to call this method wherever you want.
    private func sortThreads() {
        threads = threads.sorted(by: { $0.lastMessageDate > $1.lastMessageDate })
    }
    
}

extension PkChatManager: PKSocketManagerDelegate {
    
    func pkSocketManagerDidReceive(_ manager: PKSocketManager, _ message: IncomeMessageBusinessModel) {
        handleIncomeMessage(message)
    }
    
    func pkSocketManagerClientStatusChanged(_ manager: PKSocketManager, event: SocketClientEvent) {
        guard let token = PKUserManager.shared.token else {
            socketManager.disconnect()
            return
        }
        socketStatus = event
        switch event {
        case .connect: managerStatus = .connected
        case .disconnect: managerStatus = .disconnected
        case .reconnect: managerStatus = .disconnected
        default: break
        }
        socketManager.authenticate(model: AuthenticateBusinessModel(session: token))
    }
    
    func pkSocketManagerDidAuthenticate(_ manager: PKSocketManager) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let `self` = self else { return }
            self.fetchThreads()
        }
    }
    
}
