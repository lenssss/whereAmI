
//
//  ConfigManager.swift
//  Whereami
//
//  Created by A on 16/4/19.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

let isUs = false

class ConfigManager: NSObject {
    
    private let usAppID = "Vg7SlR9npVrqsp6iNOQXx7rw-MdYXbMMI"
    private let usAppKey = "Sri6gyViN8Duo2k7v9XnQnoN"
    
    private let cnAppID = "0UKuM6eihzauOmfkdd0FeydO-gzGzoHsz"
    private let cnAppKey = "oKmvokwtISJ8N9BnDzDFTqPO"
    
    private let internationalIpAddress = "http://47.88.19.66:8080"
//本地：
//    private let testIpAddress = "http://192.168.0.100:5678"
//邹：
    private let testIpAddress = "http://192.168.0.119:3000"
    
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
