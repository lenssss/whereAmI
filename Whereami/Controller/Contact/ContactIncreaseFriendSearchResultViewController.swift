//
//  ContactIncreaseFriendSearchResultViewController.swift
//  Whereami
//
//  Created by A on 16/5/13.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ContactIncreaseFriendSearchResultViewController: ContactMainViewSearchResultViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ContactItemTableViewCell = tableView.dequeueReusableCellWithIdentifier("ContactItemTableViewCell", forIndexPath: indexPath) as! ContactItemTableViewCell
        let friendModel = currentFriends![indexPath.row]

        let avatarUrl = friendModel.headPortrait != nil ? friendModel.headPortrait : ""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = friendModel.nickname!
        cell.location?.text = "chengdu,China"
        
        cell.addButton?.setTitle(NSLocalizedString("add",tableName:"Localizable", comment: ""), forState: .Normal)
        if self.currentFriends != nil {
            let friend = CoreDataManager.sharedInstance.fetchFriendByFriendId(friendModel.accountId!, friendId: friendModel.friendId!)
            if friend != nil {
                cell.addButton?.setTitle(NSLocalizedString("added",tableName:"Localizable", comment: ""), forState: .Normal)
            }
        }
        
        cell.callBack = {(button) -> Void in
            //self.addFriend(indexPath, cell: cell)
        }
        
        let userModel = CoreDataManager.sharedInstance.fetchUserById(friendModel.friendId!)
        cell.location?.text = userModel?.countryName
        
        return cell
    }
/*
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
                        CoreDataManager.sharedInstance.increaseOrUpdateUser(userData[0] as! UserModel)
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
 */
 
    override func updateSearchResultsForSearchController(searchController: UISearchController) {
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
