//
//  SeenMessageBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-26.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import SocketIO

struct SeenMessageBusinessModel: SocketData {
    
    let chat_id: String
    let message_id: String
    
    func socketRepresentation() -> SocketData {
        return ["chat_id" : chat_id, "message_id" : message_id]
    }
    
}
