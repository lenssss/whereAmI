//
//  TourRecordsViewController.swift
//  Whereami
//
//  Created by A on 16/4/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
import MaterialControls
import MWPhotoBrowser
//import TZImagePickerController
import MJRefresh
import SVProgressHUD
import SocketIOClientSwift
import DKImagePickerController

class TourRecordsViewController: UIViewController,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,MDTabBarDelegate,MWPhotoBrowserDelegate {
    
    typealias theCallback = () -> Void

    var heightContant:NSLayoutConstraint? = nil
    var headView:PersonalHeaderView? = nil
    var tableView:UITableView? = nil
    var tabbar:MDTabBar? = nil
    var browser:MWPhotoBrowser? = nil
    var selectedPhotoArray:[MWPhoto]? = nil
    var collectPhoto:[AnyObject]? = nil
    var pickerPhotoArray:[AnyObject]? = nil
    var userId:String? = nil
    var user:UserModel? = nil
    var feeds:[TravelModel]? = nil
    var lastTime:Int? = nil
    var following:[FriendsModel]? = nil
    var follower:[FriendsModel]? = nil
    
    var isRemove:Bool? = false
    
    var asset:DKAsset? = nil
    var assets:[DKAsset]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setConfig()
        
        self.navigationController?.delegate = self
        
        feeds = [TravelModel]()
        
        self.setUI()
        self.registerNotification()
        lastTime = Int(NSDate().timeIntervalSince1970*1000)
        self.isRemove = true
        self.getFeeds()
        self.getCollectionsWithBlock {
            self.tableView?.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar(self.tableView!)
        self.getDataSource()
        self.tableView?.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.backgroundColor = UIColor.getNavigationBarColor()
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
        self.navigationController?.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        self.tableView?.delegate = nil
        
        SVProgressHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
//        let ScreenH = UIScreen.mainScreen().bounds.height
        let frame = CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 300)
        if userId == UserModel.getCurrentUser()?.id {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: #selector(self.pushToPublishVC))
            
            headView = PersonalHeaderView(frame: frame, theTitle: "...", theSubTitle: "...")
            headView!.editBlock = {
                let viewController = PersonalEditViewController()
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }else{
            let friend = CoreDataManager.sharedInstance.fetchFriendByFriendId((UserModel.getCurrentUser()?.id)!, friendId: userId!)
            var followBarButton:UIBarButtonItem? = nil
            if friend != nil{
                followBarButton = UIBarButtonItem(image: UIImage(named: "followed"), style: .Done, target: self, action: #selector(self.delFollow))
            }
            else{
                followBarButton = UIBarButtonItem(image: UIImage(named: "follow"), style: .Done, target: self, action: #selector(self.follow))
            }
            followBarButton?.enabled = false
            self.navigationItem.rightBarButtonItem = followBarButton
            
//            let shareBarButton = UIBarButtonItem(image: UIImage(named: "share"), style: .Done, target: self, action: #selector(self.share))
//            self.navigationItem.rightBarButtonItems = [shareBarButton,followBarButton!]
            
            headView = PersonalOtherHeaderView(frame: frame, theTitle: "...", theSubTitle: "...")
            
            headView?.layer.masksToBounds = true
            
            (headView as! PersonalOtherHeaderView).playBlock = {() -> Void in
                self.present2newGame()
            }
            
            (headView as! PersonalOtherHeaderView).chatBlock = {() -> Void in
                let status = SocketManager.sharedInstance.socket?.status
                if status == SocketIOClientStatus.Connected {
                    self.createConversation(FriendsModel.getModelFromUser(self.user!))
                }
                else{
                    let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: "网络异常", preferredStyle: .Alert)
                    let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (confirmAction) in
                        SocketManager.sharedInstance.connection({ (ifConnection) in
                            
                        })
                    })
                    alertController.addAction(confirmAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
        
        headView?.backimgActionBlocck = {() -> Void in
            self.present2ActionSheet()
        }
        
        headView?.getFriendsBlock = {() -> Void in
            let followVC = PersonalTravelFollowViewController()
            followVC.type = "following"
            followVC.models = self.following
            self.navigationController?.pushViewController(followVC, animated: true)
        }
        
        headView?.getFansBlock = {() -> Void in
            let followVC = PersonalTravelFollowViewController()
            followVC.type = "follower"
            followVC.models = self.follower
            self.navigationController?.pushViewController(followVC, animated: true)
        }
        self.view.addSubview(self.headView!)
        
        headView?.autoPinEdgeToSuperviewEdge(.Top ,withInset: -64)
        headView?.autoPinEdgeToSuperviewEdge(.Left)
        headView?.autoPinEdgeToSuperviewEdge(.Right)
        heightContant = self.headView?.autoSetDimension(.Height, toSize: 364)
        
        tabbar = MDTabBar()
        tabbar?.frame = CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 44)
        tabbar?.delegate = self
        tabbar?.setItems([NSLocalizedString("COLLECT",tableName:"Localizable", comment: ""),NSLocalizedString("PERFORMANCE",tableName:"Localizable", comment: ""),NSLocalizedString("TRAVELS",tableName:"Localizable", comment: "")])
        tabbar?.textColor = UIColor.grayColor()
        tabbar?.textFont = UIFont.systemFontOfSize(10.0)
        tabbar?.backgroundColor = UIColor.whiteColor()
        tabbar?.indicatorColor = UIColor(red: 81/255.0, green: 136/255.0, blue: 199/255.0, alpha: 1.0)
        tabbar?.rippleColor = UIColor.whiteColor()
        tabbar?.selectedIndex = 1
        
//        let header = MJRefreshNormalHeader()
//        header.lastUpdatedTimeLabel.hidden = true
//        header.stateLabel.hidden = true
//        header.arrowView.hidden = true
//        header.arrowView.alpha = 0
//        header.setRefreshingTarget(self, refreshingAction: #selector(self.downLoadNewData))
        
        let footer = MJRefreshAutoNormalFooter()
        footer.stateLabel.hidden = true
        footer.refreshingTitleHidden = true
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.upLoadNewData))
        
        tableView = UITableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.mj_footer = footer
        tableView?.separatorStyle = .None
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.showsVerticalScrollIndicator = false
        tableView?.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.tableView!)
        
        tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        
        tableView?.contentInset = UIEdgeInsetsMake(245, 0, 0, 0)
        tableView?.contentOffset = CGPoint(x: 0,y: -245)
        
        tableView?.tableHeaderView = self.tabbar
        tableView?.tableFooterView = UIView()
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.registerClass(PersonalPerformanceLevelTableViewCell.self, forCellReuseIdentifier: "PersonalPerformanceLevelTableViewCell")
        tableView?.registerClass(PersonalPerformancePerformanceTableViewCell.self, forCellReuseIdentifier: "PersonalPerformancePerformanceTableViewCell")
        tableView?.registerClass(PersonalPerformanceChallengesTableViewCell.self, forCellReuseIdentifier: "PersonalPerformanceChallengesTableViewCell")
        tableView?.registerClass(PersonalPerformanceAchievementsTableViewCell.self, forCellReuseIdentifier: "PersonalPerformanceAchievementsTableViewCell")
        tableView?.registerClass(PersonalCollectionTableViewCell.self, forCellReuseIdentifier: "PersonalCollectionTableViewCell")
        tableView?.registerClass(PersonalTravelOnePhotoTableViewCell.self, forCellReuseIdentifier: "PersonalTravelOnePhotoTableViewCell")
        tableView?.registerClass(PersonalTravelMutablePhotoTableViewCell.self, forCellReuseIdentifier: "PersonalTravelMutablePhotoTableViewCell")
    }
    
    func setNavigationBar(scrollView:UIScrollView){
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < 0 {
            let offsetH = -300 - offsetY
            heightContant?.constant = 400 + offsetH
            
            self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.clearColor()), forBarMetrics: .Default)
            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
            self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        }
        else{
            self.navigationController?.navigationBar.backgroundColor = UIColor.getNavigationBarColor()
            self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
            self.navigationController?.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        }
    }
    
    func setPushViewControllerNavigationBar(viewController:UIViewController){
        if viewController.isKindOfClass(MWPhotoBrowser.self){
            self.navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
            self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
            self.navigationController?.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        }
        else{
            self.navigationController?.navigationBar.backgroundColor = UIColor.getNavigationBarColor()
            self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
            self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
            self.navigationController?.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        }
    }
    
// MARK: MWPhotoBrowserDelegate
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt{
        if selectedPhotoArray != nil {
            return UInt((selectedPhotoArray?.count)!)
        }
        return 0
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt((selectedPhotoArray?.count)!) {
            return selectedPhotoArray![Int(index)]
        }
        return nil
    }
    
