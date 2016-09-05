//
//  QuestionModel.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/21.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class QuestionModel: NSObject {
    var id:String? = nil
    var creator:String? = nil
    var title:String? = nil
    var content:String? = nil
    var classificationCode:String? = nil
    var classificationName:String? = nil
    var countryName:String? = nil
    var countryCode:String? = nil
    var type:NSNumber? = nil
    var earnedGoid:Int? = nil
    var pictureId:String? = nil
    var pictureUrl:String? = nil
    var originalProId:String? = nil
    var questionPhoto:NSData? = nil
    var answers:[AnswerModel]? = nil
    var trueAnswer:String? = nil
    var falseAnswer1:String? = nil
    var falseAnswer2:String? = nil
    var falseAnswer3:String? = nil

    class func getPublishDictionaryFromQuestionModel(model:QuestionModel) -> [String:AnyObject]? {
        let trueDic: [String:AnyObject] = ["content" : model.trueAnswer!,"result" : 1]
        let wrongDic1: [String:AnyObject] = ["content" : model.falseAnswer1!,"result" : 0]
        let wrongDic2: [String:AnyObject] = ["content" : model.falseAnswer2!,"result" : 0]
        let wrongDic3: [String:AnyObject] = ["content" : model.falseAnswer3!,"result" : 0]
        
        var answerArray = [trueDic,wrongDic1,wrongDic2,wrongDic3]
        var selectAnswerArray:[AnyObject] = []
        var deselectArray = [0,1,2,3]
        var selectArray:[AnyObject] = []
        
        for _ in 0 ..< 4 {
            let index = Int(arc4random()%UInt32(deselectArray.count))
            let item = deselectArray[index]
            deselectArray.removeAtIndex(index)
            selectArray.append(item)
        }
        
        for i in 0...3{
            let index = selectArray[i] as! Int
            let item = answerArray[index]
            selectAnswerArray.append(item)
        }
        
        var dict = [String:AnyObject]()
        dict["accountId"] = model.creator
        dict["countryCode"] = model.countryCode
        dict["countryName"] = model.countryName
        dict["classificationCode"] = model.classificationCode
        dict["classificationName"] = model.classificationName
        dict["tags"] = ""
        dict["title"] = model.title
        dict["content"] = model.content
        dict["pictureId"] = model.pictureId
        dict["type"] = 1
        dict["answers"] = selectAnswerArray
        
        return dict
    }
}
