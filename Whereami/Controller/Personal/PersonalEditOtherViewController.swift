//
//  PersonalEditOtherViewController.swift
//  Whereami
//
//  Created by A on 16/5/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
//import MBProgressHUD
import SVProgressHUD

class PersonalEditOtherViewController: UIViewController {
    
    var textField:UITextField? = nil
    var value:String? = nil
    var type:editType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        if type == editType.nickname {
            self.title = "Nickname"
        }
        else{
            self.title = "Region"
        }
        
        self.setUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            self.pushBack()
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:  NSLocalizedString("next",tableName:"Localizable", comment: ""), style: .Done, target: self, action: #selector(self.updateItem))
        
        self.textField = UITextField()
        self.textField?.clearButtonMode = .Always
        self.textField?.text = self.value
        self.textField?.borderStyle = .RoundedRect
        if type == editType.nickname {
            self.textField?.placeholder = "Nickname"
        }
        else{
            self.textField?.placeholder = "Region"
        }
        self.view.addSubview(self.textField!)
        
        self.textField?.autoPinEdgeToSuperviewEdge(.Top,withInset: 16)
        self.textField?.autoPinEdgeToSuperviewEdge(.Left,withInset: 0)
        self.textField?.autoPinEdgeToSuperviewEdge(.Right,withInset: 0)
        self.textField?.autoSetDimension(.Height, toSize: 44)
    }
    
    func pushBack(){
        let viewControllers = self.navigationController?.viewControllers
        let index = (viewControllers?.count)! - 2
        let viewController = viewControllers![index]
        self.navigationController?.popToViewController(viewController, animated: false)
    }
    
    func updateItem(){
        let currentUser = UserModel.getCurrentUser()
        
        var dic = [String:AnyObject]()
        dic["accountId"] = currentUser?.id
        if type == editType.nickname {
            dic["nickname"] = self.textField?.text
        }
        else if type == editType.region{
            dic["countryName"] = self.textField?.text
        }
//        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hub.color = UIColor.clearColor()
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        SVProgressHUD.show()
        SocketManager.sharedInstance.sendMsg("accountUpdate", data: dic, onProto: "accountUpdateed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                if self.type == editType.nickname {
                    currentUser?.nickname = self.textField?.text
                    CoreDataManager.sharedInstance.increaseOrUpdateUser(currentUser!)
                }
                else if self.type == editType.region{
                    currentUser?.countryName = self.textField?.text
                    CoreDataManager.sharedInstance.increaseOrUpdateUser(currentUser!)
                }
                self.runInMainQueue({
//                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    SVProgressHUD.dismiss()
                    self.pushBack()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
