//
//  GameClassicSearchResultViewController.swift
//  Whereami
//
//  Created by A on 16/3/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
typealias SearchCallback = () -> Void

class GameClassicSearchResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
    
    var tableView:UITableView? = nil
    var searchText:String? = nil
    var currentFriends:[FriendsModel]? = nil
    var callBack:SearchCallback? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfig()
        
        self.tableView = UITableView()
        self.view.addSubview(self.tableView!)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(GameClassicSelectFriendTableViewCell.self, forCellReuseIdentifier: "GameClassicSelectFriendTableViewCell")
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        // Do any additional setup after loading the view.
        LNotificationCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil).subscribeNext { (notification) -> Void in
            self.keyboardWillShow(notification)
        }
    }
    
    func keyboardWillShow(notification:AnyObject){
        let rect = (notification as! NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let y = rect.size.height
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: y, right: 0))
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
        
        let cell:GameClassicSelectFriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("GameClassicSelectFriendTableViewCell", forIndexPath: indexPath) as! GameClassicSelectFriendTableViewCell
        let friend = currentFriends![indexPath.row]
        let avatar = friend.headPortrait != nil ? friend.headPortrait : ""
//        cell.avatar?.setImageWithString(avatar!, placeholderImage: UIImage(named: "avator.png")!)
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatar!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = currentFriends![indexPath.row].nickname
        cell.location?.text = "chengdu,China"
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        GameParameterManager.sharedInstance.matchUser = [self.currentFriends![indexPath.row]]
        
        self.dismissViewControllerAnimated(false, completion: nil)
        self.callBack!()
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
