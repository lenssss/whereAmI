//
//  DBPhoto+CoreDataProperties.swift
//  Whereami
//
//  Created by A on 16/5/3.
//  Copyright © 2016年 WuQifei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DBPhoto {

    @NSManaged var id: String?
    @NSManaged var content: String?
    @NSManaged var ginwave: String?
    @NSManaged var accountId: String?
    @NSManaged var geoDes: String?

}
