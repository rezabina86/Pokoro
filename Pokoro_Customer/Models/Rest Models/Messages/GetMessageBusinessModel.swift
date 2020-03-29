//
//  GetMessageBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-26.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import SocketIO

struct IncomeMessageBusinessModel: Decodable {
    
    let id: String
    let chat_id: String
    let user_id: String
    let namespace_id: String
    let message: String
    let timestamp: Date
    let last_message_id: String?
    
}
