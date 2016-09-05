//
//  ConversationModel.swift
//  Whereami
//
//  Created by WuQifei on 16/2/24.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ConversationModel: NSObject {
    
    var avConversation:AVIMConversation?
    var unreadCount: Int?
    var lattestMsg:String?
    var hostModel:ChattingUserModel?
    var guestModel:ChattingUserModel?
    var lastTime:NSDate?
    
    static func modelFromModels(avConversation:AVIMConversation,dbModel:DBConversation)->(ConversationModel?) {
        
        let conversation = ConversationModel()
        
        let currentUser = UserModel.getCurrentUser()
        let guestUser = ChattingUserModel()
        let hostUser = ChattingUserModel()
        
        guard dbModel.guestId != nil else {
            return nil
        }
        let user = UserManager.sharedInstance.getUserById(dbModel.guestId!)
        guestUser.accountId = user.id
        guestUser.headPortrait = user.headPortraitUrl
        guestUser.nickname = user.nickname
        
        hostUser.accountId = currentUser?.id
        hostUser.headPortrait = currentUser?.headPortraitUrl
        hostUser.nickname = currentUser?.nickname
        
        conversation.hostModel = hostUser
        conversation.guestModel = guestUser
        conversation.avConversation = avConversation
        conversation.lattestMsg = dbModel.lattestMsg
        conversation.unreadCount = dbModel.unreadCount?.integerValue
        conversation.lastTime = dbModel.lastTime
        
        return conversation
    }
}
