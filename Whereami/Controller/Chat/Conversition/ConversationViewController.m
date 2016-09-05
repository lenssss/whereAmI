//
//  ConversationViewController.m
//  Whereami
//
//  Created by WuQifei on 16/2/26.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

#import "ConversationViewController.h"
#import "XHDisplayTextViewController.h"
#import "XHDisplayMediaViewController.h"
#import "XHDisplayLocationViewController.h"
#import "XHAudioPlayerHelper.h"
#import "AVIMEmotionMessage.h"
#import "Whereami-Swift.h"
#import "MagicalRecord.h"

typedef enum : NSInteger{
    ConversationTypeOneToOne = 0,
    ConversationTypeGroup = 1,
}ConversationType;

static NSInteger const kOnePageSize = 7;

@interface ConversationViewController ()<XHAudioPlayerHelperDelegate>
@property (nonatomic, strong) NSArray *emotionManagers;

@property (nonatomic, strong) XHMessageTableViewCell *currentSelectedCell;

@property (nonatomic, assign) ConversationType conversationType;

@property (nonatomic, strong) NSArray<NSString *> *clientIDs;
@end

@implementation ConversationViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XHAudioPlayerHelper shareInstance] stopAudio];
    
    [[CoreDataConversationManager sharedInstance]clearUnreadCountByConversationId:self.conversation.conversationId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.bounds = CGRectMake(0, 0, 30, 30);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarIem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarIem;
    
    self.clientIDs = self.conversation.members;
    if (self.clientIDs.count > 1) {
        self.conversationType = ConversationTypeGroup;
    }
    
    // Do any additional setup after loading the view.
    if (CURRENT_SYS_VERSION >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = NO;
    }
    self.title = self.guestModel.nickname;
    
    // Custom UI
    //    self.loadMoreActivityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    //    [self setBackgroundColor:[UIColor clearColor]];
    //    [self setBackgroundImage:[UIImage imageNamed:@"TableViewBackgroundImage"]];
    
    // 设置自身用户名
    self.messageSender = [self displayNameByClientId:[LeanCloudManager sharedInstance].clientId ];
    
    // 添加第三方接入数据
    NSMutableArray *shareMenuItems = [NSMutableArray array];
    NSArray *plugIcons = @[@"sharemore_pic", @"sharemore_video",@"sharemore_location"];
    NSArray *plugTitle = @[@"album", @"photo",@"location"];
    for (NSString *plugIcon in plugIcons) {
        XHShareMenuItem *shareMenuItem = [[XHShareMenuItem alloc] initWithNormalIconImage:[UIImage imageNamed:plugIcon] title:[plugTitle objectAtIndex:[plugIcons indexOfObject:plugIcon]]];
        [shareMenuItems addObject:shareMenuItem];
    }
    
    NSMutableArray *emotionManagers = [NSMutableArray array];
    for (NSInteger i = 0; i < 1; i ++) {
        XHEmotionManager *emotionManager = [[XHEmotionManager alloc] init];
        emotionManager.emotionName = @"Tursky";
        NSMutableArray *emotions = [NSMutableArray array];
        for (NSInteger j = 0; j < 16; j ++) {
            XHEmotion *emotion = [[XHEmotion alloc] init];
            NSString *imageName = [NSString stringWithFormat:@"section%ld_emotion%ld", (long)i , (long)j % 16];
            emotion.emotionPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"emotion%ld",(long)(j%16)] ofType:@"gif"];
            emotion.emotionConverPhoto = [UIImage imageNamed:imageName];
            [emotions addObject:emotion];
        }
        emotionManager.emotions = emotions;
        [emotionManagers addObject:emotionManager];
    }     
    
    self.emotionManagers = emotionManagers;
    self.emotionManagerView.isShowEmotionStoreButton = false;
    [self.emotionManagerView reloadData];
    
    self.shareMenuItems = shareMenuItems;
    [self.shareMenuView reloadData];
    
    // 创建一个对话
    self.loadingMoreMessage = YES;
    
    WEAKSELF
    [self.conversation queryMessagesWithLimit:kOnePageSize callback:^(NSArray *queryMessages, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *typedMessages = [self filterTypedMessage:queryMessages];
            NSMutableArray *messages = [NSMutableArray array];
            for (AVIMTypedMessage *typedMessage in typedMessages) {
                XHMessage *message = [weakSelf displayMessageByAVIMTypedMessage:typedMessage];
                if (message) {
                    [messages addObject:message];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.messages = messages;
                [weakSelf.messageTableView reloadData];
                [weakSelf scrollToBottomAnimated:NO];
                //延迟，以避免上面的滚动触发上拉加载消息
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    weakSelf.loadingMoreMessage = NO;
                });
            });
        });
    }];
    
    [[CoreDataConversationManager sharedInstance] clearUnreadCountByConversationId:self.conversation.conversationId];
}

