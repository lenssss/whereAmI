//
//  ChatMainViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/16.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
import ReactiveCocoa
import SocketIOClientSwift
//import SDWebImage

class ChatMainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate {
    
    private var tableView:UITableView? = nil
    private var conversations:[ConversationModel]? = nil
    private var searchResultVC:ChatMainViewSearchResultViewController? = nil
    private var searchController:UISearchController? = nil
    var totalUnread:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("Chat",tableName:"Localizable", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.customFontWithStyle("Bold", size:18.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.setupUI()
        let status = SocketManager.sharedInstance.socket?.status
        if status == SocketIOClientStatus.Connected {
            self.updateConversations()
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).subscribeNext { (notification) -> Void in
            self.searchController?.active = false
        }
        NSNotificationCenter.defaultCenter().rac_addObserverForName(KNotificationConversationChanges, object: nil).subscribeNext { (obj) in
            self.updateConversations()
        }
    }
    
    func setupUI() {
        let addButton = UIButton()
        addButton.bounds = CGRect(x: 0,y: 0,width: 30,height: 30)
        addButton.setBackgroundImage(UIImage(named: "add"), forState: .Normal)
        addButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            self.addMessage()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        
        self.tableView = UITableView()
        self.view.addSubview(self.tableView!)
        self.tableView?.separatorStyle = .None
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.registerClass(ChatItemTableViewCell.self, forCellReuseIdentifier: "ChatItemTableViewCell")
        
        searchResultVC = ChatMainViewSearchResultViewController()
        searchController = UISearchController(searchResultsController: searchResultVC)
        searchController?.searchBar.showsCancelButton = false
        searchController?.searchResultsUpdater = searchResultVC
        searchController?.delegate = self
        searchController?.searchBar.sizeToFit()
        searchController?.active = true
        searchController?.searchBar.delegate = self
        searchController?.searchBar.frame = CGRect(x:self.searchController!.searchBar.frame.origin.x,y: self.searchController!.searchBar.frame.origin.y,width: self.searchController!.searchBar.frame.size.width,height: 44.0)
        
        searchResultVC?.newConversationHasDone = { (conversion:AVIMConversation,hostUser:ChattingUserModel,guestUser:ChattingUserModel) in
            
            self.push2ConversationVC(conversion, hostUser: hostUser, guestUser: guestUser)
        }
        
        self.tableView?.tableHeaderView = searchController?.searchBar
        
//        self.view.addSubview(searchController!.searchBar)
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    func updateConversations (){
        LeanCloudManager.sharedInstance.findRecentConversationsWithBlock({ (avConversations, error) in
            if((error) == nil){
                self.conversations = [ConversationModel]()
                for index in 0..<avConversations.count {
                    let avConversation = avConversations[index] as! AVIMConversation
                    var dbConversation = CoreDataConversationManager.sharedInstance.findDbConversation(avConversation)
                    
                    if dbConversation != nil {
                        let model = ConversationModel.modelFromModels(avConversation, dbModel: dbConversation!)
                        if model != nil {
                            self.conversations?.append(model!)
                        }
                    } else {
                        CoreDataConversationManager.sharedInstance.increaseOrCreateUnreadCountByConversation(avConversation, lastMsg: "", msgType: kAVIMMessageMediaTypeText)
                        dbConversation = CoreDataConversationManager.sharedInstance.findDbConversation(avConversation)
                        let model = ConversationModel.modelFromModels(avConversation, dbModel: dbConversation!)
                        if model != nil {
                            self.conversations?.append(model!)
                        }
                    }
                }
                self.searchResultVC?.conversations = self.conversations
                self.tableView?.reloadData()
                self.getTotalUnread()
            }
        })
    }
    
    func getTotalUnread(){
        guard let conversations = self.conversations else{
            return
        }
        self.totalUnread = 0
        for item in conversations {
            let unread = item.unreadCount
            self.totalUnread = self.totalUnread! + unread!
        }
        if self.totalUnread != 0 {
            self.navigationController!.tabBarItem.badgeValue = "\(self.totalUnread! as Int)"
        }
        else{
            self.navigationController!.tabBarItem.badgeValue = nil
        }
    }
    
//    func registerObserve(){
//        guard let conversations = self.conversations else{
//            return
//        }
//        for item in conversations {
//            self.rac_observeKeyPath("unreadCount", options: [.New,.Old], observer: item, block: { (value, change, causedByDealloc, affectedOnlyLastComponent) in
//                let oldValue = change["old"] as! Int
//                let newValue = change["new"] as! Int
//                let newTotal = self.totalUnread! - oldValue + newValue
//                self.totalUnread = newTotal
//                if self.totalUnread != 0 {
//                    self.tabBarItem.badgeValue = "\(self.totalUnread)"
//                }
//            })
//        }
//    }
    
    func addMessage(){
        let friendVC = ChatSelectFriendViewController()
        friendVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(friendVC, animated: true)
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let status = SocketManager.sharedInstance.socket?.status
        if status == SocketIOClientStatus.Connected {
            self.updateConversations()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.conversations != nil {
            return self.conversations!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ChatItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("ChatItemTableViewCell", forIndexPath: indexPath) as! ChatItemTableViewCell
        cell.selectionStyle = .None
        let conversationModel = conversations![indexPath.row]
        let avatarUrl = conversationModel.guestModel?.headPortrait != nil ? conversationModel.guestModel?.headPortrait : ""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = conversationModel.guestModel?.nickname
        cell.lastMsg?.text = conversationModel.lattestMsg
        let date = (conversationModel.lastTime?.timeIntervalSince1970)!*1000
        cell.lastMsgTime?.text = TimeManager.sharedInstance.getDateStringFromString("\(date)")
        
        cell.msgSum?.hidden = true
        if conversationModel.unreadCount != 0{
            cell.msgSum?.hidden = false
            cell.msgSum?.text = "\(conversationModel.unreadCount! as Int)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //是删除，就删除
        if editingStyle == .Delete {
            let conversationModel = conversations![indexPath.row]
            CoreDataConversationManager.sharedInstance.deleteConversation(conversationModel.avConversation!.conversationId!)
            conversations?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Middle)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("=====================\(searchBar.text)")
    }
    
    /*
    func willPresentSearchController(searchController: UISearchController) {
        //set frame
        UIView.animateWithDuration(0.1) { () -> Void in
            let view = searchController.searchBar;
            let originFrame = view.frame
            let correctFrame = CGRectMake(originFrame.origin.x, originFrame.origin.y+64, originFrame.width, originFrame.height)
            view.frame = correctFrame;
        }
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        
        UIView.animateWithDuration(0) { () -> Void in
            let view = searchController.searchBar;
            let originFrame = view.frame
            let correctFrame = CGRectMake(originFrame.origin.x, originFrame.origin.y-64, originFrame.width, originFrame.height)
            view.frame = correctFrame;
        }
    }
 */
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let conversationModel = conversations![indexPath.row]
        
        CoreDataConversationManager.sharedInstance.clearUnreadCountByConversationId((conversationModel.avConversation?.conversationId)!)
        
        self.push2ConversationVC(conversationModel.avConversation!, hostUser: conversationModel.hostModel!, guestUser: conversationModel.guestModel!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController?.active = false
    }
    
    func push2ConversationVC(conversion:AVIMConversation,hostUser:ChattingUserModel,guestUser:ChattingUserModel) {
        let conversationVC = ConversationViewController()
        conversationVC.conversation = conversion
        conversationVC.hostModel = hostUser
        conversationVC.guestModel = guestUser
        conversationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(conversationVC, animated: true)
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
