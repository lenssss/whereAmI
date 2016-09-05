//
//  PersonalMainViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/16.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Kingfisher
//import SDWebImage

class PersonalMainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView:UITableView? = nil
    var items:[String]? = nil
    var logos:[String]? = nil
    var currentUser:UserModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = NSLocalizedString("Personal",tableName:"Localizable", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.customFontWithStyle("Bold", size:18.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.items = ["Shop","Achievements","Settings","Help","Published"]
        self.logos = ["shop","achievements","setting","help","published"]
        
        self.setUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = UIColor.getNavigationBarColor()
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        
        currentUser = UserModel.getCurrentUser()
        self.tableView?.reloadData()
    }
    
    func setUI(){
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        self.tableView?.registerClass(PersonalHeadTableViewCell.self, forCellReuseIdentifier: "PersonalHeadTableViewCell")
        self.tableView?.registerClass(PersonalMainViewCell.self, forCellReuseIdentifier: "PersonalMainViewCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else{
            return (self.items?.count)!
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 13
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        }
        else{
            return 50
        }
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalHeadTableViewCell", forIndexPath: indexPath) as! PersonalHeadTableViewCell
            cell.accessoryType = .DisclosureIndicator
            cell.userNicknameLabel?.text = currentUser?.nickname
            let avatarUrl = currentUser?.headPortraitUrl != nil ? currentUser?.headPortraitUrl : ""
//            cell.userImageView?.setImageWithString(avatarUrl!, placeholderImage: UIImage(named: "avator.png")!)
            cell.userImageView?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            cell.selectionStyle = .None
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalMainViewCell", forIndexPath: indexPath) as! PersonalMainViewCell
            cell.itemNameLabel?.text = self.items![indexPath.row]
            cell.logoView?.image = UIImage(named: self.logos![indexPath.row])
            cell.accessoryType = .DisclosureIndicator
            cell.selectionStyle = .None
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let viewController = TourRecordsViewController()
            viewController.userId = UserModel.getCurrentUser()?.id
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else{
            if indexPath.row == 0 {
                let viewController = PersonalShopViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexPath.row == 1 {
                let viewController = PersonalAchievementsViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexPath.row == 2 {
                let viewController = PersonalSettingsViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