-(void)leftButtonClicked {
    NSArray *views = self.navigationController.viewControllers;
    UIViewController *view = views[views.count-2];
    [self.navigationController popToViewController:view animated:YES];
}

// 这里也要把 setupDidReceiveTypedMessageCompletion 放到 viewDidAppear 中
// 不然, 就会冲突, 导致不能实时接收到对方的消息
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    WEAKSELF
    [LeanCloudManager sharedInstance].didReceiveTypedMessageCompletion = ^(AVIMConversation *conversation, AVIMTypedMessage *message) {
        // 富文本信息
        if([conversation.conversationId isEqualToString:self.conversation.conversationId]){
            [weakSelf insertAVIMTypedMessage:message];
        }
    };
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [LeanCloudManager sharedInstance].didReceiveTypedMessageCompletion = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.emotionManagers = nil;
    [[XHAudioPlayerHelper shareInstance] setDelegate:nil];
    [LeanCloudManager sharedInstance].didReceiveTypedMessageCompletion = nil;
}

#pragma mark - LearnChat Message Handle Method

- (NSMutableArray *)filterTypedMessage:(NSArray *)messages {
    NSMutableArray *typedMessages = [NSMutableArray array];
    for (AVIMMessage *message in messages) {
        if ([message isKindOfClass:[AVIMTypedMessage class]]) {
            [typedMessages addObject:message];
        }
    }
    return typedMessages;
}

- (NSString *)fetchDataOfMessageFile:(AVFile *)file fileName:(NSString*)fileName error:(NSError**)error{
    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:fileName];
    NSData *data = [file getData:error];
    if(*error == nil) {
        [data writeToFile:path atomically:YES];
    }
    return path;
}

