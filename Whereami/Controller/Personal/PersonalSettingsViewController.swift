//
//  PersonalSettingsViewController.swift
//  Whereami
//
//  Created by A on 16/5/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Kingfisher
import MBProgressHUD
import SDWebImage

class PersonalSettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    typealias cacheCompletion = (Double) -> Void
    
    var tableView:UITableView? = nil
    var cacheSize:Double? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.calculateDiskCacheSizeWithCompletionHandler { (size) in
            self.cacheSize = size
            self.tableView?.reloadData()
        }
        
        self.setUI()
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2 || section == 3 || section == 4 {
            return 1
        }
        else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 4 {
            return 0
        }
        else{
            return 13
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        if indexPath.section == 0 {
            cell.textLabel?.text = "Account and Security"
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Message Notification"
            }
            else{
                cell.textLabel?.text = "Sound"
            }
        }
        else if indexPath.section == 2 {
            let cacheString = String(format: "%.2fM", cacheSize!)
            cell.textLabel?.text = "Clear cache(\(cacheString))"
        }
        else if indexPath.section == 3 {
            cell.textLabel?.text = "About us"
        }
        else{
            cell.accessoryType = .None
            let button = UIButton()
            button.frame = cell.bounds
            button.backgroundColor = UIColor(red: 246/255.0, green: 137/255.0, blue: 140/255.0, alpha: 1)
            button.setTitle("Sign out", forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
                self.logOut()
            })
            cell.contentView.addSubview(button)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let viewController = PersonalEditViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if indexPath.section == 1 {
            if indexPath.row  == 0 {
                self.present2setting()
            }
            else{
                self.present2setting()
            }
        }
        else if indexPath.section == 2 {
            SDImageCache.sharedImageCache().clearDisk()
            KingfisherManager.sharedManager.cache.clearDiskCache()
            self.calculateDiskCacheSizeWithCompletionHandler { (size) in
                self.cacheSize = size
                self.tableView?.reloadData()
            }
        }
        else{
            
        }
    }
    
    func calculateDiskCacheSizeWithCompletionHandler(completion:cacheCompletion){
        var imageSize = 0
        let cache = KingfisherManager.sharedManager.cache
        cache.calculateDiskCacheSizeWithCompletionHandler { (size) in
            imageSize += Int(size)
            let SDCache = SDImageCache.sharedImageCache()
            SDCache.calculateSizeWithCompletionBlock({ (fileCount, totalSize) in
                imageSize += Int(totalSize)
                let size = Double(imageSize)/(1024.0*1024)
                completion(size)
            })
        }
    }
    
    func logOut(){
        if FBSDKAccessToken.currentAccessToken() != nil {
            let manager = FBSDKLoginManager()
            manager.logOut()
            
//            let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()
//            let httpCookies = cookies.cookiesForURL(NSURL(string: "http://login.facebook.com")!)
//            for cookie in httpCookies! {
//                cookies.deleteCookie(cookie)
//            }
//            let httpsCookies = cookies.cookiesForURL(NSURL(string: "https://login.facebook.com")!)
//            for cookie in httpsCookies! {
//                cookies.deleteCookie(cookie)
//            }
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("sessionId")
        userDefaults.removeObjectForKey("uniqueId")
        userDefaults.synchronize()
        
        SocketManager.sharedInstance.disconnection()
        SocketManager.sharedInstance.connection { (ifConnected:Bool) in
            if ifConnected {

            }
        }
        
        JPUSHService.setAlias("", callbackSelector: nil, object: nil)
        
        let currentWindow = (UIApplication.sharedApplication().delegate!.window)!
        currentWindow!.rootViewController = LoginNavViewController(rootViewController: ChooseLoginItemViewController())
    }
    
    func present2setting(){
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        if UIApplication.sharedApplication().canOpenURL(url!){
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
