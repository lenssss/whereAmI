//
//  ChooseLoginItemViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/4.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
import FBSDKLoginKit
import Kingfisher

class ChooseLoginItemViewController: UIViewController,UINavigationControllerDelegate {
    var faceBookButton:UIButton? = nil
    var emailButton:UIButton? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        
        self.navigationController?.delegate = self
        
        emailButton!.addTarget(self, action: #selector(self.push2EmailLogin), forControlEvents: .TouchUpInside)
        self.title = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        LApplication().setStatusBarHidden(false, withAnimation: .None)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor(red: 57/255.0, green: 169/255.0, blue: 184/255.0, alpha: 1.0)
        
        faceBookButton = UIButton()
        emailButton = UIButton()
        
        faceBookButton?.setTitle(NSLocalizedString("signInFB",tableName:"Localizable", comment: ""), forState: UIControlState.Normal);
        self.view.addSubview(faceBookButton!);
        faceBookButton?.backgroundColor = UIColor(red: 59/255.0, green: 88/255.0, blue: 152/255.0, alpha: 1.0)
        faceBookButton?.layer.cornerRadius = 6.0
        faceBookButton?.titleLabel?.font = UIFont.customFont(17.0)
        faceBookButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            let login = FBSDKLoginManager()
            FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
            
            login.logInWithPublishPermissions(["public_profile","email","user_friends"], fromViewController: self, handler: { (result, error) in
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    
                    FBSDKGraphRequest(graphPath: "me",parameters: ["fields":"picture,name,locale,email"]).startWithCompletionHandler({ (connection, result, error) in
                        if error == nil{
                            print(result)
                            print()
                            
                            /*
                             var dict = [String:AnyObject]()
                             dict["id"] = result["id"] as! String
                             dict["name"] = result["name"] as! String
                             let url = result["picture"]!["data"]!["url"] as? String
                             let image = UIImage(data: NSData(contentsOfURL: NSURL(string: url!)!)!)
                             dict["pic"] = image?.image2String()
                             
                             SocketManager.sharedInstance.sendMsg("faceBookLogin", data: dict, onProto: "faceBookLogined", callBack: { (code, objs) -> Void in
                             //print("--------------------\(code)")
                             
                             if code == statusCode.Normal.rawValue {
                             //print("++++++++++++++++++++\(objs[0])")
                             let modelDic:[String:AnyObject] = objs[0] as! [String:AnyObject]
                             let userModel = UserModel.getModelFromDictionary(modelDic["account"] as! NSDictionary)
                             CoreDataManager.sharedInstance.increaseOrUpdateUser(userModel)
                             
                             let userDefaults = NSUserDefaults.standardUserDefaults()
                             print("==============\(userDefaults.objectForKey("sessionId"))")
                             
                             userDefaults.setObject(userModel.sessionId, forKey: "sessionId")
                             userDefaults.setObject(userModel.id, forKey: "uniqueId")
                             userDefaults.synchronize()
                             
                             print("==============\(userDefaults.objectForKey("sessionId"))")
                             
                             self.runInMainQueue({() -> Void in
                             self.dismissViewControllerAnimated(true, completion: {
                             NSNotificationCenter.defaultCenter().postNotificationName(KNotificationLogin, object: userModel)
                             })
                             })
                             }
                             else{
                             self.runInMainQueue({ [unowned self]() -> Void in
                             let dic:[String:AnyObject] = objs[0] as! [String:AnyObject]
                             let errorMsg = dic["message"] as! String
                             let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: errorMsg, preferredStyle: .Alert)
                             let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: nil)
                             alertController.addAction(confirmAction)
                             self.presentViewController(alertController, animated: true, completion: nil)
                             })
                             }
                             })
                             */
                        }
                    })
                }
            })
        })
        
        emailButton?.setTitle(NSLocalizedString("signInEmail",tableName:"Localizable", comment: ""), forState: UIControlState.Normal);
        emailButton?.backgroundColor = UIColor.whiteColor()
        emailButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        emailButton?.layer.cornerRadius = 6.0;
        self.view.addSubview(emailButton!);
        emailButton?.titleLabel?.font = UIFont.customFont(17.0)
        
        /*
        let orLabel = UILabel()
        orLabel.text = NSLocalizedString("or",tableName:"Localizable", comment: "")
        orLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(orLabel);
        
        let leftLineView = UIView()
        leftLineView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(leftLineView)
        
        let rightLineView = UIView()
        self.view.addSubview(rightLineView)
        rightLineView.backgroundColor = UIColor.whiteColor()
 */
        
        let textLabel = UILabel();
        textLabel.text = NSLocalizedString("haveNoAccount",tableName:"Localizable", comment: "")
        textLabel.textColor = UIColor.whiteColor()
//        [UIFont fontWtihName:@"Arial-BoldMT" size: 16]
        textLabel.font = UIFont.customFont(12.0)
        self.view .addSubview(textLabel)
        
        let loginButton = UIButton();
        loginButton.titleLabel?.font = UIFont.customFontWithStyle("Bold", size: 12.0)
        loginButton.setTitle(NSLocalizedString("signUp",tableName:"Localizable", comment: ""), forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            self.push2SignUp()
        }
        self.view.addSubview(loginButton)
        
        textLabel.autoAlignAxis(ALAxis.Vertical, toSameAxisOfView: self.view,withOffset: -25);
        textLabel.autoPinToBottomLayoutGuideOfViewController(self, withInset: 80, relation: .Equal)
        textLabel.autoSetDimension(.Height, toSize: 20.0)
        
        loginButton.autoAlignAxis(ALAxis.Horizontal, toSameAxisOfView: textLabel);
        loginButton.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Right, ofView: textLabel, withOffset: 5);
        
        emailButton!.autoSetDimension(ALDimension.Height, toSize: 45)
        emailButton!.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: loginButton, withOffset: -30)
        emailButton!.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: faceBookButton!,withOffset: 20)
        emailButton!.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 30)
        emailButton!.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 30)
        
        /*
        orLabel.autoAlignAxis(.Vertical, toSameAxisOfView: self.view)
        orLabel.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: faceBookButton!,withOffset: 10)
        orLabel.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: emailButton!,withOffset: -10)
        
        leftLineView.autoSetDimension(ALDimension.Height, toSize: 1)
        leftLineView.autoAlignAxis(.Horizontal, toSameAxisOfView: orLabel)
        leftLineView.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 16)
        leftLineView.autoPinEdge(ALEdge.Right, toEdge: .Left, ofView: orLabel, withOffset:-5);
        
        rightLineView.autoSetDimension(ALDimension.Height, toSize: 1)
        rightLineView.autoAlignAxis(.Horizontal, toSameAxisOfView: orLabel)
        rightLineView.autoPinEdge(ALEdge.Left, toEdge: .Right, ofView: orLabel, withOffset:5);
        rightLineView.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 16)
 */
        
        faceBookButton!.autoSetDimension(ALDimension.Height, toSize: 45)
        faceBookButton!.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 30)
        faceBookButton!.autoPinEdgeToSuperviewEdge(ALEdge.Right, withInset: 30)
        
    }
    
//     MARK: UINavigationControllerDelelgate
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController.isKindOfClass(ChooseLoginItemViewController.self) {
            self.navigationController?.navigationBarHidden = true
        }
        else{
            self.navigationController?.navigationBarHidden = false
        }
    }
    
    func push2EmailLogin() {
        let loginVC = EmailLoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func push2SignUp() {
        let signUpVC = SignUpViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)
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
