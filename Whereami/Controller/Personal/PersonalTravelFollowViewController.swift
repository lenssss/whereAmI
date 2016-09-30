//
//  PersonalTravelFollowViewController.swift
//  Whereami
//
//  Created by A on 16/5/17.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalTravelFollowViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    typealias theCallback = ([AnyObject]) -> Void
    
    var type:String? = nil
    var tableView:UITableView? = nil
    var models:[FriendsModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setConfig()
        self.setUI()
    }
    
    /*
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.getMainColor()
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = UIColor.getMainColor()
    }
 */
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.tableView = UITableView()
        self.tableView?.separatorStyle = .None
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        self.tableView?.registerClass(ContactItemTableViewCell.self, forCellReuseIdentifier: "ContactItemTableViewCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.models != nil {
            return (self.models?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactItemTableViewCell", forIndexPath: indexPath) as! ContactItemTableViewCell
        cell.selectionStyle = .None
        let user = self.models![indexPath.row]
        let avatarUrl = user.headPortrait != nil ? user.headPortrait : ""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = user.nickname
        cell.location?.text = "chengdu,China"
        cell.callBack = {(button) -> Void in
            self.addFriend(indexPath, cell: cell)
        }
        
        cell.addButton?.hidden = false
        if user.friendId == UserModel.getCurrentUser()!.id {
            cell.addButton?.hidden = true
        }
        cell.addButton?.setTitle(NSLocalizedString("add",tableName:"Localizable", comment: ""), forState: .Normal)
        if self.models != nil {
            let friendModel = models![indexPath.row]
            let friend = CoreDataManager.sharedInstance.fetchFriendByFriendId(friendModel.accountId!, friendId: friendModel.friendId!)
            if friend != nil {
                cell.addButton?.setTitle(NSLocalizedString("added",tableName:"Localizable", comment: ""), forState: .Normal)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friendModel:FriendsModel = models![indexPath.row]
        let personalVC = TourRecordsViewController()
        personalVC.userId = friendModel.friendId
        personalVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(personalVC, animated: true)
    }
    
    func addFriend(indexPath:NSIndexPath,cell:ContactItemTableViewCell){
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["friendId"] = models![indexPath.row].friendId
        
        SocketManager.sharedInstance.sendMsg("addFreind", data: dict, onProto: "addFreinded", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let friend = self.models![indexPath.row]
                var dic = [String:AnyObject]()
                dic["searchIds"] = [friend.friendId!]
                SocketManager.sharedInstance.sendMsg("getUserDatasByUserIds", data: dic, onProto: "getUserDatasByUserIdsed") { (code, objs) in
                    if code == statusCode.Normal.rawValue {
                        let userData = objs[0]["userData"] as! [AnyObject]
                        let user = UserModel.getModelFromDictionary(userData[0] as! NSDictionary)
                        CoreDataManager.sharedInstance.increaseOrUpdateUser(user)
                    }
                }
                CoreDataManager.sharedInstance.increaseFriends(friend)
                self.runInMainQueue({
                    cell.addButton?.setTitle(NSLocalizedString("added",tableName:"Localizable", comment: ""), forState: .Normal)
                    cell.addButton?.enabled = false
                })
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