- (XHMessage *)displayMessageByAVIMTypedMessage:(AVIMTypedMessage*)typedMessage {
    AVIMMessageMediaType msgType = typedMessage.mediaType;
    XHMessage *message;
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:typedMessage.sendTimestamp/1000];
    NSString *displayName = [self displayNameByClientId:typedMessage.clientId];
    switch (msgType) {
        case kAVIMMessageMediaTypeText: {
            AVIMTextMessage *receiveTextMessage = (AVIMTextMessage *)typedMessage;
            message = [[XHMessage alloc] initWithText:receiveTextMessage.text sender:displayName timestamp:timestamp];
            break;
        }
        case kAVIMMessageMediaTypeImage: {
            AVIMImageMessage *imageMessage = (AVIMImageMessage *)typedMessage;
            message = [[XHMessage alloc] initWithPhoto:nil thumbnailUrl:imageMessage.file.url originPhotoUrl:nil sender:displayName timestamp:timestamp];
            break;
        }
        case kAVIMMessageMediaTypeAudio: {
            NSError *error;
            NSString *path = [self fetchDataOfMessageFile:typedMessage.file fileName:typedMessage.messageId error:&error];
            AVIMAudioMessage* audioMessage = (AVIMAudioMessage *)typedMessage;
            message = [[XHMessage alloc] initWithVoicePath:path voiceUrl:nil voiceDuration:[NSString stringWithFormat:@"%.1f",audioMessage.duration] sender:displayName timestamp:timestamp];
            break;
        }
        case kAVIMMessageMediaTypeEmotion: {
            AVFile *file = [AVFile fileWithURL:typedMessage.text];
            NSError *error;
            NSString *path = [self fetchDataOfMessageFile:file fileName:typedMessage.messageId error:&error];
            message = [[XHMessage alloc] initWithEmotionPath:path sender:displayName timestamp:timestamp];
            break;
        }
        case kAVIMMessageMediaTypeVideo: {
            AVIMVideoMessage *receiveVideoMessage=(AVIMVideoMessage*)typedMessage;
            NSString *format = receiveVideoMessage.format;
            NSError *error;
            NSString *path = [self fetchDataOfMessageFile:typedMessage.file fileName:[NSString stringWithFormat:@"%@.%@",typedMessage.messageId,format] error:&error];
            message = [[XHMessage alloc] initWithVideoConverPhoto:[XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:path] videoPath:path videoUrl:nil sender:displayName timestamp:timestamp];
            break;
        }
        case kAVIMMessageMediaTypeLocation: {
            AVIMLocationMessage *locationMessage = (AVIMLocationMessage *)typedMessage;
            NSString *text = locationMessage.text;
            CLLocation *location = [[CLLocation alloc]initWithLatitude:locationMessage.latitude longitude:locationMessage.longitude];
            message = [[XHMessage alloc] initWithLocalPositionPhoto:[UIImage imageNamed:@"Fav_Cell_Loc"] geolocations:text location:location sender:displayName timestamp:timestamp];
            break;
        }
        default:
            break;
    }
    NSString *myClientId = [LeanCloudManager sharedInstance].clientId;
    NSString *typedClientId = typedMessage.clientId;
    
    if (typedClientId != nil && ![typedClientId isEqualToString:myClientId]) {
        message.bubbleMessageType = XHBubbleMessageTypeReceiving;
        message.sender = @"receiver";
    } else {
        message.bubbleMessageType = XHBubbleMessageTypeSending;
        message.sender = @"sender";
    }
    
    message.avatarUrl = [self avatarUrlByClientId:typedMessage.clientId];
    if ([message.avatarUrl isEqualToString: @""]) {
        message.avatar = [UIImage imageNamed:@"avator.png"];
    }

    return message;
}

- (void)insertAVIMTypedMessage:(AVIMTypedMessage *)typedMessage {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XHMessage *message=[self displayMessageByAVIMTypedMessage:typedMessage];
        [weakSelf addMessage:message];
    });
    
    DBConversation *dbConversation = (DBConversation *)[DBConversation MR_findByAttribute:@"conversationId" withValue:self.conversation.conversationId].lastObject;
    if(dbConversation) {
        NSString *lastMsg = @"";
        AVIMMessageMediaType msgType = typedMessage.mediaType;
        if (msgType == kAVIMMessageMediaTypeAudio) {
            lastMsg = @"[voice]";
        } else if (msgType == kAVIMMessageMediaTypeText) {
            lastMsg = typedMessage.text;
        } else if (msgType == kAVIMMessageMediaTypeImage) {
            lastMsg = @"[image]";
        } else if (msgType == kAVIMMessageMediaTypeLocation) {
            lastMsg = @"[location]";
        } else if (msgType == kAVIMMessageMediaTypeEmotion) {
            lastMsg = @"[emotion]";
        }
        
        dbConversation.lattestMsg = lastMsg;
        dbConversation.lastTime = [[NSDate alloc]init];
        NSManagedObjectContext *context = dbConversation.managedObjectContext;
        [context MR_saveToPersistentStoreAndWait];
    }
}

