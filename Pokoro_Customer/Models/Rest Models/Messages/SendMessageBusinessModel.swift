//
//  SendMessageBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-26.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import SocketIO

struct SendMessageBusinessModel: SocketData {
    
    let namespace_id: String
    let user_id: String
    let message: String
    
    func socketRepresentation() -> SocketData {
        return ["namespace_id" : namespace_id, "user_id" : user_id, "message" : message]
    }
    
}
