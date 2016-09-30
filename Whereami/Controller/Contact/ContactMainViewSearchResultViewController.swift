//
//  ChatMainViewSearchResultViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ContactMainViewSearchResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
    
    var tableView:UITableView? = nil
    var searchText:String? = nil
    var currentFriends:[FriendsModel]? = nil
    var searchBar:UISearchBar? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        
        self.tableView = UITableView()
        self.view.addSubview(self.tableView!)
        self.tableView?.separatorStyle = .None
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(ContactItemTableViewCell.self, forCellReuseIdentifier: "ContactItemTableViewCell")
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        LNotificationCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil).subscribeNext { (notification) -> Void in
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

        let avatarUrl = friendModel.headPortrait != nil ? friendModel.headPortrait : ""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = friendModel.nickname!
        cell.location?.text = "China"
        cell.addButton?.setTitle(NSLocalizedString("add",tableName:"Localizable", comment: ""), forState: .Normal)
        if self.currentFriends != nil {
            let friend = CoreDataManager.sharedInstance.fetchFriendByFriendId(friendModel.accountId!, friendId: friendModel.friendId!)
            if friend != nil {
                cell.addButton?.setTitle(NSLocalizedString("added",tableName:"Localizable", comment: ""), forState: .Normal)
            }
        }
        cell.callBack = {(button) -> Void in
            self.addFriend(indexPath, cell: cell)
        }
        
        let userModel = CoreDataManager.sharedInstance.fetchUserById(friendModel.friendId!)
        cell.location?.text = userModel?.countryName
        
        return cell
    }
    
    func addFriend(indexPath:NSIndexPath,cell:ContactItemTableViewCell){
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["friendId"] = currentFriends![indexPath.row].friendId
        
        SocketManager.sharedInstance.sendMsg("addFreind", data: dict, onProto: "addFreinded", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue{
                let friend = self.currentFriends![indexPath.row]
                var dic = [String:AnyObject]()
                dic["searchIds"] = [friend.friendId!]
                SocketManager.sharedInstance.sendMsg("getUserDatasByUserIds", data: dic, onProto: "getUserDatasByUserIdsed") { (code, objs) in
                    if code == statusCode.Normal.rawValue {
                        let userData = objs[0]["userData"] as! [AnyObject]
                        let userDic = userData[0]
                        let user = UserModel.getModelFromDictionary(userDic as! NSDictionary)
                        CoreDataManager.sharedInstance.increaseOrUpdateUser(user)
                    }
                }
                CoreDataManager.sharedInstance.increaseFriends(friend)
                self.runInMainQueue({
                    cell.addButton?.setTitle(NSLocalizedString("added",tableName:"Localizable", comment: ""), forState: .Normal)
                    cell.addButton?.enabled = false
                })
                LNotificationCenter().postNotificationName("addFriended", object: friend)
            }
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friendModel:FriendsModel = currentFriends![indexPath.row]
        self.dismissViewControllerAnimated(false) { 
            LNotificationCenter().postNotificationName(KNotificationDismissSearchView, object: friendModel.friendId)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        self.searchBar = searchController.searchBar
//        searchController.searchBar.enablesReturnKeyAutomatically = true
//        let searchText = searchController.searchBar.text
//        if searchText != "" {
//           self.currentFriends = CoreDataManager.sharedInstance.fetchFriendByNickName((UserModel.getCurrentUser()?.id)!, nickname: searchText!)
//            self.runInMainQueue({
//                self.tableView?.reloadData()
//            })
//        }
        searchController.searchBar.enablesReturnKeyAutomatically = true
        let searchText = searchController.searchBar.text
        if searchText != "" {
            var dict = [String:AnyObject]()
            dict["accountId"] = UserModel.getCurrentUser()?.id
            dict["nickname"] = searchText
            SocketManager.sharedInstance.sendMsg("getUserDatasByUserNicknameOther", data: dict, onProto: "getUserDatasByUserNicknameOthered") { (code, objs) in
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
