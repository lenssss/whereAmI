//
//  Publish2FriendViewController.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/21.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import SVProgressHUD

class Publish2FriendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var chooseList:[String]? = nil
    var tableView:UITableView? = nil
    var currentFriends:[FriendsModel]? = nil
    var questionModel:QuestionModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择好友"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.setCustomBolderFontWithSize(15.0),NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        self.chooseList = [String]()
        self.setupUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func setupUI() {
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:  NSLocalizedString("next",tableName:"Localizable", comment: ""), style: .Done, target: self, action: #selector(self.publish2Friends))
        
        self.tableView = UITableView()
        self.view.addSubview(self.tableView!)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.registerClass(Publish2FriendTableViewCell.self, forCellReuseIdentifier: "Publish2FriendTableViewCell")
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func publish2Friends(){
        let dic = PhotoModel.getPhotoDictionaryFromQuestionModel(self.questionModel!)
//        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hub.color = UIColor.clearColor()
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        SVProgressHUD.show()
        SocketManager.sharedInstance.sendMsg("uploadImageFile", data: dic!, onProto: "uploadImageFileed", callBack: { (code, objs) -> Void in
            print(objs)
            let pictureId = objs[0]["file"] as! String
            self.questionModel!.pictureId = pictureId
            
            var friendList = [[String:String]]()
            for item in self.chooseList!{
                var dic = [String:String]()
                dic["id"] = item
                friendList.append(dic)
            }
            let dict = QuestionModel.getPublishDictionaryFromQuestionModel(self.questionModel!)
            SocketManager.sharedInstance.sendMsg("uploadQueAndAns", data: dict!, onProto: "uploadQueAndAnsed", callBack: { (code, objs) -> Void in
                print(objs)
                if code == statusCode.Normal.rawValue {
                    let pro = objs[0]["id"] as! String
                    
                    var dict = [String:AnyObject]()
                    dict["accountId"] = UserModel.getCurrentUser()?.id
                    dict["title"] = "invitation"
                    dict["friendId"] = friendList
                    dict["prolist"] = [pro]
                        
                    SocketManager.sharedInstance.sendMsg("invitationBattle", data: dict, onProto: "invitationBattleed", callBack: { (code, objs) -> Void in
                        self.runInMainQueue({
                            SVProgressHUD.dismiss()
                        })
                        print(objs)
                        if code == statusCode.Normal.rawValue {
                            let alertController = UIAlertController(title: "", message: NSLocalizedString("uploadSuccess",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
                            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (confirmAction) in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            })
                            alertController.addAction(confirmAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    })
                }
            })
        })
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.currentFriends = CoreDataManager.sharedInstance.fetchAllFriends()
        self.tableView?.reloadData()
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
        let cell:Publish2FriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("Publish2FriendTableViewCell", forIndexPath: indexPath) as! Publish2FriendTableViewCell
        cell.selectionStyle = .None
        let friendModel = currentFriends![indexPath.row]
        let avatarUrl = friendModel.headPortrait != nil ? friendModel.headPortrait : ""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = friendModel.nickname!
        cell.location?.text = "chengdu,China"
        if ((chooseList?.indexOf(friendModel.friendId!)) != nil) {
            cell.selectImageView?.hidden = false
        }
        else{
            cell.selectImageView?.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friendModel = currentFriends![indexPath.row]
        let index = chooseList?.indexOf(friendModel.friendId!)
        if index != nil {
            self.chooseList?.removeAtIndex(index!)
        }
        else{
            self.chooseList?.append(friendModel.friendId!)
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
