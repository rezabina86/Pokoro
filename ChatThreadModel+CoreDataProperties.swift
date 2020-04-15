//
//  ChatThreadModel+CoreDataProperties.swift
//  Pokoro_Customer
//
//  Created by Reza Bina on 2020-04-15.
//  Copyright © 2020 Reza Bina. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatThreadModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatThreadModel> {
        return NSFetchRequest<ChatThreadModel>(entityName: "ChatThreadModel")
    }

    @NSManaged public var id: String?
    @NSManaged public var userId: String?
    @NSManaged public var userName: String?
    @NSManaged public var timeStamp: Int64
    @NSManaged public var namespaceId: String?
    @NSManaged public var namespaceName: String?
    @NSManaged public var numberOfUnreadMessages: Int64
    @NSManaged public var nameSpaceOwner: String?
    @NSManaged public var threadDate: Date?
    @NSManaged public var lastMessage: ChatMessageModel?

}
