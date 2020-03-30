//
//  SendMessageBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-26.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import SocketIO

struct OutgoingMessageBusinessModel: SocketData {
    
    let namespace_id: String
    let user_id: String?
    let message: String
    
    func socketRepresentation() -> SocketData {
        var data = ["namespace_id" : namespace_id, "message" : message]
        if let user_id = user_id { data["user_id"] = user_id }
        return data
    }
    
}
