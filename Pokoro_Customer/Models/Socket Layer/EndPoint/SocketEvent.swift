//
//  SocketEndPoint.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-03-26.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation
import SocketIO

enum SocketEvent {
    case authentication
    case sendMessage
    case getMessage
    case seenMessage
    case authenticated
    case sentMessage
}

extension SocketEvent: SocketEventType {
    
    var event: String {
        switch self {
        case .authentication:
            return "authentication"
        case .getMessage:
            return "get_message"
        case .sendMessage:
            return "send_message"
        case .seenMessage:
            return "seen_message"
        case .authenticated:
            return "authenticated"
        case .sentMessage:
            return "sent_message"
        }
    }
    
}
