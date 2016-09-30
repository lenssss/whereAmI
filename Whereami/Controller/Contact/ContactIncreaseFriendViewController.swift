//
//  ContactIncreaseFriendViewController.swift
//  Whereami
//
//  Created by A on 16/5/13.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ContactIncreaseFriendViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate {
    
    var tableView:UITableView? = nil
    //    private var currentConversations:[ConversationModel]? = nil
    var searchResultVC:AnyObject? = nil
    var searchController:UISearchController? = nil
    var currentFriends:[FriendsModel]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("chooseOpponents",tableName:"Localizable", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.customFontWithStyle("Bold", size:18.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.setConfig()
        
        self.setupUI()
        
        LNotificationCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).subscribeNext { (notification) -> Void in
            self.searchController?.active = false
        }
    }
    
    func setupUI() {
        self.tableView = UITableView()
        self.view.addSubview(self.tableView!)
        self.tableView?.separatorStyle = .None
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.tableView?.registerClass(ContactMainViewCell.self, forCellReuseIdentifier: "ContactMainViewCell")
        
        searchResultVC = ContactIncreaseFriendSearchResultViewController()
        searchController = UISearchController(searchResultsController: searchResultVC as! ContactIncreaseFriendSearchResultViewController)
        searchController?.searchResultsUpdater = searchResultVC as! ContactIncreaseFriendSearchResultViewController
        searchController?.delegate = self
        searchController?.searchBar.sizeToFit()
        searchController?.active = true
        searchController?.searchBar.delegate = self
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.tableView?.tableHeaderView = searchController?.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactMainViewCell", forIndexPath: indexPath) as! ContactMainViewCell
//        cell.logoView?.image = ""
//        cell.itemLabel!.text = "Facebook"
//        cell.selectionStyle = .None
        return cell
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController?.active = false
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
