//
//  ChatMessageModel+CoreDataProperties.swift
//  
//
//  Created by Reza Bina on 2020-04-06.
//
//

import Foundation
import CoreData


extension ChatMessageModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMessageModel> {
        return NSFetchRequest<ChatMessageModel>(entityName: "ChatMessageModel")
    }

    @NSManaged public var id: String?
    @NSManaged public var chatId: String?
    @NSManaged public var userId: String?
    @NSManaged public var message: String?
    @NSManaged public var lastMessageId: String?
    @NSManaged public var timestamp: Int64
    @NSManaged public var isSeen: Bool
    @NSManaged public var messageDate: Date?

}
