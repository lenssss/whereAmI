//
//  UserModel.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/11.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    var account: String?
    var sessionId: String?
    var comments: NSNumber?
    var commits: NSNumber?
    var countryCode: String?
    var countryName: String?
    var dan: NSNumber?
    var headPortraitUrl: String?
    var id: String?
    var lastLogin: NSDate?
    var level: NSNumber?
    var nickname: String?
    var points: NSNumber?
    var battles: NSNumber?
    var quits: NSNumber?
    var wins: NSNumber?
    var loss:NSNumber?
    var right: NSNumber?
    var wrong: NSNumber?
    var status: NSNumber?
    var nextPoint: NSNumber?
    var levelUpPersent: NSNumber?
    var inBattles: NSNumber?
    var releases: NSNumber?
    var backPictureUrl:String?

    
    static func modelFromDBModel(dbmodel:DBUser)->(UserModel){
        let user = UserModel()
        user.account = dbmodel.account
        user.battles = dbmodel.battles
        user.comments = dbmodel.comments
        user.commits = dbmodel.commits
        user.countryCode = dbmodel.countryCode
        user.countryName = dbmodel.countryName
        user.dan = dbmodel.dan
        user.headPortraitUrl = dbmodel.headPortraitUrl
        user.id = dbmodel.id
        user.lastLogin = dbmodel.lastLogin
        user.level = dbmodel.level
        user.nickname = dbmodel.nickname
        user.points = dbmodel.points
        user.quits = dbmodel.quits
        user.right = dbmodel.right
        user.sessionId = dbmodel.sessionId
        user.wrong = dbmodel.wrong
        user.status = dbmodel.status
        user.wins = dbmodel.wins
        user.loss = dbmodel.loss
        user.nextPoint = dbmodel.nextPoint
        user.levelUpPersent = dbmodel.levelUpPersent
        user.inBattles = dbmodel.inBattles
        user.releases = dbmodel.releases
        user.backPictureUrl = dbmodel.backpictureId
        
        return user
    }
    
    class func getModelFromDictionary(dic:NSDictionary) -> UserModel{
        let userModel = UserModel()
        userModel.account = dic["account"] as? String
        userModel.sessionId = dic["lastSession"] as? String
        userModel.comments = dic["comments"] as? NSNumber
        userModel.commits = dic["commits"] as? NSNumber
        userModel.countryCode = dic["countryCode"] as? String
        userModel.countryName = dic["countryName"] as? String
        userModel.dan = dic["dan"] as? NSNumber
        userModel.headPortraitUrl = dic["headPortrait"] as? String
        userModel.id = dic["_id"] as? String
        userModel.level = dic["level"] as? NSNumber
        userModel.nickname = dic["nickname"] as? String
        userModel.points = dic["points"] as? NSNumber
        userModel.battles = dic["battles"] as? NSNumber
        userModel.quits = dic["quits"] as? NSNumber
        userModel.wins = dic["wins"] as? NSNumber
        userModel.loss = dic["loss"] as? NSNumber
        userModel.right = dic["right"] as? NSNumber
        userModel.wrong = dic["wrong"] as? NSNumber
        userModel.status = dic["status"] as? NSNumber
        userModel.nextPoint = dic["nextPoint"] as? NSNumber
        userModel.levelUpPersent = dic["levelUpPersent"] as? NSNumber
        userModel.inBattles = dic["inBattles"] as? NSNumber
        userModel.releases = dic["releases"] as? NSNumber
        userModel.backPictureUrl = dic["backpictureUrl"] as? String
        print(dic["lastLogin"])
        print(NSNull())
        if ((dic["lastLogin"]!.isEqual(NSNull())) == false) {
            let dateStr = "\(dic["lastLogin"]!)"
            let lastLogin = NSDate.string2Date(dateStr)
            userModel.lastLogin = lastLogin
        }
        return userModel
    }
    
    class func getModelFromDictionaryById(dic:NSDictionary)->UserModel {
        let userModel = UserModel()
        userModel.id = dic["_id"] as? String
        userModel.account = dic["account"] as? String
        userModel.sessionId = dic["lastSession"] as? String
        userModel.headPortraitUrl = dic["headPortrait"] as? String
        userModel.countryCode = dic["countryCode"] as? String
        userModel.countryName = dic["countryName"] as? String
        userModel.comments = dic["comments"] as? NSNumber
        userModel.commits = dic["commits"] as? NSNumber
        userModel.dan = dic["dan"] as? NSNumber
        userModel.level = dic["level"] as? NSNumber
        userModel.nickname = dic["nickname"] as? String
        userModel.points = dic["points"] as? NSNumber
        userModel.battles = dic["battles"] as? NSNumber
        userModel.quits = dic["quits"] as? NSNumber
        userModel.wins = dic["wins"] as? NSNumber
        userModel.loss = dic["loss"] as? NSNumber
        userModel.right = dic["right"] as? NSNumber
        userModel.wrong = dic["wrong"] as? NSNumber
        userModel.nextPoint = dic["nextPoint"] as? NSNumber
        userModel.levelUpPersent = dic["levelUpPersent"] as? NSNumber
        userModel.inBattles = dic["inBattles"] as? NSNumber
        userModel.releases = dic["releases"] as? NSNumber
        userModel.backPictureUrl = dic["backpictureUrl"] as? String
        return userModel
    }
    
    class func getModelFromFriend(friend:FriendsModel) -> UserModel{
        let userModel = UserModel()
        userModel.id = friend.friendId
        userModel.nickname = friend.nickname
        return userModel
    }
    
    class func getCurrentUser() -> UserModel?{
        let sessionId = LUserDefaults().objectForKey("sessionId") as? String
        
        guard sessionId != nil else{
            return nil
        }
        
        guard let model = CoreDataManager.sharedInstance.fetchUser(sessionId!) else{
            return nil
        }
        return model
    }
}
