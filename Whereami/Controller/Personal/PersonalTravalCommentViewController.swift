//
//  PersonalTravalCommentViewController.swift
//  Whereami
//
//  Created by A on 16/4/27.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
import MJRefresh

class PersonalTravalCommentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    var tableView:UITableView? = nil
    var commentTextView:PersonalCommentInputView? = nil
    var feed:TravelModel? = nil
    var comments:[CommentModel]? = nil
    var replyUser:UserModel? = nil
    var textViewConstraint:NSLayoutConstraint? = nil
    var deleteCell:PersonalTravelCommentTableViewCell? = nil
    var userId:String? = nil
    
    var screenW = UIScreen.mainScreen().bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.title = "帖子详情"
        self.comments = self.getComments()
        self.setUI()
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil).subscribeNext { (notification) -> Void in
            self.keyboardWillShow(notification)
        }
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).subscribeNext { (notification) -> Void in
            self.keyboardWillHide(notification)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.loadNewData))
        
        self.tableView = UITableView()
        self.tableView?.separatorStyle = .None
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.mj_header = header
        self.view.addSubview(self.tableView!)
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 40, 0))
        self.tableView?.registerClass(PersonalTravelOnePhotoTableViewCell.self, forCellReuseIdentifier: "PersonalTravelOnePhotoTableViewCell")
        self.tableView?.registerClass(PersonalTravelMutablePhotoTableViewCell.self, forCellReuseIdentifier: "PersonalTravelMutablePhotoTableViewCell")
        self.tableView?.registerClass(PersonalTravelCommentTableViewCell.self, forCellReuseIdentifier: "PersonalTravelCommentTableViewCell")
        
        let screenW = UIScreen.mainScreen().bounds.width
        let screenH = UIScreen.mainScreen().bounds.height
        self.commentTextView = PersonalCommentInputView()
        self.commentTextView?.frame = CGRect(x: 0, y: screenH-104, width: screenW, height: 40)
        self.commentTextView?.publishAction = {() -> Void in
           // tourId:String,accountId:String,content:String,relatedId:String
            let content = self.commentTextView?.textView?.text
            if content?.length != 0 {
                var relatedId = ""
                if self.replyUser != nil{
                    relatedId = (self.replyUser?.id)!
                }
                let currentUser = UserModel.getCurrentUser()
                let accountId = currentUser?.id
                let tourId = self.feed?.id

                self.createComment2Feed(tourId!, accountId: accountId!, content: content!, relatedId: relatedId)
            }
        }
        self.view.addSubview(self.commentTextView!)
        self.commentTextView?.textView?.delegate = self
    }
    
    func loadNewData(){
        var dic = [String:AnyObject]()
        dic["tourId"] = self.feed?.id
        SocketManager.sharedInstance.sendMsg("findCommentByFeedId", data: dic, onProto: "findCommentByFeedIded") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                self.comments?.removeAll()
                print("===============\(objs)")
                let models = objs[0]["comments"] as! [AnyObject]
                let comments = CommentModel.getModelFromArray(models)
                self.feed?.comments = comments
//                self.comments = comments
                self.comments = self.getComments()
                self.runInMainQueue({
                    self.tableView?.reloadData()
                    self.tableView?.mj_header.endRefreshing()
                })
            }
        }
    }

// MARK: textViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.commentTextView?.textView?.resignFirstResponder()
            return false
        }
        return true
    }
    
