//
//  NamespacesCacheManager.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-27.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class NamespacesCacheManager: NSObject {
    
    static let shared = NamespacesCacheManager()
    
    var namespaces : [NameSpacesBusinessModel.Namespace]? {
        get {
            guard let data = UserDefaults.standard.value(forKey: "namespacesCache") as? Data else { return nil }
            return try? JSONDecoder().decode([NameSpacesBusinessModel.Namespace].self, from: data)
        }
        set {
            let data = try? JSONEncoder().encode(newValue.self)
            UserDefaults.standard.set(data, forKey: "namespacesCache")
        }
    }
    
    func clear() {
        namespaces = nil
    }
    
}
