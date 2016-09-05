//
//  ItemsModel.swift
//  Whereami
//
//  Created by 陈鹏宇 on 16/7/11.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ItemsModel: NSObject {
    var type:String? = nil
    var typeName:String? = nil
    var typeDes:String? = nil
    var items:[ItemModel]? = nil
    
    class func getModelFromArray(array:[AnyObject]) -> [ItemsModel]?{
        var itemsModels:[ItemsModel] = [ItemsModel]()
        for items in array {
            let model = ItemsModel()
            model.type = items["type"] as? String
            model.typeName = items["typeName"] as? String
            model.typeDes = items["typeDes"] as? String
            guard let arr = (items["items"] as? [AnyObject]) else{
                itemsModels.append(model)
                continue
            }
            model.items = ItemModel.getModelFromArray(arr)
            itemsModels.append(model)
        }
        return itemsModels
    }
}

class ItemModel: NSObject {
    var type:String? = nil
    var typeName:String? = nil
    var typeDes:String? = nil
    var code:String? = nil
    var name:String? = nil
    var icons:String? = nil
    var classification:String? = nil
    var des:String? = nil
    var currency:String? = nil
    var price:NSNumber? = nil
    var increase:NSNumber? = nil
    var triggers:String? = nil
    var hotFlag:Int? = nil
    var showFlag:Int? = nil
    var buyTime:NSNumber? = nil
    
     class func getModelFromArray(array:[AnyObject]) -> [ItemModel]? {
        var items:[ItemModel] = [ItemModel]()
        for item in array {
            let model = ItemModel()
            model.type = item["type"] as? String
            model.typeName = item["typeName"] as? String
            model.typeDes = item["typeDes"] as? String
            model.code = item["code"] as? String
            model.name = item["name"] as? String
            model.icons = item["icons"] as? String
            model.classification = item["classifcation"] as? String
            model.des = item["description"] as? String
            model.currency = item["currency"] as? String
            model.price = item["price"] as? NSNumber
            model.increase = item["increase"] as? NSNumber
            model.triggers = item["triggers"] as? String
            model.hotFlag = item["hotFlag"] as? Int
            model.showFlag = item["showFlag"] as? Int
            model.buyTime = item["buyTime"] as? NSNumber
            items.append(model)
        }
        return items
    }
}

class AccItems:NSObject {
    var accountId:String? = nil
    var itemCode:String? = nil
    var itemName:String? = nil
    var itemNum:Int? = nil
    
    typealias Callback = ([AccItems]?) -> Void
    
    class func getModelFromArray(array:[AnyObject]) -> [AccItems]?{
        var items:[AccItems] = [AccItems]()
        for item in array {
            let model = AccItems()
            model.accountId = item["accountId"] as? String
            model.itemCode = item["itemcode"] as? String
            model.itemName = item["itemname"] as? String
            model.itemNum = item["itemNum"] as? Int
            items.append(model)
        }
        return items
    }
    
    static func modelFromDBModel(dbmodel:DBAccItems)->(AccItems){
        let item = AccItems()
        item.accountId = dbmodel.accountId
        item.itemCode = dbmodel.itemCode
        item.itemName = dbmodel.itemName
        item.itemNum = dbmodel.itemNum as? Int
        
        return item
    }
    
    class func getAccItemsWithCompletion(completion:Callback){
        let id = UserModel.getCurrentUser()?.id
        let data = CoreDataManager.sharedInstance.fetchItemById(id!)
        guard data != nil && data?.count != 0 else {
            return
        }
        completion(data)
        
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
                    completion(data)
                }
            }
        }
    }
}

class AccAchievements:NSObject {
    var type:String? = nil
    var typeName:String? = nil
    var list:[AccAchievement]? = nil
    
    class func getModelFromArray(array:[AnyObject]) -> [AccAchievements]?{
        var models:[AccAchievements] = [AccAchievements]()
        for items in array {
            let model = AccAchievements()
            model.type = items["type"] as? String
            model.typeName = items["typeName"] as? String
            guard let arr = (items["list"] as? [AnyObject]) else{
                models.append(model)
                continue
            }
            model.list = AccAchievement.getModelFromArray(arr)
            models.append(model)
        }
        return models
    }
}

class AccAchievement: NSObject {
    var type:String? = nil
    var typeName:String? = nil
    var level:String? = nil
    var name:String? = nil
    var code:String? = nil
    var icons:String? = nil
    var parentCode:String? = nil
    var reachCode:String? = nil
    var achNumber:String? = nil
    var reachNumber:NSNumber? = nil
    var rewardItem:[String]? = nil
    var reachFlag:Int? = nil
    var numProgress:NSNumber? = nil
    var reachProgress:[String]? = nil
    var itemGet:Int? = nil
    
    class func getModelFromArray(array:[AnyObject]) -> [AccAchievement]? {
        var items:[AccAchievement] = [AccAchievement]()
        for item in array {
            let model = AccAchievement()
            model.type = item["type"] as? String
            model.typeName = item["typeName"] as? String
            model.level = item["level"] as? String
            model.code = item["code"] as? String
            model.name = item["name"] as? String
            model.icons = item["icons"] as? String
            model.parentCode = item["parentCode"] as? String
            model.reachCode = item["reachCode"] as? String
            model.achNumber = item["achNumber"] as? String
            model.reachNumber = item["reachNumber"] as? Int
            model.rewardItem = item["rewardItem"] as? [String]
            model.reachFlag = item["reachFlag"] as? Int
            model.numProgress = item["numProgress"] as? Int
            model.reachProgress = item["reachProgress"] as? [String]
            model.itemGet = item["itemGet"] as? Int
            items.append(model)
        }
        return items
    }
}
