//
//  UserManager.swift
//  Whereami
//
//  Created by A on 16/4/14.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

typealias userCallback = (UserModel) -> Void

public var KNotificationGetUser: String { get{ return "KNotificationGetUser"} }

class UserManager: NSObject {
    private static var instance:UserManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    class var sharedInstance: UserManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = UserManager()
        }
        return instance!
    }
    
    func getUserById(id:String)->UserModel{
        let dbUser = CoreDataManager.sharedInstance.fetchUserById(id)
        if dbUser == nil {
            
            let user = UserModel()
            user.id = id;
            user.nickname = "..."
            user.headPortraitUrl = ""
            
            self.getUserfromRemote(id,completition: nil)
            return user
        }
        else{
            self.getUserfromRemote(id,completition: nil)
            return dbUser!
        }
    }
    
    func getUserByIdWithBlock(id:String,completition:userCallback) -> UserModel{
        let dbUser = CoreDataManager.sharedInstance.fetchUserById(id)
        if dbUser == nil {
            
            let user = UserModel()
            user.id = id;
            user.nickname = "..."
            user.headPortraitUrl = ""
            
            self.getUserfromRemote(id,completition: completition)
            return user
        }
        else{
            completition(dbUser!)
            self.getUserfromRemote(id,completition: nil)
            return dbUser!
        }
    }
    
    func getUserfromRemote(id:String,completition:userCallback?) {
        var dict = [String:AnyObject]()
        dict["searchIds"] = [id]
        SocketManager.sharedInstance.sendMsg("getUserDatasByUserIds", data: dict, onProto: "getUserDatasByUserIdsed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let userData = objs[0]["userData"] as? [AnyObject]
                let userDic = userData![0]
                let user = UserModel.getModelFromDictionaryById(userDic as! NSDictionary)
                
                CoreDataManager.sharedInstance.increaseOrUpdateUser(user)
                
                if completition != nil{
                    completition!(user)
                }
            }
        }

    }
}
