//
//  PersonalEditPasswordViewController.swift
//  Whereami
//
//  Created by A on 16/5/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
//import MBProgressHUD
import SVProgressHUD
import ReactiveCocoa

class PersonalEditPasswordViewController: UIViewController {
    
    var password:UITextField? = nil
    var confirmPassword:UITextField? = nil
    
    private var validPwd:Bool = false
    private var validConfirmPwd:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        
        self.setUI()
        self.signalAction()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func nextButtonActivited () {
        if self.validPwd && self.validConfirmPwd {
            self.navigationItem.rightBarButtonItem!.enabled = true
        }
        else
        {
            self.navigationItem.rightBarButtonItem!.enabled = false
        }
    }
    
    func signalAction() {
        let passwordSignal:RACSignal = (self.password?.rac_textSignal())!
        let confirmPasswordSignal:RACSignal = (self.confirmPassword?.rac_textSignal())!
        
        passwordSignal.filter { (currentStr) -> Bool in
            
            if "\(currentStr)".length > 5 {
                return true
            }
            return false
            }.subscribeNext { (finishedStr) -> Void in
                self.validPwd = true
                self.nextButtonActivited()
        }
        
        passwordSignal.filter { (currentStr) -> Bool in
            
            if "\(currentStr)".length > 5 {
                return false
            }
            return true
            }.subscribeNext { (finishedStr) -> Void in
                self.validPwd = false
                self.nextButtonActivited()
        }
        
        confirmPasswordSignal.filter { (currentStr) -> Bool in
            
            if "\(currentStr)".length > 5 {
                return true
            }
            return false
            }.subscribeNext { (finishedStr) -> Void in
                self.validConfirmPwd = true
                self.nextButtonActivited()
        }
        
        confirmPasswordSignal.filter { (currentStr) -> Bool in
            
            if "\(currentStr)".length > 5 {
                return false
            }
            return true
            }.subscribeNext { (finishedStr) -> Void in
                self.validConfirmPwd = false
                self.nextButtonActivited()
        }
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            self.pushBack()
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:  NSLocalizedString("next",tableName:"Localizable", comment: ""), style: .Done, target: self, action: #selector(self.updateItem))
        
        self.password = UITextField()
        self.password?.placeholder = "password"
        self.password?.borderStyle = .RoundedRect
        self.password?.clearButtonMode = .Always
        self.password?.secureTextEntry = true
        self.view.addSubview(self.password!)
        
        self.confirmPassword = UITextField()
        self.confirmPassword?.placeholder = "confirm password"
        self.confirmPassword?.clearButtonMode = .Always
        self.confirmPassword?.borderStyle = .RoundedRect
        self.confirmPassword?.secureTextEntry = true
        self.view.addSubview(self.confirmPassword!)
        
        self.password?.autoPinEdgeToSuperviewEdge(.Top,withInset: 16)
        self.password?.autoPinEdgeToSuperviewEdge(.Left,withInset: 0)
        self.password?.autoPinEdgeToSuperviewEdge(.Right,withInset: 0)
        self.password?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.confirmPassword!,withOffset: -5)
        self.password?.autoSetDimension(.Height, toSize: 44)
        
        self.confirmPassword?.autoPinEdgeToSuperviewEdge(.Left,withInset: 0)
        self.confirmPassword?.autoPinEdgeToSuperviewEdge(.Right,withInset: 0)
        self.confirmPassword?.autoSetDimension(.Height, toSize: 44)
    }
    
    func updateItem(){
        if self.password?.text == self.confirmPassword?.text {
            let currentUser = UserModel.getCurrentUser()
            
            var dic = [String:AnyObject]()
            dic["accountId"] = currentUser?.id
            dic["password"] = self.password?.text
//            let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            hub.color = UIColor.clearColor()
            SVProgressHUD.setBackgroundColor(UIColor.clearColor())
            SVProgressHUD.show()
            SocketManager.sharedInstance.sendMsg("accountUpdate", data: dic, onProto: "accountUpdateed") { (code, objs) in
                if code == statusCode.Normal.rawValue {
                    self.runInMainQueue({ 
//                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        SVProgressHUD.dismiss()
                        self.pushBack()
                    })
                }
            }
        }
        else{
            self.runInMainQueue({
                let alertController = UIAlertController(title: "warning", message: "两次输入不同", preferredStyle: .Alert)
                let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (confirmAction) in
                    
                })
                alertController.addAction(confirmAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
    
    func pushBack(){
        let viewControllers = self.navigationController?.viewControllers
        let index = (viewControllers?.count)! - 2
        let viewController = viewControllers![index]
        self.navigationController?.popToViewController(viewController, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
