//
//  PhotoModel.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/22.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PhotoModel: NSObject {
    var file:String?
    var accountId:String?
    var ginwave:String?
    var geoDes:String?
    var id:String?
    
    static func modelFromDBModel(dbmodel:DBPhoto)->(PhotoModel){
        let photo = PhotoModel()
        photo.file = dbmodel.content
        photo.accountId = dbmodel.accountId
        photo.ginwave = dbmodel.ginwave
        photo.geoDes = dbmodel.geoDes
        photo.id = dbmodel.id
        
        return photo
    }
    
    class func getPhotoDictionaryFromQuestionModel(questionModel:QuestionModel) -> [String:AnyObject]? {
        var dict = [String:AnyObject]()
        dict["userId"] = UserModel.getCurrentUser()?.id
        dict["type"] = "jpg"
        dict["content"] = questionModel.questionPhoto
        
        return dict
    }
    
    class func getPhotoFromQuestionModel(questionModel:QuestionModel) -> [String:AnyObject]? {
        let photoModel = PhotoModel()
        photoModel.file = questionModel.pictureUrl
        photoModel.accountId = questionModel.creator
        if LocationManager.sharedInstance.currentLocation != nil {
            photoModel.ginwave = LocationManager.sharedInstance.currentLocation
        }
        else{
            photoModel.ginwave = ""
        }
        if LocationManager.sharedInstance.geoDes != nil {
            photoModel.geoDes = LocationManager.sharedInstance.geoDes
        }
        else{
            photoModel.geoDes = ""
        }
        
        var dict = [String:AnyObject]()
        dict["file"] = photoModel.file
        dict["accountId"] = photoModel.accountId
        dict["ginwave"] = photoModel.ginwave
        dict["geoDes"] = photoModel.geoDes
        
        return dict
    }
    
    class func getPhotoDictionaryFromFile(file:String,creator accountId:String) -> [String:AnyObject]? {
        let photoModel = PhotoModel()
        photoModel.file = file
        photoModel.accountId = accountId
        if LocationManager.sharedInstance.currentLocation != nil {
            photoModel.ginwave = LocationManager.sharedInstance.currentLocation
        }
        else{
            photoModel.ginwave = ""
        }
        if LocationManager.sharedInstance.geoDes != nil {
            photoModel.geoDes = LocationManager.sharedInstance.geoDes
        }
        else{
            photoModel.geoDes = ""
        }
        
        var dict = [String:AnyObject]()
        dict["file"] = photoModel.file
        dict["accountId"] = photoModel.accountId
        dict["ginwave"] = photoModel.ginwave
        dict["geoDes"] = photoModel.geoDes
        
        return dict
    }
    
    class func getPhotoModelFromDictionary(dic:NSDictionary) -> PhotoModel? {
        let photoModel = PhotoModel()
        photoModel.file = dic["content"] as? String
        photoModel.accountId = dic["accountId"] as? String
        photoModel.ginwave = dic["ginwave"] as? String
        photoModel.geoDes = dic["geoDes"] as? String
        photoModel.id = dic["id"] as? String
        return photoModel
    }
}
