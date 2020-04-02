//
//  ThreadsCacheManager.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-02.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class ThreadsCacheManager: NSObject {
    
    static let shared = ThreadsCacheManager()
    
    var threads : [ChatsBusinessModel.Chat] {
        get {
            guard let data = UserDefaults.standard.value(forKey: "threads") as? Data else { return [] }
            guard let threads = try? JSONDecoder().decode([ChatsBusinessModel.Chat].self, from: data) else { return [] }
            return threads
        }
        set {
            let data = try? JSONEncoder().encode(newValue.self)
            UserDefaults.standard.set(data, forKey: "threads")
        }
    }
    
    func clear() {
        threads = []
    }
    
}
