//
//  CoreDataManager.swift
//  Whereami
//
//  Created by WuQifei on 16/2/24.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import MagicalRecord

typealias theCallback = () -> Void

@objc(CoreDataManager)
class CoreDataManager: NSObject {
    private static var instance:CoreDataManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    class var sharedInstance: CoreDataManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = CoreDataManager()
        }
        return instance!
    }
    
    func fetchAllUser() -> ([UserModel]?){
        let users = DBUser.MR_findAll()
        var models = [UserModel]()
        if users == nil || users!.count == 0 {
            return nil
        } else {
            for item in users! {
                let dbItem = item as! DBUser
                let model = UserModel.modelFromDBModel(dbItem)
                models.append(model)
            }
            return models
        }
    }
    
    func fetchUser(sessionId:String) -> (UserModel?){
//        let userFilter = NSPredicate(format: "sessionId == %@",sessionId)
//        let dbUser = DBUser.MR_findFirstWithPredicate(userFilter)
        let dbUser = DBUser.MR_findFirstByAttribute("sessionId", withValue: sessionId)
        if dbUser == nil {
            return nil
        }
        return UserModel.modelFromDBModel(dbUser!)
    }
    
    func fetchUserById(accountId:String) -> UserModel? {
        let userFilter = NSPredicate(format: "id == %@",accountId)
        let user = DBUser.MR_findFirstWithPredicate(userFilter)
        if user == nil {
            return nil
        }
        return UserModel.modelFromDBModel(user!)
    }
    
    func increaseOrUpdateUser(model:UserModel){
        var dbUser = DBUser.MR_findFirstByAttribute("id", withValue: model.id!)
        if dbUser == nil {
            dbUser = DBUser.MR_createEntity()
            dbUser!.account = model.account
            dbUser!.backpictureId = model.backPictureUrl
            dbUser!.battles = model.battles
            dbUser!.comments = model.comments
            dbUser!.commits = model.commits
            dbUser!.countryCode = model.countryCode
            dbUser!.countryName = model.countryName
            dbUser!.dan = model.dan
            dbUser!.headPortraitUrl = model.headPortraitUrl
            dbUser!.id = model.id
            dbUser!.lastLogin = model.lastLogin
            dbUser!.level = model.level
            dbUser?.levelUpPersent = model.levelUpPersent
            dbUser?.loss = model.loss
            dbUser?.nextPoint = model.nextPoint
            dbUser!.nickname = model.nickname
            dbUser!.points = model.points
            dbUser!.quits = model.quits
            dbUser?.releases = model.releases
            dbUser!.right = model.right
            dbUser!.sessionId = model.sessionId
            dbUser!.wrong = model.wrong
            dbUser!.status = model.status
            dbUser!.wins = model.wins
            let context = dbUser?.managedObjectContext
            context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
                if succeed {
                    
                }
            })
        }
        else{
            dbUser!.account = model.account
            dbUser!.backpictureId = model.backPictureUrl
            dbUser!.battles = model.battles
            dbUser!.comments = model.comments
            dbUser!.commits = model.commits
            dbUser!.countryCode = model.countryCode
            dbUser!.countryName = model.countryName
            dbUser!.dan = model.dan
            dbUser!.headPortraitUrl = model.headPortraitUrl
            dbUser!.lastLogin = model.lastLogin
            dbUser!.level = model.level
            dbUser?.levelUpPersent = model.levelUpPersent
            dbUser?.loss = model.loss
            dbUser?.nextPoint = model.nextPoint
            dbUser!.nickname = model.nickname
            dbUser!.points = model.points
            dbUser!.quits = model.quits
            dbUser?.releases = model.releases
            dbUser!.right = model.right
            dbUser!.sessionId = model.sessionId
            dbUser!.wrong = model.wrong
            dbUser!.status = model.status
            dbUser!.wins = model.wins
            let context = dbUser?.managedObjectContext
            context?.MR_saveToPersistentStoreAndWait()
        }
    }
    
    
    func deleteUser(account:String) {
        let dbConversation = DBConversation.MR_findFirstByAttribute("account", withValue: account)
        if dbConversation != nil {
            dbConversation!.MR_deleteEntity()
        }
    }
    
    func fetchAllFriends() -> ([FriendsModel]?){
        let id = UserModel.getCurrentUser()?.id
        let friendFilter = NSPredicate(format: "accountId == %@",id!)
        let friends = DBFriends.MR_findAllWithPredicate(friendFilter)
        var models = [FriendsModel]()
        if friends == nil || friends!.count == 0 {
            return models
        } else {
            for item in friends! {
                let dbItem = item as! DBFriends
                let model = FriendsModel.modelFromDBModel(dbItem)
                models.append(model)
            }
            return models
        }
    }
    
    func fetchFriendByNickName(accountId:String,nickname:String) -> [FriendsModel]? {
        let likeStr = "*a*"
        let friendFilter = NSPredicate(format: "accountId == %@ AND nickname like[cd] %@",accountId,likeStr)
        var models = [FriendsModel]()
        let friends = DBFriends.MR_findAllWithPredicate(friendFilter)
        if friends == nil || friends!.count == 0 {
            return nil
        }
        else{
            for item in friends! {
                let dbItem = item as! DBFriends
                let model = FriendsModel.modelFromDBModel(dbItem)
                models.append(model)
            }
            return models
        }
    }
    
    func fetchFriendByFriendId(accountId:String,friendId:String) -> FriendsModel? {
        let friendFilter = NSPredicate(format: "accountId == %@ AND friendId == %@",accountId,friendId)
        let friend = DBFriends.MR_findFirstWithPredicate(friendFilter)
        if friend == nil {
            return nil
        }
        return FriendsModel.modelFromDBModel(friend!)
    }
    
    func increaseFriends(model:FriendsModel){
        let friendFilter = NSPredicate(format: "accountId == %@ AND friendId == %@",model.accountId!,model.friendId!)
        var dbFriends = DBFriends.MR_findFirstWithPredicate(friendFilter)
        if dbFriends == nil {
            dbFriends = DBFriends.MR_createEntity()
            dbFriends!.accountId = model.accountId
            dbFriends!.friendId = model.friendId
            dbFriends!.headPortrait = model.headPortrait
            dbFriends!.onLine = model.onLine
            dbFriends!.nickname = model.nickname
            let context = dbFriends?.managedObjectContext
            context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
                if succeed {
                    
                }
            })
        }
        else{
            dbFriends!.headPortrait = model.headPortrait
            dbFriends!.onLine = model.onLine
            dbFriends!.nickname = model.nickname
            let context = dbFriends?.managedObjectContext
            context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
                if succeed {
                    
                }
            })
        }
    }
    
    func deleteFriends(accountId:String,friendId:String) {
        let friendFilter = NSPredicate(format: "accountId == %@ AND friendId == %@",accountId,friendId)
        let dbFriends = DBFriends.MR_findFirstWithPredicate(friendFilter)
        if dbFriends != nil {
            dbFriends!.MR_deleteEntity()
        }
        let context = dbFriends?.managedObjectContext
        context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
            if succeed {
                
            }
        })
    }
    
    func increasePhoto(model:PhotoModel){
        var dbPhoto = DBPhoto.MR_findFirstByAttribute("id", withValue: model.id!)
        if dbPhoto == nil {
            dbPhoto = DBPhoto.MR_createEntity()
            dbPhoto?.id = model.id
            dbPhoto?.accountId = model.accountId
            dbPhoto?.content = model.file
            dbPhoto?.ginwave = model.ginwave
            dbPhoto?.geoDes = model.geoDes
            let context = dbPhoto?.managedObjectContext
            context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
                if succeed {
                    
                }
            })
        }
    }
    
    func fetchPhotoById(id:String) -> PhotoModel? {
        let dbPhoto = DBPhoto.MR_findFirstByAttribute("id", withValue: id)
        if dbPhoto == nil {
            return nil
        }
        return PhotoModel.modelFromDBModel(dbPhoto!)
    }
    
    func deleteAllPhotos(completion:theCallback) {
        let dbPhotos = DBPhoto.MR_findAll()
        if dbPhotos != nil {
            for item in dbPhotos! {
                item.MR_deleteEntity()
            }
        }
        let context = NSManagedObjectContext.MR_defaultContext()
        context.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
            if succeed {
                
            }
            completion()
        })
    }
    
    func increaseOrUpdateAccItem(model:AccItems){
        let accountFilter = NSPredicate(format: "accountId == %@",model.accountId!)
        var dbItem = DBAccItems.MR_findFirstWithPredicate(accountFilter)
        if dbItem == nil {
            dbItem = DBAccItems.MR_createEntity()
            dbItem!.accountId = model.accountId
            dbItem?.itemCode = model.itemCode
            dbItem?.itemName = model.itemName
            dbItem?.itemNum = model.itemNum
            let context = dbItem?.managedObjectContext
            context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
                if succeed {
                    
                }
            })
        }
        else{
            dbItem?.itemCode = model.itemCode
            dbItem?.itemName = model.itemName
            dbItem?.itemNum = model.itemNum
            let context = dbItem?.managedObjectContext
            context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
                if succeed {
                    
                }
            })
        }
    }
    
    func fetchItemByIdAndCode(id:String,code:String) -> AccItems? {
        let accountFilter = NSPredicate(format: "accountId == %@ AND itemCode == %@",id,code)
        let dbItem = DBAccItems.MR_findFirstWithPredicate(accountFilter)
        if dbItem == nil {
            return nil
        }
        return AccItems.modelFromDBModel(dbItem!)
    }
    
    func fetchItemById(id:String) -> [AccItems]? {
        let accountFilter = NSPredicate(format: "accountId == %@",id)
        let dbItems = DBAccItems.MR_findAllWithPredicate(accountFilter)
        var models = [AccItems]()
        if dbItems == nil || dbItems!.count == 0  {
            return nil
        }
        else{
            for item in dbItems! {
                let dbItem = item as! DBAccItems
                let model = AccItems.modelFromDBModel(dbItem)
                models.append(model)
            }
            return models
        }
    }
    
    func consumeLifeItem(){
        let currentUser = UserModel.getCurrentUser()?.id
        let item = CoreDataManager.sharedInstance.fetchItemByIdAndCode(currentUser!, code: "life")
        guard item != nil else {
            return
        }
        item?.itemNum = (item?.itemNum)! - 1
        CoreDataManager.sharedInstance.increaseOrUpdateAccItem(item!)
    }
}
