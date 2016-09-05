//
//  FileManager.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/21.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class FileManager: NSFileManager {
    private static var instance:FileManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    class var sharedInstance: FileManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = FileManager()
        }
        return instance!
    }
    
    func countryListWriteToFile(countryList:NSArray){
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let filePath = documentPath + "/countryList.txt"
        countryList.writeToFile(filePath, atomically: true)
    }
    
    func readCountryListFromFile() -> [CountryModel]? {
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let filePath = documentPath + "/countryList.txt"
        let isExist = self.fileExistsAtPath(filePath)
        if isExist {
            let countryList = NSArray(contentsOfFile: filePath)![0] as! [String : AnyObject]
            let models = CountryModel.getCountryListFromObject(countryList)
            return models
        }
        else{
            return nil
        }
    }
    
    func gameKindListWriteToFile(gameKindList:NSArray){
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let filePath = documentPath + "/gameKindList.txt"
        print("+++++++++++++++\(filePath)")
        gameKindList.writeToFile(filePath, atomically: true)
    }
    
    func readGameKindListFromFile() -> [GameKindModel]? {
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let filePath = documentPath + "/gameKindList.txt"
        let isExist = self.fileExistsAtPath(filePath)
        if isExist {
            let gameKindList = NSArray(contentsOfFile: filePath)![0] as! [String : AnyObject]
            let models = GameKindModel.getGameKindListFromObject(gameKindList)
            return models
        }
        else{
            return nil
        }
    }
    
}
