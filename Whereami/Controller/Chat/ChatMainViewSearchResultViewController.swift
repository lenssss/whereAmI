//
//  ChatMainViewSearchResultViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

typealias NewConversation = (conversion:AVIMConversation,hostUser:ChattingUserModel,guestUser:ChattingUserModel)->()

class ChatMainViewSearchResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
    
    var tableView:UITableView? = nil
    var searchText:String? = nil
    var conversations:[ConversationModel]? = nil
    var results:[ConversationModel]? = nil
    
    var newConversationHasDone:NewConversation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        
        self.tableView = UITableView()
        self.view.addSubview(self.tableView!)
        self.tableView?.separatorStyle = .None
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(ChatItemTableViewCell.self, forCellReuseIdentifier: "ChatItemTableViewCell")
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results != nil {
            return results!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ChatItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("ChatItemTableViewCell", forIndexPath: indexPath) as! ChatItemTableViewCell
        cell.selectionStyle = .None
        let conversationModel = results![indexPath.row]
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let conversationModel = results![indexPath.row]
        
        CoreDataConversationManager.sharedInstance.clearUnreadCountByConversationId((conversationModel.avConversation?.conversationId)!)
        
        self.dismissViewControllerAnimated(false) { 
            self.newConversationHasDone!(conversion: conversationModel.avConversation!, hostUser: conversationModel.hostModel!, guestUser: conversationModel.guestModel!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.enablesReturnKeyAutomatically = true
        let searchText = searchController.searchBar.text
        if searchText != "" && conversations != nil && conversations?.count != 0 {
            let filterArray = conversations?.filter({($0.guestModel?.nickname?.contains(searchText!))!})
            guard filterArray != nil else {
                results = [ConversationModel]()
                self.tableView?.reloadData()
                return
            }
            results = filterArray
            self.tableView?.reloadData()
        }
    }
}
