//
//  AnswerModel.swift
//  Whereami
//
//  Created by A on 16/3/29.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class AnswerModel: NSObject {
    var id:String? = nil
    var content:String? = nil
    var result:NSNumber? = nil
    
    class func getModelsFromArray(array:[AnyObject]) -> [AnswerModel] {
        var models = [AnswerModel]()
        for item in array {
            let model = AnswerModel()
            model.id = item["id"] as? String
            let content = item["content"] as! String
            model.content = content.stringByRemovingPercentEncoding
            model.result = item["result"] as? NSNumber
            models.append(model)
        }
        return models
    }
}
