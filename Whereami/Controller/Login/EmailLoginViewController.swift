//
//  EmailLoginViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/4.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
import ReactiveCocoa
import SocketIOClientSwift

class EmailLoginViewController: UIViewController {
    
    private var validEmail:Bool = false
    private var validPwd:Bool = false

    var nextButton:UIButton? = nil
    var emailField:UITextField? = nil
    var passwordField:UITextField? = nil
    var tipLabel:UILabel? = nil
    
    private let placeHolderColor:UIColor = UIColor(red: 149/255.0, green: 148/255.0, blue: 151/255.0, alpha: 1.0)
    private let textColor:UIColor = UIColor(red: 40/255.0, green: 40/255.0, blue: 40/255.0, alpha: 1.0)
    private let borderColor:UIColor = UIColor(red: 218/255.0, green: 218/255.0, blue: 220/255.0, alpha: 1.0)
    private let tipColor:UIColor = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.setupUI()
        self.title = "LOGIN"
        
        self.signalAction()
    }
    
    func nextButtonActivited () {
        if self.validPwd && self.validEmail {
            self.nextButton!.enabled = true
            self.nextButton!.backgroundColor = UIColor(red: 71/255.0, green: 95/255.0, blue: 161/255.0, alpha: 1.0)
        }
        else
        {
            self.nextButton!.enabled = false
            self.nextButton!.backgroundColor = UIColor(red: 183/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0)
        }
    }
    
    /**
     rac部分，由于对rac这个框架不是很熟悉，故增加标志位处理，以后在修改到这里的时候，再进行修改
     */
    func signalAction() {
        
        
        let emailFieldSignal:RACSignal = self.emailField!.rac_textSignal()
        let passwordSignal:RACSignal = self.passwordField!.rac_textSignal()
        
        emailFieldSignal.filter { (currentStr) -> Bool in
            
            if "\(currentStr)".isEmail() {
                return true
            }
            return false
            }.subscribeNext { (finishedStr) -> Void in
//                self.emailField?.textColor = UIColor.greenColor()
                self.validEmail = true
                self.nextButtonActivited()
        }
        
        emailFieldSignal.filter { (currentStr) -> Bool in
            
            if "\(currentStr)".isEmail() {
                return false
            }
            return true
            }.subscribeNext { (finishedStr) -> Void in
//                self.emailField?.textColor = UIColor.blackColor()
                self.validEmail = false
                self.nextButtonActivited()
        }
        
        passwordSignal.filter { (currentStr) -> Bool in
            
            if "\(currentStr)".length > 5 {
                return true
            }
            return false
            }.subscribeNext { (finishedStr) -> Void in
//                self.passwordField?.textColor = UIColor.greenColor()
                self.validPwd = true
                self.nextButtonActivited()
        }
        
        passwordSignal.filter { (currentStr) -> Bool in
            
            if "\(currentStr)".length > 5 {
                return false
            }
            return true
            }.subscribeNext { (finishedStr) -> Void in
//                self.passwordField?.textColor = UIColor.blackColor()
                self.validPwd = false
                self.nextButtonActivited()
        }
        
        self.nextButton?.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (button) -> Void in
            var dict = [String:AnyObject]()
            dict["account"] = self.emailField!.text
            dict["password"] = self.passwordField!.text
            dict["type"] = "login"
//            dict["nickname"] = ""
//            dict["headPortraitId"] = ""
//            dict["countryCode"] = ""
            //print("================\(dict)")
            
            let status = SocketManager.sharedInstance.socket?.status
            if status != SocketIOClientStatus.Connected {
                let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: "网络异常", preferredStyle: .Alert)
                let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (confirmAction) in
                    SocketManager.sharedInstance.connection({ (ifConnection) in
                        
                    })
                })
                alertController.addAction(confirmAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            SocketManager.sharedInstance.sendMsg("login", data: dict, onProto: "logined", callBack: { (code, objs) -> Void in
                if code == statusCode.Normal.rawValue {
                    let dic = objs[0] as! [String:AnyObject]
                    let userData:[AnyObject] = dic["userData"] as! [AnyObject]
                    let modelDic = userData[0] as! [String:AnyObject]
                    let userModel = UserModel.getModelFromDictionary(modelDic)
                    CoreDataManager.sharedInstance.increaseOrUpdateUser(userModel)
                    
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    print("==============\(userDefaults.objectForKey("sessionId"))")
                    
                    userDefaults.setObject(userModel.sessionId, forKey: "sessionId")
                    userDefaults.setObject(userModel.id, forKey: "uniqueId")
                    userDefaults.synchronize()
                    
                    print("==============\(userDefaults.objectForKey("sessionId"))")
                    
                    self.runInMainQueue({() -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName(KNotificationLogin, object: userModel)
                    })
                }
                else{
                    self.runInMainQueue({() -> Void in
                       let dic:[String:AnyObject] = objs[0] as! [String:AnyObject]
                        let errorMsg = dic["message"] as! String
                        let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: errorMsg, preferredStyle: .Alert)
                        let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: nil)
                        alertController.addAction(confirmAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    })
                }
            })

                })
