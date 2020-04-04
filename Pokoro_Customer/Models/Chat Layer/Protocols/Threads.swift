//
//  Threads.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-04.
//  Copyright © 2020 Reza Bina. All rights reserved.
//

import Foundation

protocol Threads {
    
    associatedtype M: Messages
    var id: String { get set }
    var userId: String? { get set }
    var userName: String? { get set }
    var timeStamp: Int64 { get set }
    var namespaceId: String? { get set }
    var namespaceName: String? { get set }
    var hasUnseenMessage: Bool { get set }
    var nameSpaceOwner: String? { get set }
    var lastMessage: M? { get set }
    
    init(apiResponse: ChatsBusinessModel.Chat)
    init(incomeMessage: IncomeMessageBusinessModel)
    init(namespace: CheckNamespaceBusinessModel.Fetch.Response)
}

extension Threads {
    var stringDate: String? {
        return Date(timeIntervalSince1970: TimeInterval(timeStamp / 1000)).stringFormat
    }
    
    var lastMessageDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(timeStamp / 1000))
    }
    
    var isThreadTemp: Bool {
        return id.count == 0
    }
    
    var isUserOwnerOfTheNamespace: Bool {
        guard let ownerId = nameSpaceOwner, let userId = PKUserManager.shared.userId else { return false }
        return ownerId == userId
    }

}
