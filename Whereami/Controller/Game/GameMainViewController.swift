//
//  GameMainViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/16.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import GoogleMobileAds
import PureLayout
import MJRefresh
import SVProgressHUD
import SocketIOClientSwift

class GameMainViewController: UIViewController,HHPanningTableViewCellDelegate,GADBannerViewDelegate,GADInterstitialDelegate,UITableViewDelegate,UITableViewDataSource,BannerViewDelegate,UINavigationControllerDelegate {
    
    var tempConstraint:NSLayoutConstraint? = nil

    private var adBannerView:GADBannerView? = nil
    private var adInterstitial:GADInterstitial? = nil
    private var assetsItems:AssetsItemsView? = nil
    var tableView:UITableView? = nil
    var battleList:BattleAllModel? = nil
    var life:Int = 0
    var chance:Int = 0
    var diamond:Int = 0
    var gold:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
//        self.title = NSLocalizedString("Game",tableName:"Localizable", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.customFontWithStyle("Bold", size:18.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        // Do any additional setup after loading the view.
        self.setupAD()
        self.setupUI()
        self.navigationController!.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard UserModel.getCurrentUser() != nil else{
            return
        }
        self.setTableViewHeight()
        self.getBattleList()
        self.getAccItems()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        guard self.adBannerView!.hidden else{
            self.adBannerView!.hidden = false
            return
        }
        SVProgressHUD.dismiss()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.adBannerView!.hidden {
            self.adBannerView!.hidden = false
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(KNotificationMainViewDidShow, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: UI
    //设置广告 
    func setupAD() {
        self.adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        self.navigationController?.navigationBar.addSubview(self.adBannerView!)
        self.adBannerView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        self.adBannerView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.adBannerView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        self.adBannerView?.autoSetDimension(.Height, toSize: 44)
        
        self.adBannerView?.delegate = self
        self.adBannerView?.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.adBannerView?.rootViewController = self
        self.adBannerView?.loadRequest(GADRequest())
        
        self.adInterstitial = GADInterstitial(adUnitID:"ca-app-pub-3940256099942544/4411468910")
        self.adInterstitial?.delegate = self
        self.adInterstitial?.loadRequest(GADRequest())
    }
    
    //设置UI
    func setupUI() {
        assetsItems = AssetsItemsView()
        self.updateAssetsItemsView()
        self.view.addSubview(assetsItems!)
        
        self.assetsItems?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        self.assetsItems?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.assetsItems?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        self.assetsItems?.autoSetDimension(.Height, toSize: 44)
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.getBattleList))
        
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .None
        self.tableView?.mj_header = header
        self.view.addSubview(self.tableView!)
        
        self.tableView?.autoPinEdgeToSuperviewEdge(.Left)
        self.tableView?.autoPinEdgeToSuperviewEdge(.Right)
        self.tableView?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.assetsItems!)
        
        self.tableView?.registerClass(ScrollBannersTableViewCell.self, forCellReuseIdentifier: "ScrollBannersTableViewCell")
        self.tableView?.registerClass(RankTableViewCell.self, forCellReuseIdentifier: "RankTableViewCell")
        self.tableView?.registerClass(GameStatusTableViewCell.self, forCellReuseIdentifier: "GameStatusTableViewCell")
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "GameMoreStatusTableViewCell")
    }
    
    func updateAssetsItemsView(){
        assetsItems?.assetsButton1?.count?.text = "\(life)"
        assetsItems?.assetsButton2?.count?.text = "\(chance)"
        assetsItems?.assetsButton3?.count?.text = "\(diamond)"
        assetsItems?.assetsButton4?.count?.text = "\(gold)"
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool){
        if viewController.isKindOfClass(GameMainViewController.self) {
            self.adBannerView?.hidden = false
            self.navigationController?.navigationBar.backgroundColor = UIColor.getNavigationBarColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        }else {
            self.adBannerView?.hidden = true
            self.navigationController?.navigationBar.backgroundColor = UIColor.getGameColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.getGameColor()
        }
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool){
        if viewController.isKindOfClass(GameMainViewController.self) {
            self.adBannerView?.hidden = false
            self.navigationController?.navigationBar.backgroundColor = UIColor.getNavigationBarColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        }else {
            self.adBannerView?.hidden = true
            self.navigationController?.navigationBar.backgroundColor = UIColor.getGameColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.getGameColor()
        }
    }
    
    func setTableViewHeight(){
        let tabbarH = CGRectGetHeight((self.tabBarController?.tabBar.frame)!)
        let screenH = UIScreen.mainScreen().bounds.height
        let viewH = screenH-64-tabbarH-44
        self.tableView?.autoSetDimension(.Height, toSize: viewH)
    }
    
