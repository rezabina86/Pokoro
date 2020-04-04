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
    @Published var socketStatus: SocketClientEvent = .disconnect
    
    //Initially nil but when user tapped on a thread, it'll be replaced by that thread.
    //When user left the thread it'll be nil
    public var selectedThread: T?
    
    //This property will be false when the last message in a thread is fetched
    private var messagesPaginationEnded: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    //This property sets within AppDelegate and PKUserManager.
    //When the app goes to background socket should be disconnected and when the app goes to foreground socket should be connected again and
    //the threads should be synced
    private var appInForeground: Bool = true
    
    //Socket Manager
    private let socketManager = PKSocketManager.shared
    
    //Once the chatManager initialized it tries to connect to the socket and if connection is successful it will get all threads from the server
    init() {
        socketManager.delegate = self
        setupListeners()
    }
    
    private func setupListeners() {
        PKUserManager.shared.$isAppInForeground.sink { [weak self] (status) in
            guard let `self` = self else { return }
            self.appInForeground = status
            self.connect()
        }.store(in: &cancellables)
    }
    
    //Use this method to disconnect from socket if the app goes to background or user logged out
    public func disconnect() {
        socketManager.disconnect()
    }
    
    //This private method connects to socket only if user logged in and app is in foreground
    private func connect() {
        if PKUserManager.shared.isUserLoggedIn && appInForeground {
            socketManager.connect()
        }
    }
    
    public func selectThread(_ thread: T?) {
        selectedThread = thread
        messages.removeAll()
        if let lastMessage = thread?.lastMessage as? M { messages.append(lastMessage) }
        messagesPaginationEnded = false
    }
    
    //This method calls when socket connection authenticated.
    private func fetchThreads() {
        NetworkManager().getChats { [weak self] (result, error) in
            guard let `self` = self else { return }
            if error != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                    guard let `self` = self else { return }
                    self.fetchThreads()
                }
            } else if let chats = result {
                self.threads = chats.results.map({ T(apiResponse: $0) })
            }
        }
    }
    
    //Call this method from Messages controller when user reached at the end of message list
    //This method reversed the messages list, but I should change it in the future.
    public func fetchThreadMessages(completion: @escaping () -> Void) {
        guard let selectedThread = selectedThread, let lastMessageId = messages.last?.id, !messagesPaginationEnded else { return }
        NetworkManager().getThread(request: ThreadBusinessModel.Fetch.Request(id: selectedThread.id, last_message: lastMessageId, direction: .backward)) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if error != nil {
                completion()
            } else if let result = result {
                guard result.messages.count > 0 else {
                    self.messagesPaginationEnded = true
                    completion()
                    return
                }
                let msgs = result.messages.reversed().map({ M(apiResponse: $0) })
                self.messages.append(contentsOf: msgs)
                completion()
            }
        }
    }
    
}

extension PkChatManager: PKSocketManagerDelegate {
    
    func pkSocketManagerDidReceive(_ manager: PKSocketManager, _ message: IncomeMessageBusinessModel) {
        
    }
    
    func pkSocketManagerClientStatusChanged(_ manager: PKSocketManager, event: SocketClientEvent) {
        socketStatus = event
        guard let token = PKUserManager.shared.token else {
            socketManager.disconnect()
            return
        }
        socketManager.authenticate(model: AuthenticateBusinessModel(session: token))
    }
    
    func pkSocketManagerDidAuthenticate(_ manager: PKSocketManager) {
        fetchThreads()
    }
    
}
