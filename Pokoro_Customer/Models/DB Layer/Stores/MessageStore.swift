//
//  MessageStore.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import CoreData

class MessageStore<M: Messages> {
    
    private var context: NSManagedObjectContext {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func insert(_ event: M) {
        ChatMessageModel.insert(event as! ChatMessageModel.T, with: context)
    }

    func update(_ event: M) {
        ChatMessageModel.update(event as! ChatMessageModel.T, with: context)
    }

    func delete(_ event: M) {
        ChatMessageModel.delete(event as! ChatMessageModel.T, with: context)
    }

    func fetchAll() -> [M] {
        return ChatMessageModel.fetchAll(from: context) as! [M]
    }
    
    func fetch(sorted: Sorted?, predicate: NSPredicate?) -> [M] {
        return ChatMessageModel.fetch(from: context, predicate: predicate, sorted: sorted) as! [M]
    }
    
    func fetch(chatId: String) -> [M] {
        let sorted = Sorted(key: "messageDate", ascending: true)
        let predicate = NSPredicate(format: "chatId == %@", chatId)
        return fetch(sorted: sorted, predicate: predicate)
    }
    
}