// MARK:keyboard
    func keyboardWillShow(notification:AnyObject){
        self.runInMainQueue { 
            let rect = (notification as! NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
            let y = rect.origin.y
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            self.commentTextView?.frame = CGRect(x: 0, y: y-104, width: self.screenW, height: 40)
            UIView.commitAnimations()
        }
    }
    
    func keyboardWillHide(notification:AnyObject){
        self.runInMainQueue {
            let rect = (notification as! NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
            let y = rect.origin.y
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            self.commentTextView?.frame = CGRect(x: 0, y: y-104, width: self.screenW, height: 40)
            UIView.commitAnimations()
        }
    }
    
// MARK:tableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else{
            return (self.comments?.count)!
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            if self.feed!.picList?.count == 1 {
                return PersonalTravelOnePhotoTableViewCell.heightForCell(self.feed!.content!)
            }
            else{
                return PersonalTravelMutablePhotoTableViewCell.heightForCell(self.feed!.content!,total: CGFloat(self.feed!.picList!.count))
            }
        }
        else{
            let comment = self.comments?[indexPath.row]
            if comment != nil {
                var replyNicname = ""
                let dic = self.getExtraData(comment!)
                if dic != nil {
                   replyNicname = dic!["replyNicname"] as! String
                }
                var content = ""
                if replyNicname != "" {
                    content = "回复：@\(replyNicname) \n \(comment!.content! as String)"
                }
                else{
                    content = comment!.content!
                }
                return PersonalTravelCommentTableViewCell.heightForCell(content)
            }
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let contentLabelW = UIScreen.mainScreen().bounds.width - 20
//        let feed = self.feeds![indexPath.row]
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(_:)))
        let contentLabelW = UIScreen.mainScreen().bounds.width - 20
        let feed = self.feed!
        let contentLabelH = (feed.content! as NSString).boundingRectWithSize(CGSize(width: contentLabelW,height: CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14.0)], context: nil).height + 10
        let currentUser = UserModel.getCurrentUser()?.id
        if indexPath.section == 0{
            if self.feed?.picList?.count == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalTravelOnePhotoTableViewCell", forIndexPath: indexPath) as! PersonalTravelOnePhotoTableViewCell
                cell.selectionStyle = .None
                if userId == currentUser {
                    cell.likeLogo?.enabled = false
                }
                
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
                
                if userId != currentUser {
                    cell.digAction = {() -> Void in
                        self.likeOrNot(feed.digList!, tourId: feed.id!, feed: feed, cell: cell)
                    }
                }
                
                cell.commentAction = nil
                
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
                if userId == currentUser {
                    cell.likeLogo?.enabled = false
                }
                
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
                
                
                if userId != currentUser {
                    cell.digAction = {() -> Void in
                        self.likeOrNot(feed.digList!, tourId: feed.id!, feed: feed,cell: cell)
                    }
                }
                
                cell.commentAction = {() -> Void in
                    self.replyUser = nil
                    self.commentTextView?.textView?.placeHolder = ""
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
        else{
            let comment = self.comments![indexPath.row]
            var userAvatar = ""
            var userNicname = ""
            var replyNicname = ""
            let dic = self.getExtraData(comment)
            if dic != nil{
                userAvatar = dic!["creatorAvatar"] as! String
                userNicname = dic!["creatorNicname"] as! String
                replyNicname = dic!["replyNicname"] as! String
            }
            var content = ""
            if comment.relatedId != "" {
                content = "回复：@\(replyNicname) \n \(comment.content! as String)"
            }
            else{
                content = comment.content!
            }
            let contentLabelH = (content as NSString).boundingRectWithSize(CGSize(width: contentLabelW,height: CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14.0)], context: nil).height + 10
        
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalTravelCommentTableViewCell", forIndexPath: indexPath) as! PersonalTravelCommentTableViewCell
            cell.selectionStyle = .None
            cell.addGestureRecognizer(longPressGestureRecognizer)
            cell.name?.text = userNicname
            let avatarUrl = userAvatar
            cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            let time = TimeManager.sharedInstance.getDateStringFromString(comment.createAt!)
            cell.time?.text = time
            cell.content?.text = content
            cell.contentConstraint?.constant = contentLabelH
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let comment = self.comments![indexPath.row]
            self.replyUser = CoreDataManager.sharedInstance.fetchUserById(comment.creatorId!)
            self.commentTextView?.textView?.placeHolder = "回复：\((self.replyUser?.nickname)!)"
        }
    }
    
