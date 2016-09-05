//
//  DBFriends+CoreDataProperties.swift
//  Whereami
//
//  Created by A on 16/3/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DBFriends {

    @NSManaged var accountId: String?
    @NSManaged var friendId: String?
    @NSManaged var headPortrait: String?
    @NSManaged var onLine: NSNumber?
    @NSManaged var nickname: String?

}
