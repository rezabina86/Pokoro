//
//  MessageStore.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-06.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import CoreData

class MessageStore {
    
    private var context: NSManagedObjectContext {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func insert(_ event: ChatMessage) {
        ChatMessageModel.insert(event, with: context)
    }

    func update(_ event: ChatMessage) {
        ChatMessageModel.update(event, with: context)
    }

    func delete(_ event: ChatMessage) {
        ChatMessageModel.delete(event, with: context)
    }

    func fetchAll() -> [ChatMessage] {
        return ChatMessageModel.fetchAll(from: context)
    }
    
    func fetch(sorted: Sorted?, predicate: NSPredicate?) -> [ChatMessage] {
        return ChatMessageModel.fetch(from: context, predicate: predicate, sorted: sorted)
    }
    
}
