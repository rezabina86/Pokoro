//
//  Messages.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-04.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

protocol Messages: Hashable {
    
    var id: String { get set }
    var userId: String? { get set }
    var message: String? { get set }
    var lastMessageId: String? { get set }
    var timestamp: Int64 { get set }
    var isSeen: Bool { get set }
    
    init(socketMessage: IncomeMessageBusinessModel)
    init(apiResponse: ThreadBusinessModel.Message)
    init(lastMessage: ChatsBusinessModel.LastMessage)
}

extension Messages {
    var isIncomeMessage: Bool {
        return userId != PKUserManager.shared.userId
    }
    
    var stringDate: String? {
        return Date(timeIntervalSince1970: TimeInterval(self.timestamp / 1000)).stringFormat
    }
}
