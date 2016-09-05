//
//  GameQuestionPlayRoomViewController.swift
//  Whereami
//
//  Created by lens on 16/3/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import Social
import SVProgressHUD

public var screenWidth: CGFloat { get{ return UIScreen.mainScreen().bounds.width} }

class GameQuestionPlayRoomViewController: UIViewController {

    var questionHeadView:GameQuestionHeadView? = nil
    var answerBottomView:GameAnswerBottomView? = nil
    var evaluateBottomView:GameEvaluateBottomView? = nil
    var bottomScrollView:UIScrollView? = nil
    var battleModel:BattleModel? = nil
    var questionModel:QuestionModel? = nil
    var isClassic:Bool? = nil
    var hasNextQuestion:Bool? = nil
    var timer:NSTimer? = nil
    var answerTime:Int = 30
    var lastQuestionModel:QuestionModel? = nil
    var rightBarButtonItem:UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        if battleModel == nil{
           self.battleModel = GameParameterManager.sharedInstance.battleModel
        }
        self.questionModel = self.battleModel?.questions
        
        self.getGameModel()
        self.setUI()
        self.addTimer()
    }
    
    func getGameModel(){
        let gameMode = GameParameterManager.sharedInstance.gameMode
        if gameMode != nil{
            let gameModel = gameMode!["gameModel"] as! Int
            if gameModel == 1 {
                self.isClassic = true
            }
            else{
                self.isClassic = false
            }
        }
    }
    
    func setUI(){        
//        self.title = "\(self.answerTime)"
        self.title = "\((questionModel?.classificationName)! as String)"
        self.view.backgroundColor = UIColor.getGameColor()
        self.navigationItem.hidesBackButton = false
        
//        let leftBarButtonItem = UIButton()
//        leftBarButtonItem.layer.borderWidth = 1.0
//        leftBarButtonItem.layer.borderColor = UIColor.whiteColor().CGColor
//        leftBarButtonItem.setBackgroundImage(UIImage(named: "temp3"), forState: .Normal)
//        leftBarButtonItem.layer.masksToBounds = true
//        leftBarButtonItem.layer.cornerRadius = 15
//        leftBarButtonItem.layer.bounds = CGRectMake(0, 0, 30, 30)
        self.navigationItem.hidesBackButton = true

        rightBarButtonItem = UIButton()
        rightBarButtonItem?.enabled = false
//        rightBarButtonItem.layer.borderWidth = 1.0
//        rightBarButtonItem.layer.borderColor = UIColor.whiteColor().CGColor
//        rightBarButtonItem.setBackgroundImage(UIImage(named: "temp4"), forState: .Normal)
//        rightBarButtonItem.layer.masksToBounds = true
//        rightBarButtonItem.layer.cornerRadius = 15
        rightBarButtonItem?.setTitle("\(answerTime as Int)", forState: .Normal)
        rightBarButtonItem?.layer.bounds = CGRect(x: 0,y: 0,width: 30,height: 30)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItem!)
        
        self.bottomScrollView = UIScrollView()
        self.bottomScrollView?.scrollEnabled = false
        self.bottomScrollView?.pagingEnabled = true
        self.bottomScrollView?.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.bottomScrollView!)
        
        self.questionHeadView = GameQuestionHeadView()
        self.questionHeadView?.backgroundColor = UIColor.clearColor()
        self.questionHeadView?.QuestionTitle?.text = questionModel?.content