// MARK: UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabbar?.selectedIndex == 0 {
            if collectPhoto != nil{
                return 1
            }
            return 0
        }
        else if self.tabbar!.selectedIndex == 1 {
            if user != nil{
                return 4
            }
            return 0
        }
        else if self.tabbar?.selectedIndex == 2{
            if feeds != nil{
                return (feeds?.count)!
            }
            return 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tabbar?.selectedIndex == 0 {
            return ceil(30/3)*(self.view.bounds.width/3)
        }
        else if tabbar!.selectedIndex == 1 {
            if indexPath.row==0 {
                return 160
            }else if indexPath.row==1 {
                return 160
            }else if indexPath.row==2 {
                return 160
            }
            else {
                return 220
            }
        }
        else if tabbar!.selectedIndex == 2 {
            let feed = feeds![indexPath.row]
            if feed.picList?.count == 1 {
                return PersonalTravelOnePhotoTableViewCell.heightForCell(feed.content!)
            }
            else{
                return PersonalTravelMutablePhotoTableViewCell.heightForCell(feed.content!,total: CGFloat(feed.picList!.count))
            }
        }
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tabbar?.selectedIndex == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalCollectionTableViewCell", forIndexPath: indexPath) as! PersonalCollectionTableViewCell
            cell.selectionStyle = .None
            cell.photoIdArray = self.collectPhoto as? [String]
            cell.collectionView?.reloadData()
            return cell
        }
        else if tabbar?.selectedIndex == 1 {
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalPerformanceLevelTableViewCell", forIndexPath: indexPath) as! PersonalPerformanceLevelTableViewCell
                cell.selectionStyle = .None
                let level = self.user?.level != nil ? "\(Int((self.user?.level)!))":"1"
                let points = self.user?.points != nil ? "\(Int((self.user?.points)!))":"0"
                let nextPoint = self.user?.nextPoint != nil ? "\(Int((self.user?.nextPoint)!))":"0"
                let right = self.user?.right != nil ? Int((self.user?.right)!):0
                let wrong = self.user?.wrong != nil ? Int((self.user?.wrong)!):0
                let total = right+wrong
                let multiplier = self.user?.levelUpPersent != nil ? CGFloat((self.user?.levelUpPersent)!):0
                
                cell.levelLabel?.text = NSLocalizedString("level",tableName:"Localizable", comment: "") + " " + level
                cell.pointLabel?.text = points
                cell.nextPointLabel?.text = nextPoint
                cell.totalLabel?.text = "You have answered \(total as Int) question correctly"
                cell.winedView!.autoMatchDimension(.Width, toDimension: .Width, ofView: cell.failedView!, withMultiplier: multiplier)
                return cell
            }
            else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalPerformancePerformanceTableViewCell", forIndexPath: indexPath) as! PersonalPerformancePerformanceTableViewCell
                cell.selectionStyle = .None
                
                let wins = self.user?.wins != nil ? "\(Int((self.user?.wins)!))":"0"
                let loss = self.user?.loss != nil ? "\(Int((self.user?.loss)!))":"0"
                let quits = self.user?.quits != nil ? "\(Int((self.user?.quits)!))":"0"
                
                cell.wonNum?.text = wins
                cell.lostNum?.text = loss
                cell.resignedNum?.text = quits
                return cell
            }
            else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalPerformanceChallengesTableViewCell", forIndexPath: indexPath) as! PersonalPerformanceChallengesTableViewCell
                cell.selectionStyle = .None
                let wins = self.user?.wins != nil ? Int((self.user?.wins)!):0
                let loss = self.user?.loss != nil ? Int((self.user?.loss)!):0
                let total = wins + loss
                cell.totalLabel!.text = NSLocalizedString("challengeTotal",tableName:"Localizable", comment: "")+"\(total as Int)"
                cell.winLabel?.text = "\(wins)"
                cell.loseLabel?.text = "\(loss)"
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalPerformanceAchievementsTableViewCell", forIndexPath: indexPath)
                cell.selectionStyle = .None
                return cell
            }
        }
        else{
            let contentLabelW = UIScreen.mainScreen().bounds.width - 20
            let feed = self.feeds![indexPath.row]
            let contentLabelH = (feed.content! as NSString).boundingRectWithSize(CGSize(width: contentLabelW,height: CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14.0)], context: nil).height + 10
            
            let currentUser = UserModel.getCurrentUser()!.id
            
            if feeds![indexPath.row].picList?.count == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalTravelOnePhotoTableViewCell", forIndexPath: indexPath) as! PersonalTravelOnePhotoTableViewCell
                cell.selectionStyle = .None
