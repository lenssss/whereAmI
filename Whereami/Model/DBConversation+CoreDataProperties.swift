//
//  DBConversation+CoreDataProperties.swift
//  Whereami
//
//  Created by A on 16/5/24.
//  Copyright © 2016年 WuQifei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DBConversation {

    @NSManaged var conversationId: String?
    @NSManaged var guestId: String?
    @NSManaged var hostId: String?
    @NSManaged var lastTime: NSDate?
    @NSManaged var lattestMsg: String?
    @NSManaged var unreadCount: NSNumber?

}