//        self.questionHeadView?.callBack = {() -> Void in
//            
//        }
        let picUrl = questionModel?.pictureUrl
        if picUrl != nil {
            self.getPictureContent(picUrl!)
        }
        else{
            self.getPictureContent("")
        }
        
        self.view.addSubview(self.questionHeadView!)
        
        let answerArray = (self.questionModel?.answers)! as [AnswerModel]
        self.answerBottomView = GameAnswerBottomView()
        self.answerBottomView?.callBack = {(button) -> Void in
            self.answerButtonClick(button)
        }
        self.answerBottomView?.backgroundColor = UIColor.clearColor()
        self.answerBottomView?.answerBtn1?.setTitle(answerArray[0].content, forState: .Normal)
        self.answerBottomView?.answerBtn2?.setTitle(answerArray[1].content, forState: .Normal)
        self.answerBottomView?.answerBtn3?.setTitle(answerArray[2].content, forState: .Normal)
        self.answerBottomView?.answerBtn4?.setTitle(answerArray[3].content, forState: .Normal)
        self.bottomScrollView!.addSubview(self.answerBottomView!)
        
        self.evaluateBottomView = GameEvaluateBottomView()
        self.evaluateBottomView?.creatorAvatar?.image = UIImage(named: "temp4")
        self.evaluateBottomView?.callBack = {(button) -> Void in
            self.evaluateButtonClick(button)
        }
        self.bottomScrollView?.addSubview(self.evaluateBottomView!)
        
        self.questionHeadView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        self.questionHeadView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.questionHeadView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        self.questionHeadView?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.bottomScrollView!)
        self.questionHeadView?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.bottomScrollView!)
//        self.questionHeadView?.autoSetDimension(.Height, toSize: screenH * 0.6)
        
        self.bottomScrollView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        self.bottomScrollView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.bottomScrollView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        self.answerBottomView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.answerBottomView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        self.answerBottomView?.autoPinEdge(.Right, toEdge: .Left, ofView: self.evaluateBottomView!)
        self.answerBottomView?.autoSetDimension(.Width, toSize: screenWidth)
        self.answerBottomView?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.questionHeadView!)
//        self.answerBottomView?.autoSetDimension(.Height, toSize: screenH * 0.4)
        
        self.evaluateBottomView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        self.evaluateBottomView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        self.evaluateBottomView?.autoSetDimension(.Width, toSize: screenWidth)
        self.evaluateBottomView?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.questionHeadView!)
