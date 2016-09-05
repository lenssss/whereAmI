//
//  ConversationViewController.h
//  Whereami
//
//  Created by WuQifei on 16/2/26.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
#import <AVOSCloud/AVOSCloud.h>
#import "XHMessageTableViewController.h"
@class ChattingUserModel;

@interface ConversationViewController :XHMessageTableViewController
@property (nonatomic, strong) AVIMConversation *conversation;
@property (nonatomic, strong) ChattingUserModel *hostModel;
@property (nonatomic, strong) ChattingUserModel *guestModel;
@end
