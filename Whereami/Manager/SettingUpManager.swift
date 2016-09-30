//
//  SettingUpManager.swift
//  Whereami
//
//  Created by WuQifei on 16/2/4.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import MagicalRecord
import SVProgressHUD
import SocketIOClientSwift

public var KNotificationLogin: String { get{ return "KNotificationLogin"} }
public var KNotificationGetRemind: String { get{ return "KNotificationGetRemind"} }
public var KNotificationGetLevelupedremind: String { get{ return "KNotificationgetLevelupedremind"} }
public var KNotificationGetDanupedremind: String { get{ return "KNotificationGetDanupedremind"} }

enum statusCode:Int {
    case Normal = 200 //正常
    case Complete = 100 // 完成
    case Overtime = 300 //超时
    case Unfinished = 400 //未完成
    case Error = 500 //错误
}

class SettingUpManager: NSObject {
    private static var instance:SettingUpManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    class var sharedInstance: SettingUpManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = SettingUpManager()
        }
        return instance!
    }
    
    func launch(application:UIApplication,launchOptions: [NSObject: AnyObject]?) {
        
        //注册coredata数据库
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("whereami.sqlite")
        
        //注册通知
        let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes:[.Alert,.Badge,.Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        //连接socket
        SocketManager.sharedInstance.connection { (ifConnected:Bool) -> Void in
            if ifConnected{
                print("succeed")
                
                SocketManager.sharedInstance.getMsg("remindother", callBack: { (code, objs) in
                    NSNotificationCenter.defaultCenter().postNotificationName(KNotificationGetRemind, object: code,userInfo: ["question":objs])
                })
                
                SocketManager.sharedInstance.getMsg("levelupedremind", callBack: { (code, objs) in
                    if code == statusCode.Normal.rawValue {
                        NSNotificationCenter.defaultCenter().postNotificationName(KNotificationGetLevelupedremind, object: objs)
                    }
                })
                
                SocketManager.sharedInstance.getMsg("danupedremind", callBack: { (code, objs) in
                    if code == statusCode.Normal.rawValue {
                        NSNotificationCenter.defaultCenter().postNotificationName(KNotificationGetDanupedremind, object: objs)
                    }
                })
         
                let sessionId = LUserDefaults().objectForKey("sessionId") as? String
                if sessionId != nil {
                    let model = CoreDataManager.sharedInstance.fetchUser(sessionId!)
                    if model != nil {
                        var dict = [String:AnyObject]()
                        dict["sessionId"] = model?.sessionId
                        SocketManager.sharedInstance.sendMsg("autoLogin", data: dict, onProto: "logined", callBack: { (code, objs) -> Void in
                            if code == statusCode.Normal.rawValue {
                                
                                let dic = objs[0] as! [String:AnyObject]
                                let userData:[AnyObject] = dic["userData"] as! [AnyObject]
                                let modelDic = userData[0] as! [String:AnyObject]
                                let userModel = UserModel.getModelFromDictionary(modelDic)
                                
                                CoreDataManager.sharedInstance.increaseOrUpdateUser(userModel)
                                let userDefaults = LUserDefaults()
                                userDefaults.setObject(userModel.sessionId, forKey: "sessionId")
                                userDefaults.synchronize()
                                print("autoLogin succeed")
                                
                                self.getCountryOpendMsg()
                                self.getAllKindsOfGame()
                                self.getAccItems()
                                self.gainItems()
                                self.registAVClient(userModel)
                            }
                            else{
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    SVProgressHUD.showErrorWithStatus("please login")
                                    self.change2ChooseLoginVC()
                                })
                            }
                        })
                    }
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(KNotificationLogin, object: nil).subscribeNext { (notification) -> Void in
            let user = notification.object as! UserModel
            self.registAVClient(user)
            self.getCountryOpendMsg()
            self.getFreinds(user.id!)
            self.getAllKindsOfGame()
            self.getAccItems()
            self.gainItems()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                LocationManager.sharedInstance.setupLocation()
                self.change2CustomTabbarVC()
            })
        }
        
        LeanCloudManager.sharedInstance.setupApplication()
        
    }
    
    //注册聊天client
    func registAVClient(currentUsr:UserModel) {
        let clientId = currentUsr.id
        LeanCloudManager.sharedInstance.openSessionWithClientId(clientId!) { (succeed, error) in
            if !succeed {
                print("failed to register a client");
            }
        }
    }
    
    //获取国家开放信息
    func getCountryOpendMsg(){
        var dict = [String:AnyObject]()
        dict["id"] = ""
        print("=================\(dict)")
        SocketManager.sharedInstance.sendMsg("getCountryOpendMsg", data: dict, onProto: "getCountryOpendMsged", callBack: { (code, objs) -> Void in
            if code == statusCode.Normal.rawValue {
                print("====================\(objs)")
                FileManager.sharedInstance.countryListWriteToFile(objs)
            }
        })
    }
    
    //获取所有游戏类型
    func getAllKindsOfGame(){
        var dict = [String:AnyObject]()
        dict["id"] = UserModel.getCurrentUser()?.id
        SocketManager.sharedInstance.sendMsg("getAllKindsOfGame", data: dict, onProto: "getAllKindsOfGameed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                print("====================\(objs)")
                FileManager.sharedInstance.gameKindListWriteToFile(objs)
            }
        }
    }
    
    //获取所有好友
    func getFreinds(id:String){
        var dict = [String:AnyObject]()
        dict["accountId"] = id
        dict["nickname"] = ""
        SocketManager.sharedInstance.sendMsg("getFreinds", data: dict, onProto: "getFreindsed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let accountList = FriendsModel.getModelFromObject(objs)
                for item in accountList {
                    CoreDataManager.sharedInstance.increaseFriends(item)
                }
            }
        }
    }
    
    //获取个人道具数量
    func getAccItems(){
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id

        SocketManager.sharedInstance.sendMsg("queryAccItems", data: dict, onProto: "queryAccItemsed") { (code, objs) in
            if code == statusCode.Normal.rawValue{
                let dic = objs[0] as? [String:AnyObject]
                guard let arr = dic!["items"] as? [AnyObject] else{
                    return
                }
                let items = AccItems.getModelFromArray(arr)
                for item in items! {
                    CoreDataManager.sharedInstance.increaseOrUpdateAccItem(item)
                }
            }
        }
    }

    //获取道具列表
    func gainItems(){
        var arr = LUserDefaults().objectForKey("gainItems") as? [NSData]
        guard arr != nil && arr?.count != 0 else {
            return
        }
        for item in arr! {
            do {
                let json = item
                let dict = try NSJSONSerialization.JSONObjectWithData(json, options: .MutableContainers) as! [String:AnyObject]
                SocketManager.sharedInstance.sendMsg("gainItems", data: dict, onProto: "gainItemsed") { (code, objs) in
                    if code == statusCode.Normal.rawValue {
                        for (index, value) in arr!.enumerate() {
                            if value.isEqual(json) {
                                arr?.removeAtIndex(index)
                                LUserDefaults().setObject(arr, forKey: "gainItems")
                                break
                            }
                        }
                        self.getAccItems()
                    }
                }
            }catch{
                print("gainItems error")
            }
        }
    }
    
    //跳转登陆
    func change2ChooseLoginVC(){
        let currentWindow = (LApplication().delegate!.window)!
        currentWindow!.rootViewController = LoginNavViewController(rootViewController: ChooseLoginItemViewController())
    }
    
    //跳转主页
    func change2CustomTabbarVC(){
        let currentWindow = (LApplication().delegate!.window)!
        currentWindow!.rootViewController = CustomTabBarViewController()
    }
    
}
