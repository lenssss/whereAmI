//
//  GameChallengeSelectFriendViewController.swift
//  Whereami
//
//  Created by A on 16/3/29.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import SVProgressHUD

class GameChallengeSelectFriendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate {
    var questionModel:QuestionModel? = nil
    var tableView:UITableView? = nil
    var searchResultVC: GameChallengeSearchResultViewController? = nil
    var searchController:UISearchController? = nil
    var friendList:[FriendsModel]? = nil
    var matchUsers:[FriendsModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.title = "房间名：" + GameParameterManager.sharedInstance.roomTitle!
        
        self.matchUsers = GameParameterManager.sharedInstance.matchUser
        if self.matchUsers == nil {
            GameParameterManager.sharedInstance.matchUser = [FriendsModel]()
        }
        
        self.friendList = CoreDataManager.sharedInstance.fetchAllFriends()
        self.setUI()
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).subscribeNext { (notification) -> Void in
            self.searchController?.active = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("next",tableName:"Localizable", comment: ""), style: .Done, target: self, action: #selector(GameChallengeSelectFriendViewController.pushToBattleDetailsVC))
        
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.registerClass(GameChallengeSelectFriendTableViewCell.self, forCellReuseIdentifier: "GameChallengeSelectFriendTableViewCell")
        self.view.addSubview(self.tableView!)
        
        self.searchResultVC = GameChallengeSearchResultViewController()
        self.searchController = UISearchController(searchResultsController: searchResultVC)
        self.searchController?.searchResultsUpdater = searchResultVC
        self.searchController?.delegate = self
        self.searchController?.searchBar.sizeToFit()
        self.searchController?.active = true
        self.searchController?.searchBar.delegate = self
        self.tableView?.tableHeaderView = searchController?.searchBar
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friendList != nil {
            print((friendList?.count)!)
            return (friendList?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:GameChallengeSelectFriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("GameChallengeSelectFriendTableViewCell", forIndexPath: indexPath) as! GameChallengeSelectFriendTableViewCell
        let friend = friendList![indexPath.row]
        let avatar = friend.headPortrait != nil ? friend.headPortrait : ""
//        cell.avatar?.setImageWithString(avatar!, placeholderImage: UIImage(named: "avator.png")!)
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatar!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = friend.nickname
        cell.location?.text = "chengdu,China"
        cell.selectionStyle = .None
        
        if ((matchUsers?.indexOf(friend)) != nil) {
            cell.addButton?.setTitle(NSLocalizedString("added",tableName:"Localizable", comment: ""), forState: .Normal)
        }
        else{
            cell.addButton?.setTitle(NSLocalizedString("add",tableName:"Localizable", comment: ""), forState: .Normal)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friend = friendList![indexPath.row]
        if ((matchUsers?.indexOf(friend)) == nil) {
            self.matchUsers?.append(friend)
        }
        else{
            self.matchUsers?.removeAtIndex((matchUsers?.indexOf(friend))!)
        }
        GameParameterManager.sharedInstance.matchUser = self.matchUsers
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        self.hasMatchUserOrNot()
    }
    
    func pushToBattleDetailsVC(){
        if self.matchUsers?.count != 0 {
            self.navigationItem.rightBarButtonItem?.enabled = false
            var dict = [String: AnyObject]()
            dict["countryCode"] = GameParameterManager.sharedInstance.gameRange?.countryCode
            dict["accountId"] = UserModel.getCurrentUser()?.id
            dict["title"] = GameParameterManager.sharedInstance.roomTitle
            dict["friendId"] = self.getFriendIdArray()
            SocketManager.sharedInstance.sendMsg("startChangellengeFriendBattle", data: dict, onProto: "startChangellengeFriendBattleed") { (code, objs) in
                if code == statusCode.Normal.rawValue{
                    print("=====================\(objs)")
                    self.pushVC(objs)
                    self.navigationItem.rightBarButtonItem?.enabled = true
                }
                else{
                    SVProgressHUD.showErrorWithStatus("error")
                    self.performSelector(#selector(self.dismiss), withObject: nil, afterDelay: 0.5)
                }
            }
        }
    }
    
    func dismiss(){
        SVProgressHUD.dismiss()
    }
    
    func pushVC(objs:[AnyObject]){
        let matchDetailModel = MatchDetailModel.getModelFromDictionary(objs[0] as! [String : AnyObject])
        GameParameterManager.sharedInstance.matchDetailModel = matchDetailModel
        
        self.runInMainQueue({
            let battleDetailsVC = GameChallengeBattleDetailsViewController()
            //battleDetailsVC.matchDetailModel = matchDetailModel
            self.navigationController?.pushViewController(battleDetailsVC, animated: true)
        })
    }
    
    func getFriendIdArray() -> [AnyObject] {
        var array = [AnyObject]()
        for item in self.matchUsers! {
            var dic = [String: AnyObject]()
            dic["id"] = item.friendId
            array.append(dic)
        }
        return array
    }
    
    func hasMatchUserOrNot(){
        if self.matchUsers?.count == 0 {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        else{
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController?.active = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
