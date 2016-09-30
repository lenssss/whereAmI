//
//  CoreDataConversationManager.swift
//  Whereami
//
//  Created by WuQifei on 16/2/24.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import MagicalRecord

public var KNotificationConversationChanges: String { get{ return "KNotificationConversationChanges"} }

@objc(CoreDataConversationManager)
class CoreDataConversationManager: NSObject {
    private static var instance:CoreDataConversationManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    class var sharedInstance: CoreDataConversationManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = CoreDataConversationManager()
        }
        return instance!
    }
    
    func findDbConversation(conversation: AVIMConversation)->DBConversation? {
        let dbConversation = DBConversation.MR_findFirstByAttribute("conversationId", withValue: conversation.conversationId)
        return dbConversation
    }
    
    func increaseOrCreateUnreadCountByConversation(conversation: AVIMConversation,lastMsg: String?, msgType: AVIMMessageMediaType) {
        var dbConversation = DBConversation.MR_findFirstByAttribute("conversationId", withValue: conversation.conversationId)
        var theUnreadCount = 0
        if dbConversation == nil {
            dbConversation = DBConversation.MR_createEntity()
            
            let currentUser = UserModel.getCurrentUser()
            
            dbConversation?.conversationId = conversation.conversationId
            var guestId:String? = nil
            for index in 0..<conversation.members.count {
                let memberId = conversation.members[index] as! String
                if memberId != currentUser?.id {
                    guestId = memberId
                    break
                }
            }
            dbConversation?.guestId = guestId
            dbConversation?.hostId = currentUser?.id!
            dbConversation?.lattestMsg = lastMsg
            
        } else {
            theUnreadCount = (dbConversation?.unreadCount?.integerValue)! + 1
        }
        
        dbConversation?.unreadCount = NSNumber(integer: theUnreadCount)
        dbConversation?.lastTime = NSDate()
        
        let kAVIMMessageMediaTypeText:Int8 = -1
        let kAVIMMessageMediaTypeImage:Int8 = -2
        let kAVIMMessageMediaTypeAudio:Int8 = -3
        let kAVIMMessageMediaTypeLocation:Int8 = -5
        
        if msgType == kAVIMMessageMediaTypeAudio {
            dbConversation?.lattestMsg = "[voice]"
        } else if msgType == kAVIMMessageMediaTypeText {
            dbConversation?.lattestMsg = lastMsg
        } else if msgType == kAVIMMessageMediaTypeImage {
            dbConversation?.lattestMsg = "[image]"
        } else if msgType == kAVIMMessageMediaTypeLocation {
            dbConversation?.lattestMsg = "[location]"
        } else if msgType == Int8(kAVIMMessageMediaTypeEmotion) {
            dbConversation?.lattestMsg = "[emotion]"
        }
        
        dbConversation?.unreadCount = NSDecimalNumber(decimal: NSNumber(integer:theUnreadCount).decimalValue)
        let context = dbConversation?.managedObjectContext
        context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
            if succeed {
                 LNotificationCenter().postNotificationName(KNotificationConversationChanges, object: nil)
            }
        })
        
    }
    
    func deleteConversation(conversationId:String) {
        let dbConversation = DBConversation.MR_findFirstByAttribute("conversationId", withValue: conversationId)
        if dbConversation != nil {
            dbConversation!.MR_deleteEntity()
        }
        
        let context = dbConversation?.managedObjectContext
        context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
            if succeed {
            }
        })
    }
    
    func fetchUnreadCountByConversationId(conversationId:String)->(Int) {
        let dbConversation = DBConversation.MR_findFirstByAttribute("conversationId", withValue: conversationId)
        var theUnreadCount = 0
        if dbConversation != nil {
            theUnreadCount = (dbConversation?.unreadCount?.integerValue)!
        }
        
        return theUnreadCount
    }
    
    func clearUnreadCountByConversationId(conversationId:String) {
        let dbConversation = DBConversation.MR_findFirstByAttribute("conversationId", withValue: conversationId)
        if dbConversation != nil {
            dbConversation?.unreadCount = 0
            let context = dbConversation?.managedObjectContext
            context?.MR_saveToPersistentStoreWithCompletion({ (succeed, error) -> Void in
                if succeed {
                }
            })
        }
        
    }
}
