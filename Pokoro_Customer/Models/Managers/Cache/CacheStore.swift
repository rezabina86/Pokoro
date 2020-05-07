//
//  CacheStore.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-05-07.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class CacheStore {
    
    static let shared = CacheStore()
    
    private let path = URL(fileURLWithPath: NSTemporaryDirectory())
    private var disk: DiskStorage!
    private var storage: CodableStorage!
    
    init() {
        disk = DiskStorage(path: path)
        storage = CodableStorage(storage: disk)
    }
    
    public var namespaces : [NameSpacesBusinessModel.Namespace]? {
        get { return try? storage.fetch(for: "namespaces_cache") }
        set { try? storage.save(newValue, for: "namespaces_cache") }
    }
    
    public var threads : [ChatsBusinessModel.Chat] {
        get { return (try? storage.fetch(for: "threads_cache")) ?? [] }
        set { try? storage.save(newValue, for: "threads_cache") }
    }
    
    public func clear() {
        namespaces = nil
        threads = []
    }
    
}
