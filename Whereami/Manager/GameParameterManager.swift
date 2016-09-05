//
//  UserDefaultsManager.swift
//  Whereami
//
//  Created by A on 16/3/31.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class GameParameterManager: NSObject {
    private static var instance:GameParameterManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    var gameMode:[String:AnyObject]? = nil
    var gameRange:CountryModel? = nil
    var matchUser:[FriendsModel]? = nil
    var matchDetailModel:MatchDetailModel? = nil
    var battleModel:BattleModel? = nil
    var roomTitle:String? = nil
    
    class var sharedInstance: GameParameterManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = GameParameterManager()
        }
        return instance!
    }
    
    func clearGameParameter(){
        self.gameMode = nil
        self.gameRange = nil
        self.matchUser = nil
        self.matchDetailModel = nil
        self.battleModel = nil
        self.roomTitle = nil
    }
}