//            self.runInMainQueue({ () -> Void in
//                NSNotificationCenter.defaultCenter().postNotificationName(KNotificationLogin, object: nil)
//            })
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.getMainColor()
        
        emailField = UITextField()
        self.view.addSubview(emailField!)
        passwordField = UITextField()
        self.view.addSubview(passwordField!)
        nextButton = UIButton()
        self.view.addSubview(nextButton!)
        tipLabel = UILabel()
        self.view.addSubview(tipLabel!)
        
        tipLabel?.text = NSLocalizedString("enterEmail",tableName:"Localizable", comment: "")
        tipLabel?.font = UIFont.systemFontOfSize(13.0)
        tipLabel?.textAlignment = .Center
        tipLabel?.textColor = tipColor
        tipLabel?.backgroundColor = UIColor.clearColor()
        
        emailField?.leftViewMode = .Always
        emailField?.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 13, height: 0))
//        emailField?.borderStyle = .RoundedRect
        emailField?.layer.borderWidth = 0.5
        emailField?.layer.borderColor = borderColor.CGColor
        emailField?.keyboardType = UIKeyboardType.EmailAddress
        emailField?.rightViewMode = .WhileEditing
        emailField?.autocapitalizationType = .None
        emailField!.autocorrectionType = .No
        emailField!.spellCheckingType = .No
        emailField?.clearButtonMode = .WhileEditing
        
        passwordField?.leftViewMode = .Always
        passwordField?.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 13, height: 0))
        passwordField?.secureTextEntry = true
        passwordField?.rightViewMode = .WhileEditing
        passwordField?.clearButtonMode = .WhileEditing
        
        passwordField?.backgroundColor = UIColor.whiteColor()
        emailField?.backgroundColor = UIColor.whiteColor()
        
        passwordField?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("passwordPlaceholder",tableName:"Localizable", comment: ""), attributes: [NSForegroundColorAttributeName:placeHolderColor])
        emailField?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("emailPlaceholder",tableName:"Localizable", comment: ""), attributes: [NSForegroundColorAttributeName:placeHolderColor])
        
        passwordField?.textColor = textColor
        emailField?.textColor = textColor
        
        nextButton?.setTitle(NSLocalizedString("Continue",tableName:"Localizable", comment: ""), forState: .Normal)
        
        tipLabel?.autoPinEdgeToSuperviewEdge(.Top)
        tipLabel?.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 0)
        tipLabel?.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 0)
        tipLabel?.autoSetDimension(.Height, toSize: 50)
        
        emailField?.autoPinEdge(.Top, toEdge: .Bottom, ofView: tipLabel!, withOffset: 0)
        emailField?.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 0)
        emailField?.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 0)
        emailField?.autoSetDimension(.Height, toSize: 46)
        
        passwordField?.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailField!, withOffset: 0)
        passwordField?.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 0)
        passwordField?.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 0)
        passwordField?.autoSetDimension(.Height, toSize: 46)
        
        nextButton?.enabled = false
        nextButton?.layer.cornerRadius = 23.0
        nextButton?.layer.masksToBounds = true
        nextButton?.backgroundColor = UIColor(red: 183/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0)
        
        nextButton?.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordField!, withOffset: 30)
        nextButton?.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 50)
        nextButton?.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 50)
        nextButton?.autoSetDimension(.Height, toSize: 46)
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
