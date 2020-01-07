//
//  DemoMessageManager.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-07.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class DemoMessageManager: NSObject {
    
    static let shared = DemoMessageManager()
    
    var threads : DemoMessagesBusinessModel.Threads? {
        get {
            guard let data = UserDefaults.standard.value(forKey: "threads") as? Data else { return nil }
            return try? JSONDecoder().decode(DemoMessagesBusinessModel.Threads.self, from: data)
        }
        set {
            let data = try? JSONEncoder().encode(newValue.self)
            UserDefaults.standard.set(data, forKey: "threads")
        }
    }
    
    private func createThreadID() -> Int {
        guard let threads = threads else { return 0 }
        Logger.log(message: threads, event: .error)
        return threads.threads.last!.id + 1
    }
    
    func createNewThread() -> DemoMessagesBusinessModel.Thread {
        let newId = createThreadID()
        Logger.log(message: newId, event: .info)
        let barcodeName = "My QR Code"
        let newThread = DemoMessagesBusinessModel.Thread(id: newId, barcodeName: barcodeName, messages: [])
        if let threads = threads {
            var newList = threads.threads
            newList.append(newThread)
            let newThreads = DemoMessagesBusinessModel.Threads(threads: newList)
            self.threads = newThreads
        } else {
            threads = DemoMessagesBusinessModel.Threads(threads: [newThread])
        }
        return newThread
    }
    
    func saveMessage(_ threadId: Int, message: String) {
        guard let thread = threads?.threads.first(where: { $0.id == threadId }) else { return }
        let newMessage = DemoMessagesBusinessModel.Message(message: message)
        var messageList = thread.messages
        messageList.append(newMessage)
        let newThread = DemoMessagesBusinessModel.Thread(id: thread.id, barcodeName: thread.barcodeName, messages: messageList)
        
        var oldThreads = (threads?.threads ?? [])
        oldThreads.removeAll(where: { $0.id == threadId })
        oldThreads.append(newThread)
        
        self.threads = DemoMessagesBusinessModel.Threads(threads: oldThreads)
    }
    
}
