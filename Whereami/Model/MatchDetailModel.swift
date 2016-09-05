//
//  GameModel.swift
//  Whereami
//
//  Created by A on 16/3/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class MatchDetailModel: NSObject {
    var battleId:String? = nil
    var problemId:String? = nil
    var classifyCode:String? = nil
    var acceptInfo:[AnyObject]? = nil
    
    class func getModelFromDictionary(dic:[String:AnyObject]) -> MatchDetailModel {
        let matchDetail = MatchDetailModel()
        matchDetail.battleId = dic["battleId"] as? String
        matchDetail.problemId = dic["problemId"] as? String
        matchDetail.classifyCode = dic["classifyCode"] as? String
        matchDetail.acceptInfo = AcceptInfoModel.getModelsFromArray(dic["acceptInfo"] as! [AnyObject])
        return matchDetail
    }
}

class AcceptInfoModel: NSObject {
    var accountId:String? = nil
    var nickname:String? = nil
    var headPortrait:String? = nil
    
    class func getModelsFromArray(array:[AnyObject]) -> [AcceptInfoModel] {
        var models = [AcceptInfoModel]()
        for item in array {
            let model = AcceptInfoModel()
            model.accountId = item["accountId"] as? String
            model.nickname = item["nickname"] as? String
            model.headPortrait = item["headPortrait"] as? String
            
            models.append(model)
        }
        return models
    }
}
