//
//  CountryModel.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/21.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class CountryModel: NSObject {

    var countryId:String?
    var countryCode:String?
    var countrypicture:String?
    var countryName:String?
    var countryOpened:NSNumber?
    
    class func getCountryListFromObject(objs:[String : AnyObject]) -> [CountryModel]? {
        var countryList = [CountryModel]()
        let countries = objs["countries"] as? [AnyObject]
        for item in countries! {
            let model = CountryModel()
            model.countryId = item["countryId"] as? String
            model.countryCode = item["countryCode"] as? String
            model.countrypicture = item["countrypicture"] as? String
            let countryName = item["countryname"] as? String
            model.countryName = countryName?.stringByRemovingPercentEncoding
            model.countryOpened = item["countryisOpened"] as? NSNumber
            countryList.append(model)
        }
        return countryList
    }
    
    class func getNamesFromModels(models:[CountryModel]) -> [String] {
        var names = [String]()
        for item in models{
            if item.countryOpened == 0 {
                let name = item.countryName
                names.append(name!)
            }
        }
        return names
    }
    
    class func getCodesFromModels(models:[CountryModel]) -> [String] {
        var codes = [String]()
        for item in models{
            if item.countryOpened == 0 {
                let code = item.countryCode
                codes.append(code!)
            }
        }
        return codes
    }
    
}

class GameKindModel: NSObject {
    var kindId:String? = nil
    var kindCode:String? = nil
    var kindName:String? = nil
    
    class func getGameKindListFromObject(objs:[String : AnyObject]) -> [GameKindModel]? {
        var gameKindList = [GameKindModel]()
        let kinds = objs["kinds"] as? [AnyObject]
        for item in kinds! {
            let model = GameKindModel()
            model.kindId = item["kindId"] as? String
            model.kindCode = item["kindCode"] as? String
            let kindName = item["kindName"] as? String
            model.kindName = kindName?.stringByRemovingPercentEncoding
            gameKindList.append(model)
        }
        return gameKindList
    }
    
    class func getNamesFromModels(models:[GameKindModel]) -> [String] {
        var names = [String]()
        for item in models{
            let name = item.kindName
            names.append(name!)
        }
        return names
    }
    
    class func getCodesFromModels(models:[GameKindModel]) -> [String] {
        var codes = [String]()
        for item in models{
            let code = item.kindCode
            codes.append(code!)
        }
        return codes
    }
}