//
//  AuthenticateBusinessModel.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-26.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation
import SocketIO

struct AuthenticateBusinessModel: SocketData {
    
    let session: String
    
    func socketRepresentation() -> SocketData {
        return ["session" : session]
    }
    
}
