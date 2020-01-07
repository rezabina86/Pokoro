//
//  DemoMessagesBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-01-07.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import UIKit

struct DemoMessagesBusinessModel {
    
    struct Message: Codable {
        let message: String
    }
    
    struct Thread: Codable {
        let id: Int
        let barcodeName: String
        let messages: [Message]
    }
    
    struct Threads: Codable {
        let threads: [Thread]
    }
    
}