- (BOOL)filterError:(NSError*)error {
    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:nil message:error.description delegate:nil
//                                  cancelButtonTitle:@"确定" otherButtonTitles:nil];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:nil message:@"Network fault" delegate:nil
                                  cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

#pragma mark - user info
/**
 * 配置头像
 */
- (NSString*)avatarUrlByClientId:(NSString*)clientId{
    NSString *avatarUrl = @"";
    
    if ([clientId isEqualToString:self.hostModel.accountId]) {
        avatarUrl = self.hostModel.headPortrait;
    }else if ([clientId isEqualToString: self.guestModel.accountId]) {
        avatarUrl = self.guestModel.headPortrait;
    }
    
    return avatarUrl;
}

/**
 * 配置用户名
 */
- (NSString*)displayNameByClientId:(NSString*)clientId{
    return clientId;
}

#pragma mark - XHMessageTableViewCell delegate

- (void)multiMediaMessageDidSelectedOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath onMessageTableViewCell:(XHMessageTableViewCell *)messageTableViewCell {
    UIViewController *disPlayViewController;
    switch (message.messageMediaType) {
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypePhoto: {
            DLog(@"message : %@", message.photo);
            DLog(@"message : %@", message.videoConverPhoto);
            XHDisplayMediaViewController *messageDisplayTextView = [[XHDisplayMediaViewController alloc] init];
            messageDisplayTextView.message = message;
            disPlayViewController = messageDisplayTextView;
            break;
        }
            break;
        case XHBubbleMessageMediaTypeVoice: {
            DLog(@"message : %@", message.voicePath);
            // Mark the voice as read and hide the red dot.
            message.isRead = YES;
            messageTableViewCell.messageBubbleView.voiceUnreadDotImageView.hidden = YES;
            
            [[XHAudioPlayerHelper shareInstance] setDelegate:(id<NSFileManagerDelegate>)self];
            if (_currentSelectedCell) {
                [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
            }
            if (_currentSelectedCell == messageTableViewCell) {
                [messageTableViewCell.messageBubbleView.animationVoiceImageView stopAnimating];
                [[XHAudioPlayerHelper shareInstance] stopAudio];
                self.currentSelectedCell = nil;
            } else {
                self.currentSelectedCell = messageTableViewCell;
                [messageTableViewCell.messageBubbleView.animationVoiceImageView startAnimating];
                [[XHAudioPlayerHelper shareInstance] managerAudioWithFileName:message.voicePath toPlay:YES];
            }
            break;
        }
        case XHBubbleMessageMediaTypeEmotion:
            DLog(@"facePath : %@", message.emotionPath);
            break;
        case XHBubbleMessageMediaTypeLocalPosition: {
            DLog(@"facePath : %@", message.localPositionPhoto);
            XHDisplayLocationViewController *displayLocationViewController = [[XHDisplayLocationViewController alloc] init];
            displayLocationViewController.message = message;
            disPlayViewController = displayLocationViewController;
            break;
        }
        default:
            break;
    }
    if (disPlayViewController) {
        [self.navigationController pushViewController:disPlayViewController animated:YES];
    }
}

- (void)didDoubleSelectedOnTextMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"text : %@", message.text);
    XHDisplayTextViewController *displayTextViewController = [[XHDisplayTextViewController alloc] init];
    displayTextViewController.message = message;
    [self.navigationController pushViewController:displayTextViewController animated:YES];
}

- (void)didSelectedAvatarOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath : %@", indexPath);
    
    TourRecordsViewController *personalVC = [[TourRecordsViewController alloc]init];
    XHBubbleMessageType bubbleMessageType = [message bubbleMessageType];
    NSString *userId = @"";
    if (bubbleMessageType == XHBubbleMessageTypeSending) {
        userId = self.hostModel.accountId;
    }else if (bubbleMessageType == XHBubbleMessageTypeReceiving){
        userId = self.guestModel.accountId;
    }
    personalVC.userId = userId;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)menuDidSelectedAtBubbleMessageMenuSelecteType:(XHBubbleMessageMenuSelecteType)bubbleMessageMenuSelecteType {
    
}

#pragma mark - XHAudioPlayerHelper Delegate

- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    if (!_currentSelectedCell) {
        return;
    }
    [_currentSelectedCell.messageBubbleView.animationVoiceImageView stopAnimating];
    self.currentSelectedCell = nil;
}

