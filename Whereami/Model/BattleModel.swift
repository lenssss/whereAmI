//
//  BattleModel.swift
//  Whereami
//
//  Created by A on 16/3/29.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class BattleModel: NSObject {
    var battleId:String? = nil
    var problemId:String? = nil
    var questions:QuestionModel? = nil
    
     class func getModelFromDictionary(dic:NSDictionary) -> BattleModel {
        let questionModel = QuestionModel()
        questionModel.id = dic["questions"]!["id"] as? String
        questionModel.originalProId = dic["questions"]!["originalProId"] as? String
        questionModel.title = dic["questions"]!["title"] as? String
        questionModel.content = dic["questions"]!["content"] as? String
        questionModel.classificationCode = dic["questions"]!["classificationCode"] as? String
        questionModel.classificationName = dic["questions"]!["classificationName"] as? String
        questionModel.pictureId = dic["questions"]!["pictureId"] as? String
        questionModel.pictureUrl = dic["questions"]!["pictureUrl"] as? String
        questionModel.type = dic["questions"]!["type"] as? NSNumber
        questionModel.earnedGoid = dic["questions"]!["earnedGoid"] as? Int
        questionModel.answers = AnswerModel.getModelsFromArray((dic["questions"]!["answers"] as? [AnyObject])!)
        
        let model = BattleModel()
        model.battleId = dic["battleId"] as? String
        model.problemId = dic["problemId"] as? String
        model.questions = questionModel
        
        return model
    }
}

class BattleAllModel: NSObject {
    var battle:[AnyObject]? = nil
    var ends:[AnyObject]? = nil
    var turn:[AnyObject]? = nil
    
    class func getModelFromObject(objs:AnyObject) -> BattleAllModel {
        let battleAll = BattleAllModel()
        battleAll.battle = [AnyObject]()
        battleAll.ends = [AnyObject]()
        battleAll.turn = [AnyObject]()
        let objArr = objs as! NSArray
        
        let modelArr = objArr[0]["rets"] as! [NSDictionary]
        
        for item in modelArr{
            let dic = item as? [String:AnyObject]
            let type = dic!["type"] as! String
            if type == "myturn" {
                let objs = dic!["datas"]
                let model = BattleListModel.getModelFromDictionary(objs!)
                battleAll.battle = model.result
            }
            else if type == "end"{
                let objs = dic!["datas"]
                let model = BattleListModel.getModelFromDictionary(objs!)
                battleAll.ends = model.result
            }
            else{
                let objs = dic!["datas"]
                let model = BattleListModel.getModelFromDictionary(objs!)
                battleAll.turn = model.result
            }
        }
        return battleAll
    }
    
}

class BattleListModel: NSObject {
    var page:NSNumber? = nil
    var allPage:NSNumber? = nil
    var result:[AnyObject]? = nil
    var code:NSNumber? = nil
    
    class func getModelFromDictionary(objs:AnyObject) -> BattleListModel {
        let BattleList = BattleListModel()
        let dic = objs as! [String:AnyObject]
        
        BattleList.page = dic["page"] as? NSNumber
        BattleList.allPage = dic["allpage"] as? NSNumber
        BattleList.code = dic["statusCode"] as? NSNumber
        BattleList.result = self.getResult(dic["result"] as! [AnyObject])
        return BattleList
    }
    
    private class func getResult(array:[AnyObject]) -> [AnyObject]? {
        let modelArray = BattleDetailModel.getModelFromArray(array)
        var results = [AnyObject]()
        
        for item in modelArray {
            results.append(item)
        }
        
        return results
    }
}

class BattleDetailModel: NSObject {
    var acceptStatus:NSNumber? = nil
    var battleId:String? = nil
    var battleStatus:NSNumber? = nil
    var battleTitle:String? = nil
    var battleType:String? = nil
    var endDate:NSDate? = nil
    var launch:String? = nil
    var launchId:String? = nil
//    var launchHeadPortrait:String? = nil
    var launchdan:Int? = 0
    var launchleve:Int? = 0
    var myType:Int? = 0
    var remainNum:Int? = 0
    var winId:String? = nil
    var winName:String? = nil
    var myTurn:Int? = 0
    var scoreDetail:String? = nil
    
    class func getModelFromArray(array:[AnyObject]) -> [BattleDetailModel] {
        var results = [BattleDetailModel]()
        for item in array {
            let model = BattleDetailModel()
            model.acceptStatus = item["acceptStatus"] as? NSNumber
            model.battleId = item["battleId"] as? String
            model.battleStatus = item["battleStatus"] as? NSNumber
            model.battleTitle = item["battleTitle"] as? String
            model.battleType = item["battletype"] as? String
            let string = NSString(string: item["endDate"] as! String)
            model.endDate = NSDate(timeIntervalSince1970: string.doubleValue)
            model.launch = item["launch"] as? String
            model.launchId = item["launchId"] as? String
//            model.launchHeadPortrait = item["launchHeadPortrait"] as? String
            model.launchdan = item["launchdan"] as? Int
            model.launchleve = item["launchleve"] as? Int
            model.myType = item["mytype"] as? Int
            model.remainNum = item["remainNum"] as? Int
            model.winId = item["winId"] as? String
            model.winName = item["winName"] as? String
            model.myTurn = item["myTurn"] as? Int
            model.scoreDetail = item["scoreDetail"] as? String
            results.append(model)
        }
        return results
    }
}

class BattleEndModel:NSObject{
    
    var type:String? = nil
    var battleTitle:String? = nil
    var winId:String? = nil
    var winNickName:String? = nil
    var createDate:NSDate? = nil
    var enddate:NSDate? = nil
    var accounts:[AnyObject]? = nil
    
    class func getModelFromObject(objs:AnyObject) -> BattleEndModel? {
        let model = BattleEndModel()
        let objArr = objs as! NSArray
        let dic = objArr[0] as! [String:AnyObject]
        
        model.type = dic["type"] as? String
        model.battleTitle = dic["battleTitle"] as? String
        model.winId = dic["winId"] as? String
        model.winNickName = dic["winNickName"] as? String
        var string = NSString(string: dic["createDate"] as! String)
        model.createDate = NSDate(timeIntervalSince1970: string.doubleValue)
        string = NSString(string: dic["endDate"] as! String)
        model.enddate = NSDate(timeIntervalSince1970: string.doubleValue)
        model.accounts = BattleEndDetailModel.getModelFromArray((dic["accounts"] as? [AnyObject])!)
        return model
    }
}

class BattleEndDetailModel:NSObject{
    var accountId:String? = nil
    var nickname:String? = nil
    var acceptStatus:Int? = nil
    var costtime:String? = nil
    var score:Int? = nil
    var type:Int? = nil
    var myTurn:Int? = nil
    var remain:Int? = nil
    var headPortrait:String? = nil
    
    class func getModelFromArray(array:[AnyObject]) -> [BattleEndDetailModel] {
        var results = [BattleEndDetailModel]()
        for item in array {
            let model = BattleEndDetailModel()
            model.accountId = item["accountId"] as? String
            model.nickname = item["nickname"] as? String
            model.acceptStatus = item["acceptStatus"] as? Int
            model.costtime = item["costtime"] as? String
            model.score = item["score"] as? Int
            model.type = item["type"] as? Int
            model.remain = item["remainNum"] as? Int
            model.myTurn = item["myTurn"] as? Int
            model.headPortrait = item["headPortrait"] as? String
            results.append(model)
        }
        return results
    }
}