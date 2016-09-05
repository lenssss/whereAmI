//
//  DBUser+CoreDataProperties.swift
//  Whereami
//
//  Created by 陈鹏宇 on 16/7/6.
//  Copyright © 2016年 WuQifei. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DBUser {

    @NSManaged var account: String?
    @NSManaged var backpictureId: String?
    @NSManaged var battles: NSNumber?
    @NSManaged var comments: NSNumber?
    @NSManaged var commits: NSNumber?
    @NSManaged var countryCode: String?
    @NSManaged var countryName: String?
    @NSManaged var dan: NSNumber?
    @NSManaged var headPortraitUrl: String?
    @NSManaged var id: String?
    @NSManaged var inBattles: NSNumber?
    @NSManaged var lastLogin: NSDate?
    @NSManaged var level: NSNumber?
    @NSManaged var levelUpPersent: NSNumber?
    @NSManaged var loss: NSNumber?
    @NSManaged var nextPoint: NSNumber?
    @NSManaged var nickname: String?
    @NSManaged var points: NSNumber?
    @NSManaged var quits: NSNumber?
    @NSManaged var releases: NSNumber?
    @NSManaged var right: NSNumber?
    @NSManaged var sessionId: String?
    @NSManaged var status: NSNumber?
    @NSManaged var wins: NSNumber?
    @NSManaged var wrong: NSNumber?

}