// MARK: DataSource
    func getExtraData(comment:CommentModel) -> [String:AnyObject]? {
        if comment.extraData != nil{
            do {
                let extraData = comment.extraData?.dataUsingEncoding(NSUTF8StringEncoding)
                let data = try NSJSONSerialization.JSONObjectWithData(extraData!, options: .MutableContainers)
                return data as? [String : AnyObject]
            } catch {
                // deal with error
            }
        }
        return nil
    }
    
    func getComments() -> [CommentModel]?{
        let models = self.feed?.comments
        var comments = [CommentModel]()
        for item in models! {
            comments.insert(item as! CommentModel, atIndex: 0)
            //            comments.append(item as! CommentModel)
        }
        return comments
    }
    
    func createComment2Feed(tourId:String,accountId:String,content:String,relatedId:String){
        self.commentTextView?.textView?.resignFirstResponder()
        let currentUser = UserModel.getCurrentUser()
        
        var extraDic = [String:AnyObject]()
        extraDic["creatorAvatar"] = currentUser?.headPortraitUrl
        extraDic["creatorNicname"] = currentUser?.nickname
        if self.replyUser?.nickname != nil{
            extraDic["replyNicname"] = self.replyUser?.nickname
        }
        else{
            extraDic["replyNicname"] = ""
        }
        
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(extraDic, options: NSJSONWritingOptions.PrettyPrinted)
            let strJson = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            var dic = [String:AnyObject]()
            dic["tourId"] = tourId
            dic["accountId"] = accountId
            dic["content"] = content
            dic["relatedId"] = relatedId
            dic["extraData"] = strJson
            SocketManager.sharedInstance.sendMsg("createComment2Feed", data: dic, onProto: "createComment2Feeded") { (code, objs) in
                if code == statusCode.Normal.rawValue {
                    let comment = CommentModel.getModelFromDictionary(objs[0]["comment"] as! Dictionary)
                    if comment != nil {
                        self.runInMainQueue({
                            self.comments?.insert(comment!, atIndex: 0)
                            self.tableView?.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
                            self.commentTextView!.textView!.text = ""
                            
                            self.feed?.comments = self.comments
                            NSNotificationCenter.defaultCenter().postNotificationName("CommentVCChange", object: self.feed)
                            
                            let cell = self.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                            if cell!.isKindOfClass(PersonalTravelOnePhotoTableViewCell) {
                                (cell as! PersonalTravelOnePhotoTableViewCell).comment?.text = "\((self.comments!.count) as Int)"
                            }
                            else{
                                (cell as! PersonalTravelMutablePhotoTableViewCell).comment?.text = "\((self.comments!.count) as Int)"
                            }
                        })
                    }
                }
            }
            
        } catch {
            // deal with error
        }
    }
    
    
// MARK: Function
    //点赞
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
                            NSNotificationCenter.defaultCenter().postNotificationName("CommentVCChange", object: feed)
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
                    NSNotificationCenter.defaultCenter().postNotificationName("CommentVCChange", object: feed)
                })
            }
        })
    }
    
    //设置UIMenuItem
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(self.delCommentByCommentId) {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func longPress(recognizer:UILongPressGestureRecognizer){
        if recognizer.state == .Began {
            let cell = recognizer.view
            self.deleteCell = cell as? PersonalTravelCommentTableViewCell
            cell?.becomeFirstResponder()
            
            let delete = UIMenuItem(title: "delete", action: #selector(self.delCommentByCommentId))
            let menu = UIMenuController.sharedMenuController()
            menu.menuItems = [delete]
            menu.setTargetRect((cell?.frame)!, inView: (cell?.superview)!)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    //删除评论
    func delCommentByCommentId(){
        let index = self.tableView?.indexPathForCell(self.deleteCell!)
        let comment = self.comments![(index?.row)!]
        
        var dic = [String:AnyObject]()
        dic["commentId"] = comment.id
        dic["accountId"] = UserModel.getCurrentUser()?.id
        SocketManager.sharedInstance.sendMsg("delCommentByCommentId", data: dic, onProto: "delCommentByCommentIded") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                self.comments?.removeAtIndex((index?.row)!)
                self.feed?.comments = self.comments
                NSNotificationCenter.defaultCenter().postNotificationName("CommentVCChange", object: self.feed)
                
                let alertController = UIAlertController(title: "", message: "delete success", preferredStyle: .Alert)
                let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (confirmAction) in
                    self.runInMainQueue({ 
                        self.tableView?.reloadData()
                    })
                })
                alertController.addAction(confirmAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
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
    
    func pushToDigVC(digList:[String]){
        let digVC = PersonalTravelDigListViewController()
        digVC.digList = digList
        self.navigationController?.pushViewController(digVC, animated: true)
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
