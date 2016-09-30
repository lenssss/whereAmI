//
//  GameClassicBattleDetailsViewController.swift
//  Whereami
//
//  Created by lens on 16/3/24.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
//import MBProgressHUD
import SVProgressHUD

class GameClassicBattleDetailsViewController: UIViewController {
    var headTitle:String? = nil
    var battleDetailView:BattleDetailView? = nil
    var wheelView:UIView? = nil
    var quitButton:UIButton? = nil
    var countButton:UIButton? = nil
    private var wheelVC:GameClassicWheelViewController? = nil
    
    var matchUser:FriendsModel? = nil //匹配对手
    var currentUser:UserModel? = nil //当前用户
    var matchDetailModel:MatchDetailModel? = nil //匹配对战信息
    var isRandom:Bool? = nil //是否挑战
    var kindModel:GameKindModel? = nil //题目类别
    var battle:BattleModel? = nil //战斗信息
    var isWaiting:Bool? = false //是否等待
    var waitingDetails:BattleEndModel? = nil //等待时的对手信息
    
    override func viewDidLoad() {
        
        self.setConfig()
        
        self.currentUser = UserModel.getCurrentUser()
        if GameParameterManager.sharedInstance.gameMode != nil {
            self.getGameModel()
            if isRandom == true {
                self.matchUser = nil
            }
            else{
                self.matchUser = GameParameterManager.sharedInstance.matchUser![0]
            }
        }
        
        self.setUI()
        
        if isWaiting == true {
            self.setWaitingUI()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isWaiting == false {
            self.startGame()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func getGameModel(){
        let gameMode = GameParameterManager.sharedInstance.gameMode
        let gameModel = gameMode!["competitor"] as! Int
        if gameModel == 3 {
            self.isRandom = false
        }
        else{
            self.isRandom = true
        }
    }
    
    func setUI(){
        //self.title = "第1回合"
        self.view.backgroundColor = UIColor.getGameColor()
        
        let backBtn = TheBackBarButton.initWithAction({
            self.backAction()
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        let rightImage = UIImage(named: "chatBtn")?.resizedImage(CGSize(width: 30, height: 30), interpolationQuality: .Default)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage, style: .Done, target: self, action: #selector(self.pushToChat))
        
        self.battleDetailView = BattleDetailView()
        self.battleDetailView?.layer.masksToBounds = true
        self.battleDetailView?.layer.cornerRadius = 20

        let currentAvatar = ""
        let matchAvatar = ""
        self.battleDetailView?.currentUserAvatar?.kf_setImageWithURL(NSURL(string:currentAvatar)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        self.battleDetailView?.matchUserAvatar?.kf_setImageWithURL(NSURL(string:matchAvatar)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        self.battleDetailView?.currentUserName?.text = "..."
        self.battleDetailView?.matchUserName?.text = "..."
        self.view.addSubview(self.battleDetailView!)
        
        self.battleDetailView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        self.battleDetailView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 5)
        self.battleDetailView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 5)
        self.battleDetailView?.autoSetDimension(.Height, toSize: 80)
        
        self.addWheelView()
        
        self.quitButton = UIButton(type: .System)
        self.quitButton?.layer.masksToBounds = true
        self.quitButton?.layer.cornerRadius = 10
        self.quitButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.quitButton?.setBackgroundImage(UIImage(named: "quit"), forState: .Normal)
        self.view.addSubview(self.quitButton!)
        
        self.quitButton?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20)
        self.quitButton?.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        self.quitButton?.autoSetDimensionsToSize(CGSize(width: 100,height: 50))
        
        self.countButton = UIButton(type: .System)
        self.countButton?.layer.masksToBounds = true
        self.countButton?.layer.cornerRadius = 10
        self.countButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.countButton?.setBackgroundImage(UIImage(named: "count"), forState: .Normal)
        self.view.addSubview(self.countButton!)
        
        self.countButton?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20)
        self.countButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
        self.countButton?.autoSetDimensionsToSize(CGSize(width: 100,height: 50))
    }
    
    func setWaitingUI(){
        self.wheelView?.userInteractionEnabled = false
        self.wheelVC?.startButton?.setTitle("waiting", forState: .Normal)
        
        let current = waitingDetails?.accounts![0] as? BattleEndDetailModel
        let match = waitingDetails?.accounts![1] as? BattleEndDetailModel
        
        self.battleDetailView?.currentUserName?.text = current?.nickname
        self.battleDetailView?.matchUserName?.text = match?.nickname
        self.battleDetailView?.currentUserAvatar?.kf_setImageWithURL(NSURL(string:(current?.headPortrait)!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        self.battleDetailView?.matchUserAvatar?.kf_setImageWithURL(NSURL(string:(match?.headPortrait)!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        
        let rightImage = UIImage(named: "chatBtn")?.imageWithColor(UIColor.whiteColor())
        let button = UIButton()
        button.bounds = CGRect(x: 0,y: 0,width: 30,height: 30)
        button.setBackgroundImage(rightImage, forState: .Normal)
        button.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            if current?.accountId != UserModel.getCurrentUser()?.id {
                self.pushToChatwithId((current?.accountId)!, headPortrait: (current?.headPortrait)!, nickname: (current?.nickname)!)
            }
            else{
                self.pushToChatwithId((match?.accountId)!, headPortrait: (match?.headPortrait)!, nickname: (match?.nickname)!)
            }
            
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func startGame(){
        if battle != nil {
            GameParameterManager.sharedInstance.battleModel = battle
            let kinds = FileManager.sharedInstance.readGameKindListFromFile()
            for item in kinds! {
                if item.kindCode == battle!.questions!.classificationCode {
                    self.kindModel = item
                    self.wheelVC!.continent = self.kindModel?.kindCode
                    self.wheelView?.userInteractionEnabled = true
                }
            }
        }
        else{
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.Gradient)
            if self.matchDetailModel == nil {
                var dict = [String: AnyObject]()
                dict["countryCode"] = GameParameterManager.sharedInstance.gameRange?.countryCode
                dict["accountId"] = UserModel.getCurrentUser()?.id
                if self.matchUser != nil {
                    dict["friendId"] = [["id": (matchUser?.friendId)!]] as [AnyObject]
                    SocketManager.sharedInstance.sendMsg("startClassicFriendBattle", data: dict, onProto: "startClassicFriendBattleed") { (code, objs) in
                        if code == statusCode.Normal.rawValue{
//                            CoreDataManager.sharedInstance.consumeLifeItem()
                            print("=====================\(objs)")
                            self.matchDetailModel = MatchDetailModel.getModelFromDictionary(objs[0] as! [String : AnyObject])
                            GameParameterManager.sharedInstance.matchDetailModel = self.matchDetailModel
                            self.queryProblemById()
                        }
                        else if code == statusCode.Error.rawValue {
                            self.runInMainQueue({
                                SVProgressHUD.showErrorWithStatus("error")
                                self.performSelector(#selector(self.SVProgressDismiss), withObject: nil, afterDelay: 1)
                            })
                        }
                    }
                }
                else{
                    SocketManager.sharedInstance.sendMsg("startClassicRandomBattle", data: dict, onProto: "startClassicRandomBattleed") { (code, objs) in
                        if code == statusCode.Normal.rawValue{
//                            CoreDataManager.sharedInstance.consumeLifeItem()
                            print("=====================\(objs)")
                            self.matchDetailModel = MatchDetailModel.getModelFromDictionary(objs[0] as! [String : AnyObject])
                            GameParameterManager.sharedInstance.matchDetailModel = self.matchDetailModel
                            self.queryProblemById()
                        }
                        else if code == statusCode.Error.rawValue {
                            self.runInMainQueue({
                                SVProgressHUD.showErrorWithStatus("error")
                                self.performSelector(#selector(self.SVProgressDismiss), withObject: nil, afterDelay: 1)
                            })
                        }
                    }
                }
            }
            else{
                GameParameterManager.sharedInstance.matchDetailModel = self.matchDetailModel
                self.queryProblemById()
            }
        }
    }
    
    func queryProblemById(){
        var dict = [String: AnyObject]()
        dict["battleId"] = self.matchDetailModel?.battleId
        dict["questionId"] = self.matchDetailModel?.problemId
        
        SocketManager.sharedInstance.sendMsg("queryProblemById", data: dict, onProto: "queryProblemByIded") { (code, objs) in
            print("=======================\(objs)")
            self.runInMainQueue({
                SVProgressHUD.dismiss()
            })
            
            if code == statusCode.Normal.rawValue {
                let battleModel = BattleModel.getModelFromDictionary(objs[0] as! NSDictionary)
                GameParameterManager.sharedInstance.battleModel = battleModel
                self.runInMainQueue({
                    let kinds = FileManager.sharedInstance.readGameKindListFromFile()
                    for item in kinds! {
                        if item.kindCode == battleModel.questions!.classificationCode {
                            self.kindModel = item
                            self.wheelVC!.continent = self.kindModel?.kindCode
                            self.wheelView?.userInteractionEnabled = true
                            break
                        }
                    }
                    if self.kindModel == nil {
                        let alertController = UIAlertController(title: "", message: "数据异常", preferredStyle: .Alert)
                        let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (confirmAction) in
                            let index = self.navigationController?.viewControllers.count
                            if index != 1 {
                                let viewController = self.navigationController?.viewControllers[index!-2]
                                self.navigationController?.popToViewController(viewController!, animated: true)
                            }
                            else{
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        })
                        alertController.addAction(confirmAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    let array = self.matchDetailModel?.acceptInfo as! [AcceptInfoModel]
//                    var currentId = self.currentUser?.id
                    var matchId = array[0].accountId
                    var currentName = self.currentUser?.nickname
                    var matchName = array[0].nickname
                    var currentAvatar = self.currentUser?.headPortraitUrl != nil ? self.currentUser?.headPortraitUrl : ""
                    var matchAvatar = array[0].headPortrait != nil ? array[0].headPortrait : ""
                    if self.matchDetailModel?.acceptInfo?.count == 2 {
//                        currentId = array[1].accountId
                        matchId = array[0].accountId
                        currentName = array[1].nickname
                        matchName = array[0].nickname
                        currentAvatar = array[1].headPortrait != nil ? array[1].headPortrait : ""
                        matchAvatar = array[0].headPortrait != nil ? array[0].headPortrait : ""
                    }
                    
                    if self.matchUser == nil {
                        self.matchUser = FriendsModel()
                        self.matchUser?.friendId = matchId
                        self.matchUser?.nickname = matchName
                        self.matchUser?.headPortrait = matchAvatar
                    }
                    
                    self.battleDetailView?.currentUserName?.text = currentName
                    self.battleDetailView?.matchUserName?.text = matchName
                    self.battleDetailView?.currentUserAvatar?.kf_setImageWithURL(NSURL(string:currentAvatar!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                    self.battleDetailView?.matchUserAvatar?.kf_setImageWithURL(NSURL(string:matchAvatar!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                })
            }
        }
    }
    
    func pushToStartGameVC(){
        self.wheelView?.removeFromSuperview()
        self.addWheelView()
        self.runInMainQueue({
            let startGameVC = GameClassicStartGameViewController()
            self.navigationController?.pushViewController(startGameVC, animated: true)
        })
    }
    
    func pushToChat(){
        print(matchUser?.friendId)
        let friendModel:FriendsModel = matchUser!
        let currentUser = UserModel.getCurrentUser()
        let guestUser = ChattingUserModel()
        let hostUser = ChattingUserModel()
        
        guestUser.accountId = friendModel.friendId
        guestUser.headPortrait = friendModel.headPortrait
        guestUser.nickname = friendModel.nickname
        
        hostUser.accountId = currentUser?.id
        hostUser.headPortrait = currentUser?.headPortraitUrl
        hostUser.nickname = currentUser?.nickname
        
        LeanCloudManager.sharedInstance.createConversitionWithClientIds(guestUser.accountId!, clientIds: [guestUser.accountId!]) { (succed, conversion) in
            if(succed) {
                CoreDataConversationManager.sharedInstance.increaseOrCreateUnreadCountByConversation( conversion!, lastMsg: "", msgType: kAVIMMessageMediaTypeText)
                
                self.push2ConversationVC(conversion!, hostUser: hostUser, guestUser: guestUser)
            }
        }
    }
    
    func pushToChatwithId(id:String,headPortrait:String,nickname:String){
        print(matchUser?.friendId)
        let currentUser = UserModel.getCurrentUser()
        let guestUser = ChattingUserModel()
        let hostUser = ChattingUserModel()
        
        guestUser.accountId = id
        guestUser.headPortrait = headPortrait
        guestUser.nickname = nickname
        
        hostUser.accountId = currentUser?.id
        hostUser.headPortrait = currentUser?.headPortraitUrl
        hostUser.nickname = currentUser?.nickname
        
        LeanCloudManager.sharedInstance.createConversitionWithClientIds(guestUser.accountId!, clientIds: [guestUser.accountId!]) { (succed, conversion) in
            if(succed) {
                CoreDataConversationManager.sharedInstance.increaseOrCreateUnreadCountByConversation( conversion!, lastMsg: "", msgType: kAVIMMessageMediaTypeText)
                
                self.push2ConversationVC(conversion!, hostUser: hostUser, guestUser: guestUser)
            }
        }
    }
    
    func push2ConversationVC(conversion:AVIMConversation,hostUser:ChattingUserModel,guestUser:ChattingUserModel) {
        let conversationVC = ConversationViewController()
        conversationVC.conversation = conversion
        conversationVC.hostModel = hostUser
        conversationVC.guestModel = guestUser
        conversationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func addWheelView(){
        wheelVC = GameClassicWheelViewController()
        wheelVC!.startAction = {() -> Void in
            self.navigationItem.rightBarButtonItem?.enabled = false
            self.navigationItem.leftBarButtonItem?.enabled = false
        }
        wheelVC!.completion = {() -> Void in
            self.performSelector(#selector(self.pushToStartGameVC), withObject: nil, afterDelay: 0.5)
            self.navigationItem.rightBarButtonItem?.enabled = true
            self.navigationItem.leftBarButtonItem?.enabled = true
        }
        self.addChildViewController(wheelVC!)
        self.wheelView = wheelVC!.view
        self.wheelView?.userInteractionEnabled = false
        self.view.addSubview(self.wheelView!)
        
        self.wheelView?.autoCenterInSuperview()
        self.wheelView?.autoSetDimension(.Width, toSize: UIScreen.mainScreen().bounds.width - 40)
        self.wheelView?.autoSetDimension(.Height, toSize: UIScreen.mainScreen().bounds.width - 40)
    }
    
    func SVProgressDismiss(){
        SVProgressHUD.dismiss()
        self.backAction()
    }
    
    func backAction(){
        let viewControllers = self.navigationController?.viewControllers
        if viewControllers?.count != 1 {
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