//        self.evaluateBottomView?.autoSetDimension(.Height, toSize: screenH * 0.4)
    }
    
    func addTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.answerTimeChange), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func answerTimeChange(){
        self.answerTime -= 1
        rightBarButtonItem?.setTitle("\(answerTime as Int)", forState: .Normal)
        
        if self.answerTime <= 0{
            let button = UIButton()
            button.tag = 100
            self.answerButtonClick(button)
        }
    }
    
    func getPictureContent(pictureUrl:String){
        let url = pictureUrl.toUrl()
        self.questionHeadView?.QuestionPicture?.kf_setImageWithURL(url, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func collectPhoto(){
        var dict = [String: AnyObject]()
        dict["picId"] = questionModel?.pictureUrl
        dict["accountId"] = UserModel.getCurrentUser()?.id
        SocketManager.sharedInstance.sendMsg("collectPhoto", data: dict, onProto: "collectPhotoed") { (code, objs) in
            if code == statusCode.Normal.rawValue{
                
            }
        }
    }
    
    func answerButtonClick(button:UIButton){
        let tag = button.tag
        var answerArray = (self.questionModel?.answers)! as [AnswerModel]
        let count = answerArray.count
        var rightArray = [AnyObject]()
        var wrongArray = [AnyObject]()
        var wrongIndex = 0
        var rightIndex = 0
        for i in 0...count-1 {
            let isRight = answerArray[i].result
            if isRight == 0 {
                let dic = ["answer":answerArray[i],"tag":i+1]
                wrongArray.append(dic)
                wrongIndex = Int(arc4random()%2)
            }
            else{
                rightArray.append(answerArray[i])
                rightIndex = i+1
            }
        }
        
        switch tag {
        case 5:
            for i in 0...wrongArray.count-1{
                let dic = wrongArray[i]
                if i != wrongIndex {
                    let wrongButton = self.answerBottomView?.viewWithTag(dic["tag"] as! Int) as! UIButton
                    wrongButton.backgroundColor = UIColor.redColor()
                    wrongButton.enabled = false
                }
            }
            
        case 6:
            self.answerTime += 15
            rightBarButtonItem?.setTitle("\(answerTime as Int)", forState: .Normal)
            
        case 7:
            let rightButton = self.answerBottomView?.viewWithTag(rightIndex) as! UIButton
            self.answerProblem(rightButton)
            
        default:
            self.answerProblem(button)
        }
        
        button.enabled = false
    }
    
    func answerProblem(button:UIButton){
        let tag = button.tag
        var costtime = 30-answerTime
        if costtime<0 {
            costtime = 0
        }
        
        var dict = [String:AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["battleId"] = self.battleModel?.battleId
        dict["problemId"] = self.battleModel?.questions?.id
        dict["costtime"] = costtime
        dict["answerId"] = ""
        
        self.lastQuestionModel = self.battleModel?.questions
        
        var answerArray = (self.questionModel?.answers)! as [AnswerModel]
        if tag != 100 {
            let isRight = answerArray[tag-1].result
            if isRight == 0 {
                button.backgroundColor = UIColor(red: 244/255.0, green: 106/255.0, blue: 110/255.0, alpha: 1)
                let count = self.answerBottomView!.answerButtonArray!.count
                for i in 0...count-1 {
                    let item = self.answerBottomView?.answerButtonArray![i]
                    let btn = item as! UIButton
                    if answerArray[i].result == 1 {
                        btn.backgroundColor = UIColor(red: 148/255.0, green: 235/255.0, blue: 65/255.0, alpha: 1)
                    }
                    btn.enabled = false
                }
            }
            else{
                button.backgroundColor = UIColor.greenColor()
                for item in (self.answerBottomView?.answerButtonArray)!{
                    let btn = item as! UIButton
                    btn.enabled = false
                }
            }
            dict["answerId"] = answerArray[tag-1].id
        }
        
        self.timer?.invalidate()
        self.timer = nil
        
        SocketManager.sharedInstance.sendMsg("answerProblem", data: dict, onProto: "answerProblemed") { (code, objs) in
            if code == 100 || code == 300 {
                self.runInMainQueue({
                    let alertController = UIAlertController(title: "", message: NSLocalizedString("endGame",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
                    let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (confirmAction) in
                        self.hasNextQuestion = false
                        self.title = "\((self.questionModel?.classificationName)! as String)"
                        let shareBarButton = UIBarButtonItem.init(image: UIImage(named: "share"), style: .Done, target: self, action: #selector(self.share))
                        self.navigationItem.rightBarButtonItem = shareBarButton
                        self.bottomScrollView?.contentOffset = CGPoint(x: screenWidth,y: 0)
                    })
                    alertController.addAction(confirmAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
            if code == statusCode.Normal.rawValue {
                print("===============\(objs)")
                self.runInMainQueue({
                    self.title = "\((self.questionModel?.classificationName)! as String)"
                    let shareBarButton = UIBarButtonItem.init(image: UIImage(named: "share"), style: .Done, target: self, action: #selector(self.share))
                    self.navigationItem.rightBarButtonItem = shareBarButton
                    self.bottomScrollView?.contentOffset = CGPoint(x: screenWidth,y: 0)
                })
                
                if objs[0]["problemId"] as! String != "" {
                    self.hasNextQuestion = true
                    self.evaluateBottomView?.continueButton?.enabled = false
                    var dict = [String: AnyObject]()
                    dict["battleId"] = objs[0]["battleId"]
                    dict["questionId"] = objs[0]["problemId"]
                    
                    SocketManager.sharedInstance.sendMsg("queryProblemById", data: dict, onProto: "queryProblemByIded") { (code, objs) in
                        if code == statusCode.Normal.rawValue {
                            self.evaluateBottomView?.continueButton?.enabled = true
                            let battleModel = BattleModel.getModelFromDictionary(objs[0] as! NSDictionary)
                            self.battleModel = battleModel
                            self.questionModel = self.battleModel?.questions
                            answerArray = (self.questionModel?.answers)! as [AnswerModel]
                            
                            self.runInMainQueue({
                                let count = self.answerBottomView!.answerButtonArray!.count
                                for i in 0..<count {
                                    let item = self.answerBottomView?.answerButtonArray![i]
                                    let btn = item as! UIButton
                                    btn.backgroundColor = UIColor.whiteColor()
                                    btn.enabled = true
                                    btn.setTitle(answerArray[i].content, forState: .Normal)
                                }
                            })
                        }
                    }
                }
                else{
                    self.hasNextQuestion = false
                }
            }
        }
    }
    
    func evaluateButtonClick(button:UIButton){
        switch button.tag {
        case GameButtonType.Continue.rawValue:
            if hasNextQuestion == true {
                self.evaluateBottomView?.boringButton?.enabled = true
                self.evaluateBottomView?.interestingButton?.enabled = true
                
                self.questionHeadView?.QuestionTitle?.text = self.questionModel?.content
                let picUrl = questionModel?.pictureUrl
                if picUrl != nil {
                    self.getPictureContent(picUrl!)
                }
                else{
                    self.getPictureContent("")
                }

                self.bottomScrollView?.contentOffset = CGPoint(x: 0,y: 0)
                self.answerTime = 30
                self.title = "\(self.answerTime)"
                self.addTimer()
            }
            else{
                self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            
        case GameButtonType.Collect.rawValue:
            self.collectPhoto()

        case GameButtonType.Boring.rawValue:
            self.evaluateBottomView?.boringButton?.enabled = false
            self.evaluateBottomView?.interestingButton?.enabled = false
            var dict = [String: AnyObject]()
            if self.lastQuestionModel != nil {
                dict["problemId"] = self.lastQuestionModel?.id
            }
            SocketManager.sharedInstance.sendMsg("boring", data: dict)
            
        case GameButtonType.Fun.rawValue:
            self.evaluateBottomView?.boringButton?.enabled = false
            self.evaluateBottomView?.interestingButton?.enabled = false
            var dict = [String: AnyObject]()
            if self.lastQuestionModel != nil {
                dict["problemId"] = self.lastQuestionModel?.id
            }
            SocketManager.sharedInstance.sendMsg("interesting", data: dict)
            
        default:
            let reportVC = GameReportViewController()
            if self.lastQuestionModel != nil {
                reportVC.problemId = self.lastQuestionModel?.id
            }
            self.navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    func share(){
        guard SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) else{
            let alertController = UIAlertController(title: "tips", message: "请在设置中添加facebook账号", preferredStyle: .Alert)
            let setAction = UIAlertAction(title: "设置", style: .Default, handler: { (action) in
                UIApplication.sharedApplication().openURL(NSURL(string: "prefs:root=FACEBOOK")!)
            })
            let cancelAction = UIAlertAction(title: "稍后", style: .Cancel, handler: { (action) in
                self.presentActivityVC()
            })
            alertController.addAction(setAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        self.presentActivityVC()
    }
    
    func presentActivityVC(){
        //        let text = "说点什么吧..."
        //        let image = UIImage(named: "personal_back")
        let url =  NSURL(string: "http://www.baidu.com")
        //        let activityItems = [text,image!,url!] as [AnyObject]
        let activityVC = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop]
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func consumeItem(code:String){
        let currentUser = UserModel.getCurrentUser()?.id
        
        var dict = [String: AnyObject]()
        dict["accountId"] = currentUser
        dict["code"] = code
        dict["itemNum"] = -1
        
        var arr = NSUserDefaults.standardUserDefaults().objectForKey("gainItems") as? [AnyObject]
        if arr == nil {
            arr = [AnyObject]()
        }
        
        var json:NSData? = nil
        do {
            json = try NSJSONSerialization.dataWithJSONObject(dict, options: .PrettyPrinted)
            arr!.append(json!)
            NSUserDefaults.standardUserDefaults().setObject(arr, forKey: "gainItems")
        }catch{
            
        }
        
        SocketManager.sharedInstance.sendMsg("gainItems", data: dict, onProto: "gainItemsed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                for (index, value) in arr!.enumerate() {
                    if value.isEqual(json!) {
                        arr?.removeAtIndex(index)
                        NSUserDefaults.standardUserDefaults().setObject(arr, forKey: "gainItems")
                        break
                    }
                }
            }else{

            }
        }
        
        let item = CoreDataManager.sharedInstance.fetchItemByIdAndCode(currentUser!, code: code)
        guard item != nil else {
            return
        }
        item?.itemNum = (item?.itemNum)! - 1
        CoreDataManager.sharedInstance.increaseOrUpdateAccItem(item!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
