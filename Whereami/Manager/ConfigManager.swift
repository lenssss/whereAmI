
//
//  ConfigManager.swift
//  Whereami
//
//  Created by A on 16/4/19.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

public func LNotificationCenter() -> NSNotificationCenter {
    return NSNotificationCenter.defaultCenter()
}

public func LUserDefaults() -> NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
}

public func LApplication() -> UIApplication {
    return UIApplication.sharedApplication()
}

public func LFileManager() -> NSFileManager {
    return NSFileManager.defaultManager()
}

public func LDevice() -> UIDevice {
    return UIDevice.currentDevice()
}

public func LScreen() -> UIScreen {
    return UIScreen.mainScreen()
}

public var LScreenH:CGFloat {get{return UIScreen.mainScreen().bounds.size.height}}
public var LScreenW:CGFloat {get{return UIScreen.mainScreen().bounds.size.width}}
public var LScreenBounds:CGRect {get{return UIScreen.mainScreen().bounds}}

public var KNotificationMainViewWillShow: String { get{ return "KNotificationMainViewWillShow"} }
public var KNotificationMainViewDidShow: String { get{ return "KNotificationMainViewDidShow"} }
public var KNotificationDismissSearchView: String { get{ return "KNotificationDismissSearchView"} }
public var KNotificationPushToBattleDetailsVC: String { get{ return "KNotificationPushToBattleDetailsVC"} }
public var KNotificationLoginVCWillShow: String { get{ return "KNotificationLoginVCWillShow"} }

//游戏模式
enum gameMode:Int {
    case Classic = 1
    case Challenge = 2
}

//游戏类型
enum Competitor:Int {
    case Friend = 3
    case Random = 4
}

enum rightBarButtonItemType:Int {
    case time = 1 // 时间
    case share = 2 // 分享
}

//编辑类型
enum editType {
    case avator
    case nickname
    case region
    case password
}

let isUs = true

class ConfigManager: NSObject {
    
    private let usAppID = "Vg7SlR9npVrqsp6iNOQXx7rw-MdYXbMMI"
    private let usAppKey = "Sri6gyViN8Duo2k7v9XnQnoN"
    
    private let cnAppID = "0UKuM6eihzauOmfkdd0FeydO-gzGzoHsz"
    private let cnAppKey = "oKmvokwtISJ8N9BnDzDFTqPO"
    
    private let internationalIpAddress = "http://47.88.106.72:3000"
//本地：
//    private let testIpAddress = "http://192.168.0.111:5678"
//邹：
    private let testIpAddress = "http://192.168.100.195:3000"
    
    private static var instance:ConfigManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    class var sharedInstance: ConfigManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = ConfigManager()
        }
        return instance!
    }
    
    var ipAddress:String {
        get {
            if isUs {
                return internationalIpAddress
            } else {
                return testIpAddress
            }
        }
    }
    
    var avAppKey:String {
        get {
            if isUs {
                return usAppKey
            } else {
                return cnAppKey
            }
        }
    }
    
    var avAppId:String {
        get {
            if isUs {
                return usAppID
            } else {
                return cnAppID
            }
        }
    }
}
