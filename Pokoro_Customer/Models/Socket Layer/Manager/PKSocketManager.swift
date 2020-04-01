//
//  PKSocketManager.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-26.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import SocketIO

protocol PKSocketManagerDelegate: class {
    func pkSocketManagerDidReceive(_ manager: PKSocketManager, _ message: IncomeMessageBusinessModel)
    func pkSocketManagerClientStatusChanged(_ manager: PKSocketManager, event: SocketClientEvent)
    func pkSocketManagerDidAuthenticate(_ manager: PKSocketManager)
}

class PKSocketManager: NSObject {
    
    private let manager: SocketManager!
    private let socket: SocketIOClient!
    
    public static let shared = PKSocketManager()
    
    weak var delegate: PKSocketManagerDelegate?
    
    override init() {
        manager = SocketManager(socketURL: URL(string: "http://23.92.221.40:3000")!, config: [.log(false)])
        socket = manager.defaultSocket
        super.init()
        setupListeners()
    }
    
    public var isConnected: Bool {
        return socket.status == .connected
    }
    
    public func setupListeners() {
        authenticated()
        getMessage()
        setupClientListeners()
        sendMessageListener()
    }

    public func connect() {
        socket.connect()
    }

    public func disconnect() {
        socket.disconnect()
    }
    
    public func sendMessage(model: OutgoingMessageBusinessModel) {
        socket.emit(SocketEvent.sendMessage.event, model)
    }

    public func authenticate(model: AuthenticateBusinessModel) {
        socket.emit(SocketEvent.authentication.event, model)
    }
    
    public func seenMessage(model: SeenMessageBusinessModel) {
        socket.emit(SocketEvent.seenMessage.event, model)
    }

    private func getMessage() {
        socket.on(SocketEvent.getMessage.event) { (data, _) in
            if let dic = data.first as? [String : Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                    let result = try JSONDecoder().decode(IncomeMessageBusinessModel.self, from: data)
                    self.delegate?.pkSocketManagerDidReceive(self, result)
                } catch {
                    print(error)
                    return
                }
                
            }
        }
    }
    
    private func sendMessageListener() {
        socket.on(SocketEvent.sentMessage.event) { (data, _) in
            if let dic = data.first as? [String : Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                    let result = try JSONDecoder().decode(IncomeMessageBusinessModel.self, from: data)
                    self.delegate?.pkSocketManagerDidReceive(self, result)
                } catch {
                    print(error)
                    return
                }
                
            }
        }
    }

    private func authenticated() {
        socket.on(SocketEvent.authenticated.event) { [weak self] (_, _) in
            guard let `self` = self else { return }
            self.delegate?.pkSocketManagerDidAuthenticate(self)
        }
    }
    
    private func setupClientListeners() {
        socket.on(clientEvent: .connect) { [weak self] (_, _) in
            guard let `self` = self else { return }
            self.delegate?.pkSocketManagerClientStatusChanged(self, event: .connect)
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] (_, _) in
            guard let `self` = self else { return }
            self.delegate?.pkSocketManagerClientStatusChanged(self, event: .disconnect)
        }
        
        socket.on(clientEvent: .reconnect) { [weak self] (_, _) in
            guard let `self` = self else { return }
            self.delegate?.pkSocketManagerClientStatusChanged(self, event: .reconnect)
        }
        
    }
    
}