#pragma mark - XHEmotionManagerView DataSource

- (NSInteger)numberOfEmotionManagers {
    return self.emotionManagers.count;
}

- (XHEmotionManager *)emotionManagerForColumn:(NSInteger)column {
    return [self.emotionManagers objectAtIndex:column];
}

- (NSArray *)emotionManagersAtManager {
    return self.emotionManagers;
}

#pragma mark - XHMessageTableViewController Delegate

- (BOOL)shouldLoadMoreMessagesScrollToTop {
    return YES;
}

- (void)loadMoreMessagesScrollTotop {
    if (self.messages.count == 0) {
        return;
    } else {
        if (!self.loadingMoreMessage) {
            self.loadingMoreMessage = YES;
            XHMessage *message = self.messages[0];
            WEAKSELF
            [self.conversation queryMessagesBeforeId:nil timestamp:[message.timestamp timeIntervalSince1970]*1000 limit:kOnePageSize callback:^(NSArray *queryMessages, NSError *error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableArray *messages = [NSMutableArray array];
                    NSMutableArray *typedMessages = [self filterTypedMessage:queryMessages];
                    for(AVIMTypedMessage *typedMessage in typedMessages){
                        if (weakSelf) {
                            XHMessage *message = [weakSelf displayMessageByAVIMTypedMessage:typedMessage];
                            if (message) {
                                [messages addObject:message];
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf insertOldMessages:messages completion:^{
                            weakSelf.loadingMoreMessage = NO;
                        }];
                    });
                });
            }];
        }
    }
}
/**
 *  发送文本消息的回调方法
 *
 *  @param text   目标文本字符串
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    AVIMTextMessage *sendTextMessage = [AVIMTextMessage messageWithText:text attributes:nil];
    WEAKSELF
    [self.conversation sendMessage:sendTextMessage callback:^(BOOL succeeded, NSError *error) {
        if ([weakSelf filterError:error]) {
            [self insertAVIMTypedMessage:sendTextMessage];
            [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeText];
        }
    }];
}

/**
 *  发送图片消息的回调方法
 *
 *  @param photo  目标图片对象，后续有可能会换
 *  @param sender 发送者的名字
 *  @param date   发送时间
 */
- (void)didSendPhoto:(UIImage *)photo fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"tmp.jpg"];
    NSData* photoData=UIImageJPEGRepresentation(photo,0.8);
    [photoData writeToFile:filePath atomically:YES];
    
    AVFile *file = [AVFile fileWithData:photoData];
    WEAKSELF
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        AVIMImageMessage *sendPhotoMessage = [AVIMImageMessage messageWithText:nil file:file attributes:nil];
        [self insertAVIMTypedMessage:sendPhotoMessage];
        [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypePhoto];
        [self.conversation sendMessage:sendPhotoMessage callback:^(BOOL succeeded, NSError *error) {
            if([weakSelf filterError:error]) {
                
            }
        }];
    }];
    
//    AVIMImageMessage *sendPhotoMessage = [AVIMImageMessage messageWithText:nil attachedFilePath:filePath attributes:nil];
    
    
    
}

/**
 *  发送视频消息的回调方法
 *
 *  @param videoPath 目标视频本地路径
 *  @param sender    发送者的名字
 *  @param date      发送时间
 */
- (void)didSendVideoConverPhoto:(UIImage *)videoConverPhoto videoPath:(NSString *)videoPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    AVIMVideoMessage *sendVideoMessage = [AVIMVideoMessage messageWithText:nil attachedFilePath:videoPath attributes:nil];
    WEAKSELF
    [self insertAVIMTypedMessage:sendVideoMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVideo];
    [self.conversation sendMessage:sendVideoMessage callback:^(BOOL succeeded, NSError *error) {
        if ([weakSelf filterError:error]) {
            
        }
    }];
}