//                if userId == currentUser {
//                    cell.likeLogo?.enabled = false
//                }
                
                let creator = CoreDataManager.sharedInstance.fetchUserById(feed.creatorId!)
                let avatarUrl = creator!.headPortraitUrl != nil ? creator!.headPortraitUrl : ""
                cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                cell.photoId = feed.picList![0]
                cell.name?.text = creator?.nickname
                cell.contentLabel?.text = feed.content
                cell.comment?.text = "\((feed.comments?.count)! as Int)"
                cell.like?.setTitle("\((feed.digList?.count)! as Int)", forState: .Normal)
                cell.contentConstraint?.constant = contentLabelH
                cell.location?.text = feed.ginwaveDes
                cell.creatorId = feed.creatorId
                let time = TimeManager.sharedInstance.getDateStringFromString(feed.createdAt!)
                cell.time?.text = time
                
                if (feed.digList!.indexOf(currentUser!)  != nil){
                    cell.likeLogo?.setBackgroundImage(UIImage(named: "icon_liked"), forState: .Normal)
                }
                else{
                    cell.likeLogo?.setBackgroundImage(UIImage(named: "icon_like"), forState: .Normal)
                }
                
                cell.getPhoto()
                
                cell.digAction = {() -> Void in
                    self.likeOrNot(feed.digList!, tourId: feed.id!, feed: feed,cell: cell)
                }
                
                cell.commentAction = {() -> Void in
                    self.pushToCommentVC(feed)
                }
                
                cell.shareAction = {() -> Void in
                    self.presentActionSheet()
                }
                
                cell.digListAction = {() -> Void in
                    self.pushToDigVC(feed.digList!)
                }
            
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalTravelMutablePhotoTableViewCell", forIndexPath: indexPath) as! PersonalTravelMutablePhotoTableViewCell
                cell.selectionStyle = .None
//                if userId == currentUser {
//                    cell.likeLogo?.enabled = false
//                }
                
                let num = ceil(CGFloat(feed.picList!.count)/3.0)
                let PhotoH = (contentLabelW)/3
                let creator = CoreDataManager.sharedInstance.fetchUserById(feed.creatorId!)
                let avatarUrl = creator!.headPortraitUrl != nil ? creator!.headPortraitUrl : ""
                cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                cell.photoIdArray = feed.picList
                cell.name?.text = creator?.nickname
                cell.contentLabel?.text = feed.content
                cell.comment?.text = "\((feed.comments?.count)! as Int)"
                cell.like?.setTitle("\((feed.digList?.count)! as Int)", forState: .Normal)
                cell.contentConstraint?.constant = contentLabelH
                cell.photoConstraint?.constant = ceil(num*PhotoH)
                cell.location?.text = feed.ginwaveDes
                cell.creatorId = feed.creatorId
                let time = TimeManager.sharedInstance.getDateStringFromString(feed.createdAt!)
                cell.time?.text = time
                
                if (feed.digList!.indexOf(currentUser!)  != nil){
                    cell.likeLogo?.setBackgroundImage(UIImage(named: "icon_liked"), forState: .Normal)
                }
                else{
                    cell.likeLogo?.setBackgroundImage(UIImage(named: "icon_like"), forState: .Normal)
                }
                
                cell.getPhoto(feed.picList!)
                
                cell.digAction = {() -> Void in
                    self.likeOrNot(feed.digList!, tourId: feed.id!, feed: feed,cell: cell)
                }
                
                cell.commentAction = {() -> Void in
                    self.pushToCommentVC(feed)
                }
                
                cell.shareAction = {() -> Void in
                    self.presentActionSheet()
                }
                
                cell.digListAction = {() -> Void in
                    self.pushToDigVC(feed.digList!)
                }
                return cell
            }
        }
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if tabbar?.selectedIndex == 2 {
//            let feed = self.feeds![indexPath.row]
//            self.pushToCommentVC(feed)
//        }
//    }
    
// MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isKindOfClass(UITableView) {
            self.setNavigationBar(scrollView)
        }
    }
    