// MARK: GetDataSource
    //获取战斗列表
    func getBattleList(){
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["page"] = 1
        dict["type"] = "all"
        
        SocketManager.sharedInstance.sendMsg("queryBattleList", data: dict, onProto: "queryBattleListed") { (code, objs) in
            if code == statusCode.Normal.rawValue{
                self.battleList = BattleAllModel.getModelFromObject(objs)
                self.runInMainQueue({
                    self.tableView?.reloadData()
                    self.tableView?.mj_header.endRefreshing()
                })
            }
        }
    }
    
    //战斗列表分类
    func getModelArray(slideItemView:SlideItemView) -> [AnyObject] {
        var modelArray = [AnyObject]()
        if slideItemView.section == 2{
            modelArray = (self.battleList?.battle)!
        }
        else if slideItemView.section == 3{
            modelArray = (self.battleList?.turn)!
        }
        else{
            modelArray = (self.battleList?.ends)!
        }
        return modelArray
    }
    
    //获取个人道具
    func getAccItems(){
        AccItems.getAccItemsWithCompletion { (items) in
            for item in items! {
                if item.itemCode == "life" {
                    self.life = item.itemNum!
                }
            }
            self.updateAssetsItemsView()
        }
    }
    
// MARK: UITableViewDataSource,UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard UserModel.getCurrentUser() != nil else{
            return 0
        }
        
        if section == 0 || section == 1 {
            return 1
        }else{
            if battleList != nil{
                if section == 2 {
                    if battleList?.battle?.count > 3 {
                        return 3
                    }
                    return (battleList?.battle?.count)!
                }
                else if section == 3 {
                    if battleList?.turn?.count > 3 {
                        return 3
                    }
                    return (battleList?.turn?.count)!
                }
                else{
                    if battleList?.ends?.count > 3 {
                        return 3
                    }
                    return (battleList?.ends?.count)!
                }
            }
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 + 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 {
            if battleList?.battle?.count != 0{
                return 40
            }
            return 0
        }else  if section == 3 {
            if battleList?.turn?.count != 0{
                return 40
            }
            return 0
        }else  if section == 4 {
            if battleList?.ends?.count != 0{
                return 40
            }
            return 0
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 61
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 || section == 3 || section == 4 {
            let view:UIView = UIView()
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40)
            
            let label:UILabel = UILabel(frame: CGRect(x: 14, y: 0, width: 100, height: 40))
            label.textColor = UIColor.whiteColor()
            label.font = UIFont.systemFontOfSize(14.0)
            view .addSubview(label)
            
            let screenW = UIScreen.mainScreen().bounds.width
            let btn = UIButton(type: .System)
            btn.frame = CGRect(x: screenW-70, y: 0, width: 60, height: 40)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            btn.setTitle(NSLocalizedString("moreStatus",tableName:"Localizable",comment: ""), forState: .Normal)
            btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
                let moreStatusVC = GameMoreStatusViewController()
                moreStatusVC.hidesBottomBarWhenPushed = true
                if section == 2 {
                    moreStatusVC.status = "myturn"
                    self.navigationController?.pushViewController(moreStatusVC, animated: true)
                }
                else if section == 3 {
                    moreStatusVC.status = "valid"
                    self.navigationController?.pushViewController(moreStatusVC, animated: true)
                }
                else{
                    moreStatusVC.status = "end"
                    self.navigationController?.pushViewController(moreStatusVC, animated: true)
                }
            })
            view .addSubview(btn)
            
            if section == 2 {
                if battleList?.battle?.count <= 3 {
                    btn.hidden = true
                }
                label.text = NSLocalizedString("yourTurn",tableName:"Localizable", comment: "")
                view.backgroundColor = UIColor(red:118/255.0, green: 198/255.0, blue: 32/255.0,alpha: 1.0)
                return view
            }else  if section == 3 {
                if battleList?.turn?.count <= 3 {
                    btn.hidden = true
                }
                label.text = NSLocalizedString("wait",tableName:"Localizable", comment: "")
                view.backgroundColor = UIColor(red:63/255.0, green: 157/255.0, blue: 236/255.0,alpha: 1.0)
                return view
            }else  if section == 4 {
                if battleList?.ends?.count <= 3 {
                    btn.hidden = true
                }
                label.text = NSLocalizedString("end",tableName:"Localizable", comment: "")
                view.backgroundColor = UIColor(red:255/255.0, green: 0/255.0, blue: 0/255.0,alpha: 1.0)
                return view
            }
        }
        return nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 61)
            
            let newGameButton = UIButton()
            newGameButton.setTitle(NSLocalizedString("newGame",tableName:"Localizable",comment: ""), forState: .Normal)
            newGameButton.layer.masksToBounds = true
            newGameButton.layer.cornerRadius = 4.0
            newGameButton.backgroundColor = UIColor(red: 71/255.0, green: 95/255.0, blue: 161/255.0, alpha: 1.0)
            newGameButton.frame = CGRect(x: 16, y: 7, width: (view.frame.width - 32), height: (view.frame.height - 14))
            newGameButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
                let gameNewVC = GameNewGameViewController()
                gameNewVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(gameNewVC, animated: true)
            })
            
            view.addSubview(newGameButton)
            return view
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else if indexPath.section == 1 {
            return 180
        }
        else{
            if indexPath.row == 3{
                return 40
            }
            return 100
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ScrollBannersTableViewCell", forIndexPath: indexPath) as! ScrollBannersTableViewCell
            var urls:[NSURL]? = [NSURL]()
            urls?.append(NSURL(string: "http://img.hb.aicdn.com/9a1153e7396c48cefa48e218b1f748805e9a3097bea0-nE1eIE_fw658")!)
            urls?.append(NSURL(string: "http://img.hb.aicdn.com/35114dc52b7c89398fdc6dabefe92b2c052fc27810c5f-HOApcr_fw658")!)
            urls?.append(NSURL(string: "http://img.hb.aicdn.com/aa8daab776a09fe01ccb06faa22a79930bfe3e70421d9-nLaQvA_fw658")!)
            cell.viewInit(self, imageURLs:urls!, placeholderImage: "temp001.jpg", timeInterval: 1, currentPageIndicatorTintColor: UIColor.whiteColor(), pageIndicatorTintColor: UIColor.grayColor())
            return cell
        }else if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier("RankTableViewCell", forIndexPath: indexPath)
            return cell
        }else {
//            if indexPath.row == 3{
//                let cell = tableView.dequeueReusableCellWithIdentifier("GameMoreStatusTableViewCell", forIndexPath: indexPath)
//                cell.selectionStyle = .None
//                cell.textLabel?.text = NSLocalizedString("moreStatus",tableName:"Localizable",comment: "")
//                cell.textLabel?.textAlignment = .Center
//                return cell
//            }
//            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("GameStatusTableViewCell", forIndexPath: indexPath) as! GameStatusTableViewCell
                cell.selectionStyle = .None
                var modelArray = [AnyObject]()
                if indexPath.section == 2{
                    modelArray = (self.battleList?.battle)!
                }
                else if indexPath.section == 3{
                    modelArray = (self.battleList?.turn)!
                }
                else{
                    modelArray = (self.battleList?.ends)!
                }
                let model = modelArray[indexPath.row] as! BattleDetailModel
                UserManager.sharedInstance.getUserByIdWithBlock(model.launchId!, completition: { (user) in
                    let avatar = user.headPortraitUrl != nil ? user.headPortraitUrl:""
                    cell.avatar?.kf_setImageWithURL(NSURL(string:avatar!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                })
                cell.levelBadge?.text = "\(Int(model.launchleve!))"
                cell.username?.text = model.launch
                cell.missionDescription?.text = model.battleTitle
                cell.timeDescription?.text = model.battleType
                cell.score?.text = model.scoreDetail
                
                cell.delegate = self
                cell.directionMask = HHPanningTableViewCellDirectionLeft
                cell.shadowViewEnabled = false
                
                if indexPath.section == 2 || indexPath.section == 3{
                    cell.drawerView = self.rightSlideView(3,section:indexPath.section,row:indexPath.row)
                    
                    
                }else {
                    cell.drawerView = self.rightSlideView(section:indexPath.section,row:indexPath.row)
                }
                return cell
//            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var modelArray = [AnyObject]()
        if indexPath.section == 2{
            modelArray = (self.battleList?.battle)!
        }
        else if indexPath.section == 3{
            modelArray = (self.battleList?.turn)!
        }
        else{
            modelArray = (self.battleList?.ends)!
        }
        let model = modelArray[indexPath.row] as! BattleDetailModel
        let battleId = model.battleId
        
        let moreStatusVC = GameMoreStatusViewController()
        moreStatusVC.hidesBottomBarWhenPushed = true
        
        if indexPath.section == 2 {
            let alertController = UIAlertController(title: "", message: NSLocalizedString("enter",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("go",tableName:"Localizable", comment: ""), style: .Default, handler:{(UIAlertAction) -> Void in
                if model.battleType == "challengeFri" || model.battleType == "challengeRan" {
                        self.presentToPlayRoomVC(battleId!)
                }
                else{
                    self.presentToBattleDetailsVC(battleId!)
                }
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("later",tableName:"Localizable", comment: ""), style: .Cancel, handler: {(UIAlertAction) -> Void in
                self.getBattleList()
                self.tableView?.reloadData()
            })
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if indexPath.section == 3 {
            if model.battleType == "challengeFri" || model.battleType == "challengeRan" {
                self.presentToWaitingDetailsVC(battleId!,type: "challenge")
            }
            else{
                self.presentToWaitingDetailsVC(battleId!,type: "classic")
            }
        }
        else if indexPath.section == 4 {
            let viewController = GameEndGameViewController()
            viewController.battleId = battleId
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
// MARK: Function
    //跳转战斗详情界面
    func presentToBattleDetailsVC(battleId:String){
        var dict = [String: AnyObject]()
        dict["battleId"] = battleId
        dict["accountId"] = UserModel.getCurrentUser()?.id
        self.runInMainQueue {
            SVProgressHUD.setBackgroundColor(UIColor.clearColor())
            SVProgressHUD.show()
        }
        
        SocketManager.sharedInstance.sendMsg("startBattle", data: dict, onProto: "startBattleed", callBack: { (code, objs) in
            self.runInMainQueue({
                SVProgressHUD.dismiss()
            })
            if code == statusCode.Normal.rawValue {
                if objs[0]["problemId"] as! String != "" {
                    let matchDetailModel = MatchDetailModel.getModelFromDictionary(objs[0] as! [String : AnyObject])
                    self.runInMainQueue({
                        let battleDetailsVC = GameClassicBattleDetailsViewController()
                        battleDetailsVC.matchDetailModel = matchDetailModel
                        battleDetailsVC.hidesBottomBarWhenPushed = true
                        let nav = GameMainNavigationViewController(rootViewController: battleDetailsVC)
                        let window = UIApplication.sharedApplication().keyWindow?.rootViewController
                        window!.presentViewController(nav, animated: true, completion: nil)
                    })
                }
            }
            else if code == statusCode.Complete.rawValue {
                self.presentCompleteAlert()
            }
            else if code ==  statusCode.Overtime.rawValue {
                self.presentOvertimeAlert()
            }
            else if code == statusCode.Error.rawValue {
                self.presentErrorAlert()
            }
        })
    }
    
    //跳转等待页面
    func presentToWaitingDetailsVC(battleId:String,type:String){
        var dic = [String:AnyObject]()
        dic["battleId"] = battleId
        self.runInMainQueue {
            SVProgressHUD.setBackgroundColor(UIColor.clearColor())
            SVProgressHUD.show()
        }
        
        SocketManager.sharedInstance.sendMsg("getBattleDetails", data: dic, onProto: "getBattleDetailsed") { (code, objs) in
            self.runInMainQueue({
                SVProgressHUD.dismiss()
            })
            if code == statusCode.Normal.rawValue {
                let battleEndModel = BattleEndModel.getModelFromObject(objs)
                self.runInMainQueue({
                    if type == "classic" {
                        let battleDetailsVC = GameClassicBattleDetailsViewController()
                        battleDetailsVC.isWaiting = true
                        battleDetailsVC.waitingDetails = battleEndModel
                        battleDetailsVC.hidesBottomBarWhenPushed = true
                        let nav = GameMainNavigationViewController(rootViewController: battleDetailsVC)
                        let window = UIApplication.sharedApplication().keyWindow?.rootViewController
                        window!.presentViewController(nav, animated: true, completion: nil)
                    }
                    else{
                        let viewController = GameEndGameViewController()
                        viewController.battleId = battleId
                        viewController.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(viewController, animated: true)
                        viewController.restartButton?.hidden = true
                    }
                })
            }
            else if code == statusCode.Complete.rawValue {
                self.presentCompleteAlert()
            }
            else if code ==  statusCode.Overtime.rawValue {
                self.presentOvertimeAlert()
            }
            else if code == statusCode.Error.rawValue {
                self.presentErrorAlert()
            }
        }
    }
    
    //跳转答题页面
    func presentToPlayRoomVC(battleId:String){
        var dict = [String: AnyObject]()
        dict["battleId"] = battleId
        dict["accountId"] = UserModel.getCurrentUser()?.id
        self.runInMainQueue({
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.Gradient)
        })
        SocketManager.sharedInstance.sendMsg("startBattle", data: dict, onProto: "startBattleed", callBack: { (code, objs) in
            self.runInMainQueue({
                SVProgressHUD.dismiss()
            })
            print(objs)
            if code == statusCode.Normal.rawValue {
                if objs[0]["problemId"] as! String != "" {
                    var dict = [String: AnyObject]()
                    dict["battleId"] = objs[0]["battleId"]
                    dict["questionId"] = objs[0]["problemId"]
                    
                    SocketManager.sharedInstance.sendMsg("queryProblemById", data: dict, onProto: "queryProblemByIded") { (code, objs) in
                        let battleModel = BattleModel.getModelFromDictionary(objs[0] as! NSDictionary)
                        self.runInMainQueue({
                            let playRoomVC = GameQuestionPlayRoomViewController()
                            playRoomVC.battleModel = battleModel
                            playRoomVC.hidesBottomBarWhenPushed = true
                            let nav = GameMainNavigationViewController(rootViewController: playRoomVC)
                            let window = UIApplication.sharedApplication().keyWindow?.rootViewController
                            window?.presentViewController(nav, animated: true, completion: nil)
                        })
                    }
                }
            }
            else if code == statusCode.Complete.rawValue {
                self.presentCompleteAlert()
            }
            else if code == statusCode.Overtime.rawValue {
                self.presentOvertimeAlert()
            }
            else if code == statusCode.Error.rawValue {
                self.presentErrorAlert()
            }
        })
    }
    
    func deleteGameStatusItem(tapGesture:UITapGestureRecognizer) {
        let slideItemView:SlideItemView = tapGesture.view as! SlideItemView
        print("delete section: \(slideItemView.section) row: \(slideItemView.row)")
        var modelArray = self.getModelArray(slideItemView)
        let model = modelArray[slideItemView.row] as! BattleDetailModel
        var dict = [String: AnyObject]()
        dict["battleId"] = model.battleId
        dict["accountId"] = UserModel.getCurrentUser()?.id
        SocketManager.sharedInstance.sendMsg("quitBattle", data: dict, onProto: "quitBattleed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                self.getBattleList()
            }
            else if code == statusCode.Complete.rawValue {
                self.getBattleList()
            }
        }
    }
    
    func chatGameStatusItem(tapGesture:UITapGestureRecognizer) {
        let slideItemView:SlideItemView = tapGesture.view as! SlideItemView
        let cell = tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: slideItemView.row,inSection: slideItemView.section)) as! GameStatusTableViewCell
        var modelArray = self.getModelArray(slideItemView)
        let model = modelArray[slideItemView.row] as! BattleDetailModel
        
        let friend = FriendsModel()
        friend.friendId = model.launchId
        friend.nickname = model.launch
        friend.headPortrait = cell.avatar?.image?.image2String()
        
        createConversation(friend)
    }
    
    func personalGameStatusItem(tapGesture:UITapGestureRecognizer) {
        let slideItemView:SlideItemView = tapGesture.view as! SlideItemView
        var modelArray = self.getModelArray(slideItemView)
        let model = modelArray[slideItemView.row] as! BattleDetailModel
        let personalVC = TourRecordsViewController()
        personalVC.userId = model.launchId
        personalVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(personalVC, animated: true)
        self.adBannerView?.hidden = true
    }
    
    func againGameStatusItem(tapGesture:UITapGestureRecognizer) {
        let slideItemView:SlideItemView = tapGesture.view as! SlideItemView
        print("again section: \(slideItemView.section) row: \(slideItemView.row)")
    }
    
    
    func rightSlideView(totalView:Int = 4,section:Int,row:Int) ->UIView {
        let view:UIView = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 100)
        view.backgroundColor = UIColor.clearColor()
        for i in 0..<totalView {
            let buttonWidth = UIScreen.mainScreen().bounds.width / CGFloat(totalView)
            let slideItemView:SlideItemView = SlideItemView(frame: CGRect(x: CGFloat(i) * buttonWidth, y: 0, width: buttonWidth, height: 100))
            slideItemView.row = row
            slideItemView.section = section
            let tapGesture = UITapGestureRecognizer()
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            
            slideItemView.addGestureRecognizer(tapGesture)
           
            view.addSubview(slideItemView)
            
            if i == 0 {
                slideItemView.viewDescription!.text = NSLocalizedString("Delete",tableName:"Localizable",comment: "")
                slideItemView.viewIcon!.image = UIImage(named:"new_game_scroll_giveup");
                tapGesture.addTarget(self, action: #selector(self.deleteGameStatusItem(_:)))
            } else if i == 1 {
                slideItemView.viewDescription!.text = NSLocalizedString("Chat",tableName:"Localizable",comment: "")
                slideItemView.viewIcon!.image = UIImage(named:"new_game_scroll_chat")
                tapGesture.addTarget(self, action: #selector(self.chatGameStatusItem(_:)))
            } else if i == 2 {
                slideItemView.viewDescription!.text = NSLocalizedString("Personal",tableName:"Localizable", comment: "")
                slideItemView.viewIcon!.image = UIImage(named:"new_game_scroll_personal")
                tapGesture.addTarget(self, action: #selector(self.personalGameStatusItem(_:)))
            } else if i == 3 {
                slideItemView.viewDescription!.text = NSLocalizedString("Again",tableName:"Localizable", comment: "")
                slideItemView.viewIcon!.image = UIImage(named:"new_game_scroll_again")
                tapGesture.addTarget(self, action: #selector(self.againGameStatusItem(_:)))
            }
        }
        return view
    }

    func bannerViewDidClicked(index:Int) {
        print("clicked: \(index)")
    }
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        let status = SocketManager.sharedInstance.socket?.status
        if status == SocketIOClientStatus.Connected {
            self.adInterstitial?.presentFromRootViewController(self)
        }
    }
    
    func createConversation(model:FriendsModel){
        let friendModel:FriendsModel = model
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
    
    func push2ConversationVC(conversion:AVIMConversation,hostUser:ChattingUserModel,guestUser:ChattingUserModel) {
        let conversationVC = ConversationViewController()
        conversationVC.conversation = conversion
        conversationVC.hostModel = hostUser
        conversationVC.guestModel = guestUser
        conversationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(conversationVC, animated: true)
    }
    
    func presentOvertimeAlert(){
        self.runInMainQueue { 
            let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: NSLocalizedString("overtime",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (action) in
                self.getBattleList()
            })
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func presentCompleteAlert(){
        self.runInMainQueue { 
            let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: NSLocalizedString("complete",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (action) in
                self.getBattleList()
            })
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    
    func presentErrorAlert(){
        self.runInMainQueue { 
            let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: NSLocalizedString("error",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (action) in
                self.getBattleList()
            })
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func SVProgressDismiss(){
        SVProgressHUD.dismiss()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
