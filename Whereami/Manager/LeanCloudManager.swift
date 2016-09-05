//
//  LeanCloudManager.swift
//  Whereami
//
//  Created by WuQifei on 16/2/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

enum ConversationType:Int {
    case OneToOne = 0
    case Group = 1
    
    init(number n:Int) {
        if n == 0 {
            self = .OneToOne
        } else {
            self = .Group
        }
    }
}


@objc(LeanCloudManager)
class LeanCloudManager: NSObject,AVIMClientDelegate {
    typealias DidReceiveCommonMessageBlock = (conversition:AVIMConversation,message:AVIMMessage)->()
    typealias DidReceiveTypedMessageBlock = (conversition:AVIMConversation,message:AVIMTypedMessage)->()
    
    private static var instance:LeanCloudManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    var clientId:String? = nil
    private var leanClient:AVIMClient? = nil
    
    var didReceiveCommonMessageCompletion:DidReceiveCommonMessageBlock? = nil
    var didReceiveTypedMessageCompletion:DidReceiveTypedMessageBlock? = nil
    
    class var sharedInstance: LeanCloudManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = LeanCloudManager()
        }
        return instance!
    }
    
    private func setupClient(clientId:String) {
        self.clientId = clientId
        self.leanClient = AVIMClient(clientId:clientId)
        self.leanClient?.delegate = self
    }
    
    func setupApplication() {
//        AVOSCloud.setServiceRegion(.US)
        AVOSCloud.setApplicationId(ConfigManager.sharedInstance.avAppId, clientKey: ConfigManager.sharedInstance.avAppKey)
    }
    
    /**
     创建一个会话客户端
     
     - parameter clientId:   客户端id
     - parameter completion: 回调
     */
    func openSessionWithClientId(clientId:String,completion:(succeed:Bool,error:NSError?)->()) {
        self.setupClient(clientId)
        
        self.leanClient?.openWithCallback({ (succeed, error) -> Void in
            completion(succeed: succeed, error: error)
        })
//        
//        if self.leanClient?.status == .None {
//            
//            
//        } else {
//            self.leanClient?.closeWithCallback({ (succeed, error) -> Void in
//                if succeed {
//                    self.leanClient?.openWithCallback({ (succeed, error) -> Void in
//                        completion(succeed: succeed, error: error)
//                    })
//                }
//                
//            })
//        }
    }
    
    internal func createConversitionWithClientIds(conversionName:String? ,clientIds:[String],completion:(succed:Bool,conversion:AVIMConversation?)->()) {
        var totalClientIds = clientIds
        totalClientIds.append(self.clientId!)
        if totalClientIds.count > 2 {
            self.createConversitionOnClientIds(conversionName,clientIds: totalClientIds, conversationType: .Group, completion: completion)
        } else {
            self.createConversitionOnClientIds(conversionName,clientIds: totalClientIds, conversationType: .OneToOne, completion: completion)
        }
    }
    
    private func createConversitionOnClientIds(conversionName:String?,clientIds:[String],conversationType:ConversationType,completion:(succed:Bool,conversion:AVIMConversation?)->()) {
        //local query
        let queryConditions = NSPredicate(format: "guestId == %@ AND hostId == %@ ",clientIds[0],self.clientId!)
        let dbConversations = DBConversation.MR_findAllWithPredicate(queryConditions);
        
        if(dbConversations != nil && dbConversations?.count>0) {
            let dbConversation = dbConversations![0] as! DBConversation
            
            let query = self.leanClient?.conversationQuery()
            query?.whereKey(kAVIMKeyConversationId, equalTo: dbConversation.conversationId)
            query?.findConversationsWithCallback({ (anyObj, error) in
                if error != nil {
                    completion(succed: false,conversion: nil)
                }else {
                    let conversation:AVIMConversation = anyObj.last as! AVIMConversation
                    completion(succed: true, conversion: conversation)
                }
            })
        }else {
            let query:AVIMConversationQuery = self.leanClient!.conversationQuery()
            query.whereKey(kAVIMKeyMember,containsAllObjectsInArray: clientIds)
            query.whereKey("attr.type", equalTo: NSNumber.init(integer:conversationType.rawValue))
            query.findConversationsWithCallback { (anyObj, error) -> Void in
                if error != nil {
                    completion(succed: false,conversion: nil)
                } else if anyObj == nil || anyObj.count < 1 {
                    self.leanClient?.createConversationWithName(conversionName, clientIds: clientIds, callback: { (conversation, error) -> Void in
                        var succeed = true
                        if error != nil {
                            succeed = false
                        }
                        completion(succed: succeed, conversion: conversation)
                    })
                } else {
                    let conversation:AVIMConversation = anyObj.last as! AVIMConversation
                    completion(succed: true, conversion: conversation)
                }
            }
        }
    }
    
    func findRecentConversationsWithBlock(block:AVIMArrayResultBlock) {
        let dbConversations = DBConversation.MR_findByAttribute("hostId", withValue: (UserModel.getCurrentUser()?.id!)!)
        if(dbConversations == nil || dbConversations?.count == 0 ) {
            block([],nil)
        }
        
        var conversationIds = [String]()
        for index in 0..<dbConversations!.count {
            let dbConversation = dbConversations![index] as! DBConversation
            conversationIds.append(dbConversation.conversationId!)
        }
        
        let query = self.leanClient!.conversationQuery()
        query.whereKey(kAVIMKeyConversationId, containedIn: conversationIds)
        query.orderByDescending("updatedAt")
        query.findConversationsWithCallback(block)
    }
    
    func findSearchConversationsWithBlock(searchText:String, block:AVIMArrayResultBlock) {
        let likeStr = "*" + searchText + "*"
        let conversationFilter = NSPredicate(format: "guestModel.accountId like[cd] %@",likeStr)
        let dbConversations = DBConversation.MR_findAllWithPredicate(conversationFilter)
        if(dbConversations == nil || dbConversations?.count == 0 ) {
            block([],nil)
        }
        
        var conversationIds = [String]()
        for index in 0..<dbConversations!.count {
            let dbConversation = dbConversations![index] as! DBConversation
            conversationIds.append(dbConversation.conversationId!)
        }
        
        let query = self.leanClient!.conversationQuery()
        query.whereKey(kAVIMKeyConversationId, containedIn: conversationIds)
        query.orderByDescending("updatedAt")
        query.findConversationsWithCallback(block)
    }
    
    /*
    func findConversationsWithString(guestId:String) -> ConversationModel? {
        let friendFilter = NSPredicate(format: "hostId == %@ AND guestId == %@",(UserModel.getCurrentUser()?.id!)!,guestId)
        let friend = DBConversation.MR_findFirstWithPredicate(friendFilter)
        if friend == nil {
            return nil
        }
        return ConversationModel.modelFromDBModel(friend!)
    }
 */
    
    func conversation(conversation: AVIMConversation!, didReceiveCommonMessage message: AVIMMessage!) {
        let kAVIMMessageMediaTypeText:Int8 = -1
        
        CoreDataConversationManager.sharedInstance.increaseOrCreateUnreadCountByConversation(conversation,lastMsg: message.content,msgType: kAVIMMessageMediaTypeText)
        if self.didReceiveCommonMessageCompletion != nil {
            self.didReceiveCommonMessageCompletion!(conversition:conversation,message:message)
        }
    }
    
    func conversation(conversation: AVIMConversation!, didReceiveTypedMessage message: AVIMTypedMessage!) {
        
        CoreDataConversationManager.sharedInstance.increaseOrCreateUnreadCountByConversation(conversation,lastMsg: message.text ,msgType: message.mediaType)
        if self.didReceiveTypedMessageCompletion != nil {
            self.didReceiveTypedMessageCompletion!(conversition:conversation,message:message)
        }
        
    }
}
