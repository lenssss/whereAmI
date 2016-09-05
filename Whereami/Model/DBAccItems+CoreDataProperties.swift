//
//  DBAccItems+CoreDataProperties.swift
//  Whereami
//
//  Created by 陈鹏宇 on 16/8/2.
//  Copyright © 2016年 WuQifei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DBAccItems {

    @NSManaged var accountId: String?
    @NSManaged var itemCode: String?
    @NSManaged var itemName: String?
    @NSManaged var itemNum: NSNumber?

}
