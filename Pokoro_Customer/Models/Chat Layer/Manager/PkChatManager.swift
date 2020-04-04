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
    
    private var cancellables = Set<AnyCancellable>()
    
    //This property sets within AppDelegate and PKUserManager.
    //When the app goes to background socket should be disconnected and when the app goes to foreground socket should be connected again and
    //the threads should be synced
    private var appInForeground: Bool = true
    
    //Socket Manager
    private let socketManager = PKSocketManager.shared
    
    init() {
        socketManager.delegate = self
        setupListeners()
    }
    
    private func setupListeners() {
        PKUserManager.shared.$isAppInForeground.sink { [weak self] (status) in
            guard let `self` = self else { return }
            self.appInForeground = status
            self.setup()
        }.store(in: &cancellables)
    }
    
    public func disconnect() {
        socketManager.disconnect()
    }
    
    private func setup() {
        if PKUserManager.shared.isUserLoggedIn && appInForeground {
            socketManager.connect()
        }
    }
    
    private func getThreads() {
        NetworkManager().getChats { [weak self] (result, error) in
            guard let `self` = self else { return }
            if error != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                    guard let `self` = self else { return }
                    self.getThreads()
                }
            } else if let chats = result {
                self.threads = chats.results.map({ T(apiResponse: $0) })
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
        getThreads()
    }
    
}
