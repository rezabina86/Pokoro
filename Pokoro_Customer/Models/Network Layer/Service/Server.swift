//
//  Server.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-20.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

class Server: NSObject {
    
    static var baseURL: URL { return URL(string: "https://api.pokoro.app")! }
    static var apiURL: URL! { return Server.baseURL.appendingPathComponent("/api/v1") }
    static var socketURL: URL! { return Server.baseURL }
    
}
