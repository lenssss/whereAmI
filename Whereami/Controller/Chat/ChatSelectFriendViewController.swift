//
//  ChatSelectFriendViewController.swift
//  Whereami
//
//  Created by A on 16/5/11.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ChatSelectFriendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate {
    
    
    var tableView:UITableView? = nil
    //    private var currentConversations:[ConversationModel]? = nil
    var searchResultVC:ChatSelectFriendSearchResultViewController? = nil
    var searchController:UISearchController? = nil
    var currentFriends:[FriendsModel]? = nil
    
    var newConversationHasDone:NewConversation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("chooseOpponents",tableName:"Localizable", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.customFontWithStyle("Bold", size:18.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.setupUI()
        
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
    }
    
    func setupUI() {
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.tableView = UITableView()
        self.view.addSubview(self.tableView!)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.registerClass(ContactItemTableViewCell.self, forCellReuseIdentifier: "ContactItemTableViewCell")
        
        searchResultVC = ChatSelectFriendSearchResultViewController()
        searchController = UISearchController(searchResultsController: searchResultVC)
        searchController?.searchResultsUpdater = searchResultVC
        searchController?.delegate = self
        searchController?.searchBar.sizeToFit()
        searchController?.active = true
        searchController?.searchBar.delegate = self
        
        searchResultVC!.newConversationHasDone = { (conversion:AVIMConversation,hostUser:ChattingUserModel,guestUser:ChattingUserModel) in
            
            self.push2ConversationVC(conversion, hostUser: hostUser, guestUser: guestUser)
        }
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.tableView?.tableHeaderView = searchController?.searchBar
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
        let cell:ContactItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("ContactItemTableViewCell", forIndexPath: indexPath) as! ContactItemTableViewCell
        let friendModel = currentFriends![indexPath.row]

        let avatarUrl = friendModel.headPortrait != nil ? friendModel.headPortrait : ""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = friendModel.nickname!
        cell.addButton?.enabled = false
        
        let userModel = CoreDataManager.sharedInstance.fetchUserById(friendModel.friendId!)
        cell.location?.text = userModel?.countryName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friendModel:FriendsModel = self.currentFriends![indexPath.row]
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
