//
//  PersonalTravelDigListViewController.swift
//  Whereami
//
//  Created by A on 16/5/17.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
//import MBProgressHUD
import SVProgressHUD

class PersonalTravelDigListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    typealias theCallback = ([AnyObject]) -> Void
    
    var digList:[String]? = nil
    var tableView:UITableView? = nil
    var models:[UserModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.title = "点赞列表"
        self.models = [UserModel]()
        self.setUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hub.color = UIColor.clearColor()
        self.getModels(self.digList!) { (userData) in
            for item in userData {
                let user = UserModel.getModelFromDictionaryById(item as! NSDictionary)
                self.models?.append(user)
            }
            self.runInMainQueue({
                self.tableView?.reloadData()
//                MBProgressHUD.hideHUDForView(self.view, animated: true)
            })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
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
        let user = self.models![indexPath.row]
        let avatarUrl = user.headPortraitUrl != nil ? user.headPortraitUrl : ""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
//        cell.avatar?.setImageWithString(avatarUrl!, placeholderImage: UIImage(named: "avator.png")!)
        cell.chatName?.text = user.nickname
        cell.location?.text = "chengdu,China"
        cell.callBack = {(button) -> Void in
            self.addFriend(indexPath, cell: cell)
        }
        cell.addButton?.setTitle(NSLocalizedString("add",tableName:"Localizable", comment: ""), forState: .Normal)
        if self.models != nil {
            let friendModel = models![indexPath.row]
            let friend = CoreDataManager.sharedInstance.fetchFriendByFriendId(UserModel.getCurrentUser()!.id!, friendId: friendModel.id!)
            if friend != nil {
                cell.addButton?.setTitle(NSLocalizedString("added",tableName:"Localizable", comment: ""), forState: .Normal)
            }
        }
        return cell
    }
    
    func addFriend(indexPath:NSIndexPath,cell:ContactItemTableViewCell){
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["friendId"] = models![indexPath.row].id
        
        SocketManager.sharedInstance.sendMsg("addFreind", data: dict, onProto: "addFreinded", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let id = self.models![indexPath.row].id!
                self.getModels([id]) { (userData) in
                    let userDic = userData[0]
                    let user = UserModel.getModelFromDictionaryById(userDic as! NSDictionary)
                    CoreDataManager.sharedInstance.increaseOrUpdateUser(user)
                    let friendModel = FriendsModel.getModelFromUser(user)
                    CoreDataManager.sharedInstance.increaseFriends(friendModel)
                    self.runInMainQueue({
                        cell.addButton?.setTitle(NSLocalizedString("added",tableName:"Localizable", comment: ""), forState: .Normal)
                        cell.addButton?.enabled = false
                    })
                }
            }
        })
    }
    
    func getModels(list:[String],completion:theCallback){
        var dic = [String:AnyObject]()
        dic["searchIds"] = list
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        SVProgressHUD.show()
        SocketManager.sharedInstance.sendMsg("getUserDatasByUserIds", data: dic, onProto: "getUserDatasByUserIdsed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let userData = objs[0]["userData"] as! [AnyObject]
                completion(userData)
            }
            self.runInMainQueue({ 
                SVProgressHUD.dismiss()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
