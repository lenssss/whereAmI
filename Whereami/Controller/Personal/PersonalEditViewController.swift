//
//  PersonalEditViewController.swift
//  Whereami
//
//  Created by A on 16/5/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalEditViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tableView:UITableView? = nil
    var currentUser:UserModel? = nil
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.setUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.currentUser = UserModel.getCurrentUser()!
        self.tableView?.reloadData()
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: false)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        self.tableView?.registerClass(PersonalEditAvatorViewCell.self, forCellReuseIdentifier: "PersonalEditAvatorViewCell")
        self.tableView?.registerClass(PersonalEditOtherViewCell.self, forCellReuseIdentifier: "PersonalEditOtherViewCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 2
        }
        else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0
        }
        else{
            return 13
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0{
                return 100
            }
            else{
                return 50
            }
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
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalEditAvatorViewCell", forIndexPath: indexPath) as! PersonalEditAvatorViewCell
                cell.selectionStyle = .None
                cell.accessoryType = .DisclosureIndicator
                let avatarUrl = currentUser!.headPortraitUrl != nil ? currentUser!.headPortraitUrl : ""
//                cell.avator?.setImageWithString(avatarUrl!, placeholderImage: UIImage(named: "avator.png")!)
                cell.avator?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalEditOtherViewCell", forIndexPath: indexPath) as! PersonalEditOtherViewCell
                cell.selectionStyle = .None
                cell.accessoryType = .DisclosureIndicator
                cell.itemLabel?.text = "Username"
                cell.tipLabel?.text = currentUser!.nickname
                return cell
            }
        }
        else if indexPath.section == 1{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalEditOtherViewCell", forIndexPath: indexPath) as! PersonalEditOtherViewCell
                cell.selectionStyle = .None
                cell.accessoryType = .DisclosureIndicator
                cell.itemLabel?.text = "Region"
                cell.tipLabel?.text = currentUser!.countryName
                
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("PersonalEditOtherViewCell", forIndexPath: indexPath) as! PersonalEditOtherViewCell
                cell.selectionStyle = .None
                cell.itemLabel?.text = "Email"
                cell.tipLabel?.text = currentUser!.account
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("PersonalEditOtherViewCell", forIndexPath: indexPath) as! PersonalEditOtherViewCell
            cell.selectionStyle = .None
            cell.accessoryType = .DisclosureIndicator
            cell.itemLabel?.text = "Change Password"
            cell.tipLabel?.text = ""
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let avatarUrl = currentUser!.headPortraitUrl != nil ? currentUser!.headPortraitUrl : ""
                let viewController = PersonalEditAvatorViewController()
                viewController.imageString = avatarUrl
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexPath.row == 1 {
                let viewController = PersonalEditOtherViewController()
                viewController.value = currentUser!.nickname
                viewController.type = editType.nickname
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let viewController = PersonalEditOtherViewController()
                viewController.value = currentUser!.countryName
                viewController.type = editType.region
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
        else{
            let viewController = PersonalEditPasswordViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