/**
 *  发送语音消息的回调方法
 *
 *  @param voicePath        目标语音本地路径
 *  @param voiceDuration    目标语音时长
 *  @param sender           发送者的名字
 *  @param date             发送时间
 */
- (void)didSendVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration fromSender:(NSString *)sender onDate:(NSDate *)date {
    AVIMAudioMessage* sendAudioMessage = [AVIMAudioMessage messageWithText:nil attachedFilePath:voicePath attributes:nil];
    WEAKSELF
    
    
    [self.conversation sendMessage:sendAudioMessage callback:^(BOOL succeeded, NSError *error) {
        DLog(@"succeed: %d, error:%@ ",succeeded,error);
        if([weakSelf filterError:error]){
            [self insertAVIMTypedMessage:sendAudioMessage];
            [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeVoice];
        }
    }];
}

/**
 *  发送第三方表情消息的回调方法
 *
 *  @param facePath 目标第三方表情的本地路径
 *  @param sender   发送者的名字
 *  @param date     发送时间
 */
- (void)didSendEmotion:(NSString *)emotionPath fromSender:(NSString *)sender onDate:(NSDate *)date {
    WEAKSELF
    AVFile *file = [AVFile fileWithName:@"emotion" contentsAtPath:emotionPath];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ([weakSelf filterError:error]) {
            AVIMEmotionMessage *sendEmotionMessage=[AVIMEmotionMessage messageWithText:file.url attributes:nil];
            
            [self insertAVIMTypedMessage:sendEmotionMessage];
            [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeEmotion];
            [weakSelf.conversation sendMessage:sendEmotionMessage callback:^(BOOL succeeded, NSError *error) {
                DLog(@"succeed: %d, error:%@ ",succeeded,error);
                if ([weakSelf filterError:error]) {
                    
                }
            }];
        }
    }];
}

/**
 *  有些网友说需要发送地理位置，这个我暂时放一放
 */
- (void)didSendGeoLocationsPhoto:(UIImage *)geoLocationsPhoto geolocations:(NSString *)geolocations location:(CLLocation *)location fromSender:(NSString *)sender onDate:(NSDate *)date {
//    XHMessage *geoLocationsMessage = [[XHMessage alloc] initWithLocalPositionPhoto:geoLocationsPhoto geolocations:geolocations location:location sender:sender timestamp:date];
//    geoLocationsMessage.avatarUrl = [self avatarUrlByClientId:sender];
//    [self addMessage:geoLocationsMessage];
//    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
//
    AVIMLocationMessage *locationMessage = [AVIMLocationMessage messageWithText:geolocations latitude:location.coordinate.latitude longitude:location.coordinate.longitude attributes:nil];
    WEAKSELF
    
    [self insertAVIMTypedMessage:locationMessage];
    [self finishSendMessageWithBubbleMessageType:XHBubbleMessageMediaTypeLocalPosition];
    
    [self.conversation sendMessage:locationMessage callback:^(BOOL succeeded, NSError *error) {
        if ([weakSelf filterError:error]) {
            
        }
    }];
}

/**
 *  是否显示时间轴Label的回调方法
 *
 *  @param indexPath 目标消息的位置IndexPath
 *
 *  @return 根据indexPath获取消息的Model的对象，从而判断返回YES or NO来控制是否显示时间轴Label
 */

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row >= self.messages.count) {
        return YES;
    } else {
        XHMessage *message = [self.messages objectAtIndex:indexPath.row];
        XHMessage *previousMessage = [self.messages objectAtIndex:indexPath.row-1];
        NSInteger interval = [message.timestamp timeIntervalSinceDate:previousMessage.timestamp];
        if (interval > 60 * 3) {
            return YES;
        } else {
            return NO;
        }
    }
}

/**
 *  配置Cell的样式或者字体
 *
 *  @param cell      目标Cell
 *  @param indexPath 目标Cell所在位置IndexPath
 */
- (void)configureCell:(XHMessageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

/**
 *  协议回掉是否支持用户手动滚动
 *
 *  @return 返回YES or NO
 */
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling {
    return YES;
}


@end
