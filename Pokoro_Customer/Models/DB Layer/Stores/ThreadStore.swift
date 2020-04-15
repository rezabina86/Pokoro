//
//  ThreadStore.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-15.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit
import CoreData

class ThreadStore<T: Threads> {
    
    private var context: NSManagedObjectContext {
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func insert(_ event: T) {
        ChatThreadModel.insert(event as! ChatThreadModel.T, with: context)
    }

    func update(_ event: T) {
        ChatThreadModel.update(event as! ChatThreadModel.T, with: context)
    }

    func delete(_ event: T) {
        ChatThreadModel.delete(event as! ChatThreadModel.T, with: context)
    }

    func fetchAll() -> [T] {
        return ChatThreadModel.fetchAll(from: context) as! [T]
    }
    
    func fetch(sorted: Sorted?, predicate: NSPredicate?) -> [T] {
        return ChatThreadModel.fetch(from: context, predicate: predicate, sorted: sorted) as! [T]
    }
    
    func fetchAllSorted() -> [T] {
        let sorted = Sorted(key: "threadDate", ascending: false)
        return fetch(sorted: sorted, predicate: nil)
    }
    
}
