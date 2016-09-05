//
//  TravelModel.swift
//  Whereami
//
//  Created by A on 16/4/27.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class TravelModel: NSObject {
    var id:String? = nil
    var creatorId:String? = nil
    var content:String? = nil
    var picList:[String]? = nil
    var digList:[String]? = nil
    var ginwave:String? = nil
    var ginwaveDes:String? = nil
    var createdAt:String? = nil
    var updateAt:String? = nil
    var comments:[AnyObject]? = nil
    
    class func getModelsFromObject(objs:AnyObject) -> [TravelModel]? {
        var models = [TravelModel]()
        let objArr = objs[0]["feeds"] as! NSArray
        
        print("==================\(objs[0]["feeds"])")
        
        if objArr.count != 0 {
            for dic in objArr{
                let model = TravelModel()
                model.id = dic["_id"] as? String
                model.creatorId = dic["creatorId"] as? String
                model.content = dic["content"] as? String
                model.picList = dic["picList"] as? [String]
                model.digList = dic["digList"] as? [String]
                model.ginwave = dic["ginwave"] as? String
                model.ginwaveDes = dic["ginwaveDes"] as? String
                model.createdAt = dic["createdAt"] as? String
                model.updateAt = dic["updatedAt"] as? String
                model.comments = TravelModel.getComments((dic["comments"] as! [AnyObject]))
                
//                models.insert(model, atIndex: 0)
                models.append(model)
            }
        }
        
        return models
    }
    
    private class func getComments(array:[AnyObject]) -> [AnyObject]? {
        if array.count != 0{
            let modelArray = CommentModel.getModelFromArray(array)
            return modelArray
        }
        return [CommentModel]()
    }
}

class CommentModel: NSObject {
    var id:String? = nil
    var tourId:String? = nil
    var creatorId:String? = nil
    var content:String? = nil
    var relatedId:String? = nil
    var createAt:String? = nil
    var extraData:AnyObject? = nil
    
    class func getModelFromArray(array:[AnyObject]) -> [CommentModel] {
        var results = [CommentModel]()
        for item in array {
            let model = self.getModelFromDictionary(item as! [String : AnyObject])
            results.append(model!)
        }
        return results
    }
    
    class func getModelFromDictionary(dic:[String:AnyObject]) -> CommentModel? {
        let model = CommentModel()
        model.id = dic["_id"] as? String
        model.tourId = dic["tourId"] as? String
        model.creatorId = dic["creatorId"] as? String
        model.content = dic["content"] as? String
        model.relatedId = dic["relatedId"] as? String
        model.createAt = dic["createAt"] as? String
        model.extraData = dic["extraData"]
        return model
    }
}