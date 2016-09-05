//
//  FriendsModel.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/11.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class FriendsModel: NSObject {
    var accountId: String?
    var friendId: String?
    var headPortrait: String?
    var onLine: NSNumber?
    var nickname: String?
    
    static func modelFromDBModel(dbModel:DBFriends)->(FriendsModel) {
        let friends = FriendsModel()
        friends.accountId = dbModel.accountId
        friends.friendId = dbModel.friendId
        friends.headPortrait = dbModel.headPortrait
        friends.onLine = dbModel.onLine
        friends.nickname = dbModel.nickname
        
        return friends
    }
    
    class func getModelFromObject(objs:AnyObject) -> [FriendsModel] {
        let accountList = objs[0]["friends"] as! [AnyObject]
        return self.getModelFromArray(accountList)
    }
    
    class func getModelFromArray(accountList:[AnyObject]) -> [FriendsModel] {
        var modelList = [FriendsModel]()
        for item in accountList {
            print("=================\(item)")
            let dic = item as! [String:AnyObject]
            let model = FriendsModel()
            model.accountId = UserModel.getCurrentUser()?.id
            model.friendId = dic["accountId"] as? String
            model.nickname = dic["nickname"] as? String
            model.onLine = dic["onLine"] as? NSNumber
            model.headPortrait = dic["headPortrait"] as? String
            modelList.append(model)
        }
        return modelList
    }
    
    class func getModelFromUser(user:UserModel) -> FriendsModel{
        let friend = FriendsModel()
        friend.accountId = UserModel.getCurrentUser()?.id
        friend.friendId = user.id
        friend.nickname = user.nickname
        friend.headPortrait = user.headPortraitUrl
        return friend
    }
    
    class func getFriendById(accountId:String,friendId:String) -> FriendsModel?{
        let model = CoreDataManager.sharedInstance.fetchFriendByFriendId(accountId, friendId: friendId)
        if model != nil {
            return model
        }
        else{
            return nil
        }
    }
    
}