// MARK: MDTabBarDelegate
    func tabBar(tabBar: MDTabBar!, didChangeSelectedIndex selectedIndex: UInt) {
        self.runInMainQueue { 
            self.tableView?.reloadData()
        }
    }
    
//// MARK: UINavigationControllerDelelgate
//    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
//        if viewController.isKindOfClass(TourRecordsViewController.self) {
//            self.setNavigationBar(self.tableView!)
//        }
//        else{
//            self.navigationController?.navigationBar.backgroundColor = UIColor.getMainColor()
//            self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
//            self.navigationController?.navigationBar.barTintColor = UIColor.getMainColor()
//        }
//    }
    
    
//MARK: DataSource
    func getDataSource(){
        self.user =  UserManager.sharedInstance.getUserByIdWithBlock(userId!, completition: { (user) in
            self.user = user
            self.performSelector(#selector(self.updateHeaderView))
        })
        self.getFollowDetail()
    }
    
    //    func getPersonWithBlock(completiton:theCallback){
    //        var dict = [String:AnyObject]()
    //        dict["searchIds"] = [self.userId!]
    //        SocketManager.sharedInstance.sendMsg("getUserDatasByUserIds", data: dict, onProto: "getUserDatasByUserIdsed") { (code, objs) in
    //            if code == statusCode.Normal.rawValue {
    //                print("++++++++++++++\(objs)")
    //                let userData = objs[0]["userData"] as! [AnyObject]
    //                let userDic = userData[0]
    //                let user = UserModel.getModelFromDictionaryById(userDic as! NSDictionary)
    //                self.user = user
    //                completiton()
    //            }
    //        }
    //    }
    
//    func getCollectionsWithBlock(block:theCallback){
//        self.collectPhoto = [String]()
//        for i in 0...29 {
//            let index = i%10+1
////            let image = UIImage(named: "\(index)")
//            let path = NSBundle.mainBundle().pathForResource("\(index)", ofType: ".jpg")
//            let url = NSURL.fileURLWithPath(path!)
//            self.collectPhoto?.append(url)
//        }
//        block()
//    }
    
    
     func getCollectionsWithBlock(block:theCallback){
        var dict = [String:AnyObject]()
        dict["accountId"] = self.user?.id
        SocketManager.sharedInstance.sendMsg("fetchPointUsrCollectPhoto", data: dict, onProto: "fetchPointUsrCollectPhotoed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let collections = objs[0]["collections"] as! [AnyObject]
                for item in collections {
                    let picId = item["picId"] as! String
                    self.collectPhoto?.append(picId)
                }
                block()
            }
        }
    
     }
 
    func getFeeds(){
        var dic = [String:AnyObject]()
        dic["accountId"] = UserModel.getCurrentUser()?.id
        dic["userId"] = userId
        dic["limit"] = 10
        dic["lastAcceptDate"] = self.lastTime
        
        SocketManager.sharedInstance.sendMsg("getFeedByUserId", data: dic, onProto: "getFeedByUserIded") { (code, objs) in
            if code == statusCode.Normal.rawValue{
                if self.isRemove == true {
                    self.feeds?.removeAll()
                    self.isRemove = false
                }
                let models = TravelModel.getModelsFromObject(objs)
                if models?.count != 0{
                    self.feeds = self.feeds! + models!
                }
                if self.feeds?.count != 0 {
                    self.lastTime = Int(self.feeds!.last!.createdAt!)
                }
                self.runInMainQueue({
                    self.tableView?.reloadData()
                    self.tableView?.mj_footer.endRefreshing()
                })
            }
        }
    }
    
    func getFollowDetail(){
        var dict = [String:AnyObject]()
        dict["accountId"] = userId
        dict["nickname"] = ""
        SocketManager.sharedInstance.sendMsg("getFreinds", data: dict, onProto: "getFreindsed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let accountList = FriendsModel.getModelFromObject(objs)
                self.following = accountList
                self.runInMainQueue({
                    self.headView?.followingLabel?.text = "\((self.following?.count)! as Int)"
                })
            }
        }
        SocketManager.sharedInstance.sendMsg("getFans", data: dict, onProto: "getFansed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let accountList = FriendsModel.getModelFromObject(objs)
                self.follower = accountList
                self.runInMainQueue({
                    self.headView?.followerLabel?.text = "\((self.follower?.count)! as Int)"
                })
            }
        }
    }
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().rac_addObserverForName("touchOnOnePhotoViewCell", object: nil).subscribeNext { (notification) in
            self.selectedPhotoArray = [MWPhoto]()
            let imageString = notification.object as! String
            let imageUrl = imageString
            let photo = MWPhoto(URL: NSURL(string: imageUrl))
            self.selectedPhotoArray = [photo]
            let index = 0 as UInt
            self.pushToBrowser(index)
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName("touchOnCollectionViewCell", object: nil).subscribeNext { (notification) in
            self.selectedPhotoArray = [MWPhoto]()
            let index = notification.object as! UInt
            let imageArray = notification.userInfo["photoes"] as! [String]
            for item in imageArray{
                let imageUrl = item
                let photo = MWPhoto(URL: NSURL(string: imageUrl))
                self.selectedPhotoArray?.append(photo)
            }
            self.pushToBrowser(index)
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName("touchUser", object: nil).subscribeNext { (notification) in
            let userId = notification.object as? String
            let TourRecordsVC = TourRecordsViewController()
            TourRecordsVC.userId = userId
            self.navigationController?.pushViewController(TourRecordsVC, animated: true)
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName("publishTour", object: nil).subscribeNext { (notification) in
            self.tabbar?.selectedIndex = 2
            self.lastTime = Int(NSDate().timeIntervalSince1970*1000)
            self.isRemove = true
            self.getFeeds()
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName("CommentVCChange", object: nil).subscribeNext { (notification) in
            let feed = notification.object as? TravelModel
            for (index,value) in self.feeds!.enumerate() {
                if value.id == feed?.id {
                    self.feeds![index] = feed!
                    self.tableView?.reloadData()
                }
            }
         }
    }

//MARK: Other
    func likeOrNot(digList:[AnyObject],tourId:String,feed:TravelModel,cell:AnyObject){
        let userId = UserModel.getCurrentUser()?.id
        var dic = [String:AnyObject]()
        dic["tourId"] = tourId
        dic["accountId"] = userId
        for item in digList {
            if item.isEqualToString(userId!){
                SocketManager.sharedInstance.sendMsg("delDigFeed", data: dic, onProto: "delDigFeeded", callBack: { (code, objs) in
                    if code == statusCode.Normal.rawValue {
                        let digList = objs[0]["digList"] as! [String]
                        feed.digList = digList
                        self.runInMainQueue({
                            let indexPath = self.tableView?.indexPathForCell(cell as! UITableViewCell)
                            self.tableView!.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
                        })
                    }
                })
                return
            }
        }
        SocketManager.sharedInstance.sendMsg("digFeed", data: dic, onProto: "digFeeded", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let digList = objs[0]["digList"] as! [String]
                feed.digList = digList
                self.runInMainQueue({
                    let indexPath = self.tableView?.indexPathForCell(cell as! UITableViewCell)
                    self.tableView!.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
                })
            }
        })
    }
    
    func downLoadNewData(){
        self.isRemove = true
        if self.tabbar?.selectedIndex == 0{
//            self.collectPhoto?.removeAll()
//            self.getCollectPhoto()
        }
        else if self.tabbar?.selectedIndex == 1 {
//            UserManager.sharedInstance.getUserByIdWithBlock(userId!, completition: { (user) in
//                self.runInMainQueue({
//                    self.user = user
//                    self.headView!.titleLabel?.text = self.user?.nickname
//                    let avatarUrl = self.user?.headPortraitUrl != nil ? self.user!.headPortraitUrl : ""
//                    self.headView?.headerImageView?.setImageWithString(avatarUrl!, placeholderImage: UIImage(named: "avator.png")!)
//                    if self.userId != UserModel.getCurrentUser()?.id{
//                        let followBarBtn = self.navigationItem.rightBarButtonItems![1]
//                        followBarBtn.enabled = true
//                    }
//                })
//            })
        }
        else{
            let time = Int(NSDate().timeIntervalSince1970*1000)
            self.lastTime = time
            self.getFeeds()
        }
    }
    
    func upLoadNewData(){
        if self.tabbar?.selectedIndex == 0{
            self.tableView?.mj_footer.endRefreshing()
        }
        else if self.tabbar?.selectedIndex == 1 {
            self.tableView?.mj_footer.endRefreshing()
        }
        else{
            self.getFeeds()
        }
    }
    
    func pushToPublishVC(){
        self.pickerPhotoArray = [AnyObject]()
        let pickerController = DKImagePickerController()
        pickerController.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.getNavigationBarColor()), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        pickerController.maxSelectableCount = 9
        pickerController.assetType = .AllPhotos
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            if assets.count != 0 {
                self.assets = assets
            }
            else{
                self.assets = nil
            }
        }
        pickerController.didCancel = { () in
            if self.assets != nil {
                for asset in self.assets! {
                    asset.fetchFullScreenImageWithCompleteBlock({ (image, info) in
                        self.pickerPhotoArray?.append(image!)
                        if self.pickerPhotoArray?.count == self.assets?.count {
                            let viewController = PublishTourViewController()
                            viewController.photoArray = self.pickerPhotoArray
                            viewController.assets = self.assets
                            self.navigationController?.pushViewController(viewController, animated: true)
                        }
                    })
                }
            }
        }
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func pushToCommentVC(feed:TravelModel){
        let commentVC = PersonalTravalCommentViewController()
        commentVC.feed = feed
        commentVC.userId = userId
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func pushToDigVC(digList:[String]){
        let digVC = PersonalTravelDigListViewController()
        digVC.digList = digList
        self.navigationController?.pushViewController(digVC, animated: true)
    }
    
    func presentActionSheet(){
        let alertController = UIAlertController()
        let publishAction = UIAlertAction(title: NSLocalizedString("uploadToPool",tableName:"Localizable", comment: ""), style: .Default) { (action) -> Void in
            
        }
        let shareAction = UIAlertAction(title: NSLocalizedString("uploadToFriends",tableName:"Localizable", comment: ""), style: .Default) { (action) -> Void in
            
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel",tableName:"Localizable", comment: ""), style: .Cancel, handler: nil)
        alertController.addAction(publishAction)
        alertController.addAction(shareAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func pushToBrowser(index:UInt){
        let browser = MWPhotoBrowser()
        browser.delegate = self
        browser.displayActionButton = true // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = false // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = false // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = true // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = false // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = true // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = false // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        browser.autoPlayOnAppear = false // Auto-play first video
        browser.showNextPhotoAnimated(true)
        browser.showPreviousPhotoAnimated(true)
        browser.setCurrentPhotoIndex(index)
        self.navigationController?.pushViewController(browser, animated: true)
    }
    
    func createConversation(friend:FriendsModel){
        let friendModel:FriendsModel = friend
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
    
    func present2newGame(){
        let newGameVC = ContactPresentNewGameViewController()
        newGameVC.friend = FriendsModel.getModelFromUser(self.user!)
        self.navigationController?.pushViewController(newGameVC, animated: true)
    }
    
    func present2ActionSheet(){
        let alertController = UIAlertController()
        let changeAction = UIAlertAction(title: NSLocalizedString("changeCover",tableName:"Localizable", comment: ""), style: .Default) { (action) -> Void in
//            self.pickerPhotoArray = [AnyObject]()
//            let pickerVC = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
//            pickerVC.didFinishPickingPhotosHandle = {(photo,assets,isSelectOriginalPhoto) -> Void in
//                var pic:UIImage? = nil
//                if isSelectOriginalPhoto == true {
//                    TZImageManager().getPhotoWithAsset(assets[0], completion: { (image, dic, bool) in
//                       pic = image
//                    })
//                }
//                else{
//                    pic = photo[0]
//                }
//                self.updateBackImage(pic!)
//            }
//            self.presentViewController(pickerVC, animated: true, completion: nil)
            let pickerController = DKImagePickerController()
            pickerController.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.getNavigationBarColor()), forBarMetrics: UIBarMetrics.Default)
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
            pickerController.singleSelect = true
            pickerController.maxSelectableCount = 1
            pickerController.assetType = .AllPhotos
            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                print("didSelectAssets")
                if assets.count != 0 {
                    self.asset = assets[0]
                }
                else{
                    self.asset = nil
                }
            }
            pickerController.didCancel = { () in
                if self.asset != nil {
                    self.asset!.fetchFullScreenImageWithCompleteBlock({ (image, info) in
                        self.runInMainQueue({
                            self.asset = nil
                            self.updateBackImage(image!)
                        })
                    })
                }
            }
            self.presentViewController(pickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel",tableName:"Localizable", comment: ""), style: .Cancel, handler: nil)
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func follow(){
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["friendId"] = userId
        
        SocketManager.sharedInstance.sendMsg("addFreind", data: dict, onProto: "addFreinded", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue{
                let friend = FriendsModel.getModelFromUser(self.user!)
                CoreDataManager.sharedInstance.increaseOrUpdateUser(self.user!)
                CoreDataManager.sharedInstance.increaseFriends(friend)
                self.runInMainQueue({
                    let followBarBtn = UIBarButtonItem.init(image: UIImage(named: "followed"), style: .Done, target: self, action: #selector(self.delFollow))
                    self.navigationItem.rightBarButtonItem = followBarBtn
                })
            }
        })
    }
    
    func delFollow(){
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["friendId"] = userId
        
        SocketManager.sharedInstance.sendMsg("delFreind", data: dict, onProto: "delFreinded", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue {
                CoreDataManager.sharedInstance.deleteFriends((UserModel.getCurrentUser()?.id)!,friendId: self.userId!)
                self.runInMainQueue({
                    let followBarBtn = UIBarButtonItem.init(image: UIImage(named: "follow"), style: .Done, target: self, action: #selector(self.follow))
                    self.navigationItem.rightBarButtonItem = followBarBtn
                })
            }
        })
    }
    
    func updateHeaderView(){
        self.headView?.titleLabel?.text = self.user?.nickname
        self.headView?.subTitleLabel?.text = self.user?.countryName
        
        let avatar = self.user?.headPortraitUrl != nil ? self.user!.headPortraitUrl : ""
        let avatarUrl = avatar?.toUrl()
        self.headView?.headerImageView!.kf_setImageWithURL(avatarUrl!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        
        if self.user?.backPictureUrl != nil {
            let backPic = self.user?.backPictureUrl
            let backPicUrl = backPic?.toUrl()
            self.headView?.backImageView?.kf_setImageWithURL(backPicUrl!, placeholderImage: UIImage(named: "personal_back")                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          , optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        
        if self.userId != UserModel.getCurrentUser()?.id{
            let followBarBtn = self.navigationItem.rightBarButtonItem
            followBarBtn!.enabled = true
        }
    }
    
    func updateBackImage(image:UIImage){
        let currentUser = UserModel.getCurrentUser()
        
        var dic = [String:AnyObject]()
        dic["userId"] = currentUser?.id
        dic["type"] = "jpg"
        dic["content"] = UIImageJPEGRepresentation(image, 1.0)
        
        SVProgressHUD.show()
        SocketManager.sharedInstance.sendMsg("uploadImageFile", data: dic, onProto: "uploadImageFileed", callBack: { (code, objs) -> Void in
            if code == statusCode.Normal.rawValue {
                let pictureUrl = objs[0]["file"] as! String
                let dic = PhotoModel.getPhotoDictionaryFromFile(pictureUrl, creator: (currentUser?.id)!)
                SocketManager.sharedInstance.sendMsg("uploadPhoto", data: dic!, onProto: "uploadPhotoed", callBack: { (code, objs) -> Void in
                    if code == statusCode.Normal.rawValue {
                        let pictureId = objs[0]["id"] as! String
                        var dict = [String:AnyObject]()
                        dict["accountId"] = currentUser?.id
                        dict["backpictureId"] = pictureId
                        SocketManager.sharedInstance.sendMsg("accountUpdate", data: dict, onProto: "accountUpdateed") { (code, objs) in
                            if code == statusCode.Normal.rawValue {
                                self.runInMainQueue({
                                    currentUser?.backPictureUrl = pictureUrl
                                    CoreDataManager.sharedInstance.increaseOrUpdateUser(currentUser!)
                                    self.headView?.backImageView?.image = image
                                    self.runInMainQueue({ 
                                        SVProgressHUD.showSuccessWithStatus("success")
                                        self.performSelector(#selector(self.dismiss), withObject: nil, afterDelay: 2)
                                    })
                                })
                            }
                            else{
                                self.showError()
                            }
                        }
                    }
                    else{
                        self.showError()
                    }
                })
            }
            else {
                self.showError()
            }
        })
    }
    
    func showError(){
        self.runInMainQueue { 
            SVProgressHUD.showErrorWithStatus("error")
            self.performSelector(#selector(self.dismiss), withObject: nil, afterDelay: 2)
        }
    }
    
    func dismiss(){
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
