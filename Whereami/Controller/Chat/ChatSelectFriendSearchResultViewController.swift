//
//  ChatSelectFriendSearchResultViewController.swift
//  Whereami
//
//  Created by A on 16/5/11.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ChatSelectFriendSearchResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
    
    var tableView:UITableView? = nil
    var searchText:String? = nil
    var currentFriends:[FriendsModel]? = nil
    
    var newConversationHasDone:NewConversation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.tableView = UITableView()
        self.view.addSubview(self.tableView!)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(ContactItemTableViewCell.self, forCellReuseIdentifier: "ContactItemTableViewCell")
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil).subscribeNext { (notification) -> Void in
            self.keyboardWillShow(notification)
        }
        
        // Do any additional setup after loading the view.
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
        let cell:ContactItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("ContactItemTableViewCell", forIndexPath: indexPath) as! ContactItemTableViewCell
        
        let friendModel = currentFriends![indexPath.row]
        cell.addButton?.hidden = true
        let avatarUrl = friendModel.headPortrait != nil ? friendModel.headPortrait : ""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        if friendModel.nickname != nil {
            cell.chatName?.text = friendModel.nickname
        }
        
        let userModel = CoreDataManager.sharedInstance.fetchUserById(friendModel.friendId!)
        cell.location?.text = userModel?.countryName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
                
                if ((self.newConversationHasDone) != nil) {
                    self.newConversationHasDone!(conversion:conversion!,hostUser:hostUser,guestUser:guestUser)
                }
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func keyboardWillShow(notification:AnyObject){
        let rect = (notification as! NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let y = rect.size.height
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: y, right: 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.enablesReturnKeyAutomatically = true
        let searchText = searchController.searchBar.text
        if searchText != "" {
            var dict = [String:AnyObject]()
            dict["accountId"] = UserModel.getCurrentUser()?.id
            dict["nickname"] = searchText
            SocketManager.sharedInstance.sendMsg("getUserDatasByUserNickname", data: dict, onProto: "getUserDatasByUserNicknameed") { (code, objs) in
                if code == statusCode.Normal.rawValue {
                    print("++++++++++++++\(objs)")
                    let array = objs[0]["ret"]!["friends"] as! [AnyObject]
                    let accountList = FriendsModel.getModelFromArray(array)
                    self.currentFriends = accountList
                    self.runInMainQueue({
                        self.tableView?.reloadData()
                    })
                }
            }
        }
    }
}
