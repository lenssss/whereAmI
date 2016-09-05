//
//  ContactMainViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/16.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
import ReactiveCocoa
import SWTableViewCell
import SocketIOClientSwift
//import SDWebImage

public var KNotificationDismissSearchView: String { get{ return "KNotificationDismissSearchView"} }

class ContactMainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate,SWTableViewCellDelegate {
    
    var tableView:UITableView? = nil
    //    private var currentConversations:[ConversationModel]? = nil
    var searchResultVC:AnyObject? = nil
    var searchController:UISearchController? = nil
    var currentFriends:[FriendsModel]? = nil
    
    var newConversationHasDone:NewConversation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("Contact",tableName:"Localizable", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.customFontWithStyle("Bold", size:18.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.setupUI()
        self.registerNotification()
    }
    
    func setupUI() {
        self.tableView = UITableView()
        self.view.addSubview(self.tableView!)
        self.tableView?.separatorStyle = .None
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.registerClass(ContactMainViewCell.self, forCellReuseIdentifier: "ContactMainViewCell")
        
        searchResultVC = ContactMainViewSearchResultViewController()
        searchController = UISearchController(searchResultsController: searchResultVC as! ContactMainViewSearchResultViewController)
        searchController?.searchResultsUpdater = searchResultVC as! ContactMainViewSearchResultViewController
        searchController?.delegate = self
        searchController?.searchBar.sizeToFit()
        searchController?.active = true
        searchController?.searchBar.delegate = self
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.tableView?.tableHeaderView = searchController?.searchBar
    }
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).subscribeNext { (notification) -> Void in
            self.searchController?.active = false
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(KNotificationDismissSearchView, object: nil).subscribeNext { (notification) -> Void in
            let id = notification.object! as! String
            self.runInMainQueue({
                let personalVC = TourRecordsViewController()
                personalVC.userId = id
                personalVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(personalVC, animated: true)
            })
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName("addFriended", object: nil).subscribeNext { (notification) -> Void in
//            let friend = notification.object! as! FriendsModel
            self.currentFriends = CoreDataManager.sharedInstance.fetchAllFriends()
            self.tableView?.reloadData()
        }
    }
    
//    func addFriend(){
//        let friendVC = ContactIncreaseFriendViewController()
//        friendVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(friendVC, animated: true)
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.currentFriends = CoreDataManager.sharedInstance.fetchAllFriends()
        self.tableView?.reloadData()
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool){
        if viewController.isKindOfClass(ContactMainViewController.self) {
            self.navigationController?.navigationBar.backgroundColor = UIColor.getNavigationBarColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        }else {
            self.navigationController?.navigationBar.backgroundColor = UIColor.getGameColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.getGameColor()
        }
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool){
        if viewController.isKindOfClass(ContactMainViewController.self) {
            self.navigationController?.navigationBar.backgroundColor = UIColor.getNavigationBarColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        }else {
            self.navigationController?.navigationBar.backgroundColor = UIColor.getGameColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.getGameColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentFriends != nil {
            return currentFriends!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ContactMainViewCell = tableView.dequeueReusableCellWithIdentifier("ContactMainViewCell", forIndexPath: indexPath) as! ContactMainViewCell
        cell.selectionStyle = .None
        let friendModel = currentFriends![indexPath.row]

        let avatarUrl = friendModel.headPortrait != nil ? friendModel.headPortrait : ""
//        cell.avatar?.setImageWithString(avatarUrl!, placeholderImage: UIImage(named: "avator.png")!)
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = friendModel.nickname!
        cell.chatAction = {(button) -> Void in
            let status = SocketManager.sharedInstance.socket?.status
            if status == SocketIOClientStatus.Connected {
                self.createConversation(indexPath)
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
        cell.playAction = {(button) -> Void in
            let newGameVC = ContactPresentNewGameViewController()
            newGameVC.friend = friendModel
            newGameVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(newGameVC, animated: true)
        }
        
        let deleteBtn = UIButton()
        deleteBtn.backgroundColor = UIColor.redColor()
        deleteBtn.setTitle("删除", forState: .Normal)
        cell.rightUtilityButtons = [deleteBtn]
        cell.delegate = self
        
        let userModel = CoreDataManager.sharedInstance.fetchUserById(friendModel.friendId!)
        cell.location?.text = userModel?.countryName
        
        return cell
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        let indexPath = self.tableView?.indexPathForCell(cell)
        var dict = [String: AnyObject]()
        dict["accountId"] = self.currentFriends![indexPath!.row].accountId
        dict["friendId"] = self.currentFriends![indexPath!.row].friendId
        
        SocketManager.sharedInstance.sendMsg("delFreind", data: dict, onProto: "delFreinded", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue {
                CoreDataManager.sharedInstance.deleteFriends(self.currentFriends![indexPath!.row].accountId!,friendId: self.currentFriends![indexPath!.row].friendId!)
                self.currentFriends = CoreDataManager.sharedInstance.fetchAllFriends()
                self.runInMainQueue({
                    self.tableView!.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Middle)
                })
            }
        })
    }
    
        /*
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "删除") {
            (_, _) -> Void in
            var dict = [String: AnyObject]()
            dict["accountId"] = self.currentFriends![indexPath.row].accountId
            dict["friendId"] = self.currentFriends![indexPath.row].friendId
            
            SocketManager.sharedInstance.sendMsg("delFreind", data: dict, onProto: "delFreinded", callBack: { (code, objs) in
                if code == statusCode.Normal.rawValue {
                    CoreDataManager.sharedInstance.deleteFriends(self.currentFriends![indexPath.row].accountId!,friendId: self.currentFriends![indexPath.row].friendId!)
                    self.currentFriends = CoreDataManager.sharedInstance.fetchAllFriends()
                    self.runInMainQueue({
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
                    })
                }
            })
        }
        delAction.backgroundColor = UIColor.grayColor()
        return [delAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //是删除，就删除
        if editingStyle == .Delete {
            var dict = [String: AnyObject]()
            dict["accountId"] = currentFriends![indexPath.row].accountId
            dict["friendId"] = currentFriends![indexPath.row].friendId
            
            SocketManager.sharedInstance.sendMsg("delFreind", data: dict, onProto: "delFreinded", callBack: { (code, objs) in
                if code == statusCode.Normal.rawValue {
                    CoreDataManager.sharedInstance.deleteFriends(self.currentFriends![indexPath.row].accountId!,friendId: self.currentFriends![indexPath.row].friendId!)
                    self.currentFriends = CoreDataManager.sharedInstance.fetchAllFriends()
                    self.runInMainQueue({
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
                    })
                }
            })
        }
    }
  */
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("=====================\(searchBar.text)")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friendModel:FriendsModel = currentFriends![indexPath.row]
        let personalVC = TourRecordsViewController()
        personalVC.userId = friendModel.friendId
        personalVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(personalVC, animated: true)
    }
    
    func createConversation(indexPath:NSIndexPath){
        let friendModel:FriendsModel = currentFriends![indexPath.row]
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController?.active = false
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
