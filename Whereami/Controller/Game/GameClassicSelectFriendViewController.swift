//
//  GameClassicSelectFriendViewController.swift
//  Whereami
//
//  Created by A on 16/3/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class GameClassicSelectFriendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate {
    var questionModel:QuestionModel? = nil
    var tableView:UITableView? = nil
    var searchResultVC: GameClassicSearchResultViewController? = nil
    var searchController:UISearchController? = nil
    
    var friendList:[FriendsModel]? = nil //好友列表
    //var gameRange:CountryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfig()
        
        self.title = NSLocalizedString("chooseOpponents",tableName:"Localizable", comment: "")
        
        self.setUI()
        
        self.friendList = CoreDataManager.sharedInstance.fetchAllFriends()
        
        LNotificationCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).subscribeNext { (notification) -> Void in
            self.searchController?.active = false
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            if viewControllers?.count != 1{
                let index = (viewControllers?.count)! - 2
                let viewController = viewControllers![index]
                self.navigationController?.popToViewController(viewController, animated: true)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.registerClass(GameClassicSelectFriendTableViewCell.self, forCellReuseIdentifier: "GameClassicSelectFriendTableViewCell")
        self.view.addSubview(self.tableView!)
        
        self.searchResultVC = GameClassicSearchResultViewController()
        self.searchResultVC?.callBack = {() -> Void in
            let viewController = GameClassicBattleDetailsViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
       
        let cell:GameClassicSelectFriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("GameClassicSelectFriendTableViewCell", forIndexPath: indexPath) as! GameClassicSelectFriendTableViewCell
        let friend = friendList![indexPath.row]
        let avatar = friend.headPortrait != nil ? friend.headPortrait : ""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatar!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = friendList![indexPath.row].nickname
        cell.location?.text = "chengdu,China"
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        GameParameterManager.sharedInstance.matchUser = [self.friendList![indexPath.row]]
        let viewController = GameClassicBattleDetailsViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController?.active = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
