//
//  CustomTabBarViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/17.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
import JAMSVGImage
//import TZImagePickerController
import SocketIOClientSwift
import DKImagePickerController

class CustomTabBarViewController: UITabBarController{
    
    var gameVC:GameMainViewController? = nil
    var chatVC:ChatMainViewController? = nil
    var contactVC:ContactMainViewController? = nil
    var photoVC:UIViewController? = nil
    var personalVC:PersonalMainViewController? = nil
    
    var gameNavVC:GameMainNavigationViewController? = nil
    var chatNavVC:ChatMainNavigationViewController? = nil
    var contactNavVC:ContactMainNavigationViewController? = nil
    var photoNavVC: PhotoMainNavigationViewController? = nil
    var personalNavVC:PersonalMainNavigationViewController? = nil
    
    var level:Int? = nil
    var dan:Int? = nil
    
    var asset:DKAsset? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
        self.registerNotification()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        
        let status = SocketManager.sharedInstance.socket?.status
        if status != SocketIOClientStatus.Connected {
            self.runInMainQueue({ 
                let currentWindow = (UIApplication.sharedApplication().delegate!.window)!
                currentWindow!.rootViewController = LoginNavViewController(rootViewController: ChooseLoginItemViewController())
            })
        }
    }
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().rac_addObserverForName(KNotificationGetRemind, object: nil).subscribeNext { (notification) -> Void in
            self.runInMainQueue({
                self.tabBarController?.selectedIndex = 0
            })
            let code = notification.object! as! Int
            if code == statusCode.Normal.rawValue {
                dispatch_sync(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "", message: NSLocalizedString("enterGame",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
                    let confirmAction = UIAlertAction(title: NSLocalizedString("go",tableName:"Localizable", comment: ""), style: .Default, handler:{(UIAlertAction) -> Void in
                        let objs = notification.userInfo["question"]!
                        self.presentToBattleDetailsVC(objs[0]["battleId"] as! String)
                    })
                    let cancelAction = UIAlertAction(title: NSLocalizedString("later",tableName:"Localizable", comment: ""), style: .Cancel, handler: {(UIAlertAction) -> Void in
                        if self.gameVC != nil {
                            self.gameVC!.getBattleList()
                            self.gameVC!.tableView?.reloadData()
                        }
                    })
                    alertController.addAction(confirmAction)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(KNotificationGetDanupedremind, object: nil).subscribeNext { (notification) -> Void in
            dispatch_sync(dispatch_get_main_queue(), {
                let objs = notification.object!
                self.dan = objs![0]["dan"] as? Int
                self.presentAlertController()
            })
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(KNotificationgetLevelupedremind, object: nil).subscribeNext { (notification) -> Void in
            dispatch_sync(dispatch_get_main_queue(), {
                let objs = notification.object!
                self.level = objs![0]["level"] as? Int
                self.presentAlertController()
            })
        }
    }
    
    func presentAlertController(){
        var alertController:UIAlertController? = nil
        if self.dan != nil{
            let message = NSLocalizedString("levelUp",tableName:"Localizable", comment: "")+"\(self.dan! as Int)"
            alertController = UIAlertController(title: NSLocalizedString("congratulations",tableName:"Localizable", comment: ""), message: message, preferredStyle: .Alert)
        }
        else{
             let message = NSLocalizedString("danUp",tableName:"Localizable", comment: "")+"\(self.level! as Int)"
            alertController = UIAlertController(title: NSLocalizedString("congratulations",tableName:"Localizable", comment: ""), message: message, preferredStyle: .Alert)
        }
        let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler:nil)
        alertController!.addAction(confirmAction)
        self.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    func presentToBattleDetailsVC(battleId:String){
        var dict = [String: AnyObject]()
        dict["battleId"] = battleId
        dict["accountId"] = UserModel.getCurrentUser()?.id
        SocketManager.sharedInstance.sendMsg("startBattle", data: dict, onProto: "startBattleed", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue {
                let matchDetailModel = MatchDetailModel.getModelFromDictionary(objs[0] as! [String : AnyObject])
                self.runInMainQueue({
                    let battleDetailsVC = GameClassicBattleDetailsViewController()
                    battleDetailsVC.matchDetailModel = matchDetailModel
                    battleDetailsVC.hidesBottomBarWhenPushed = true
                    let nav = GameMainNavigationViewController(rootViewController: battleDetailsVC)
                    let window = UIApplication.sharedApplication().keyWindow?.rootViewController
                    window!.presentViewController(nav, animated: true, completion: nil)
                })
            }
        })
    }
    
    func setupUI () {
        gameVC = GameMainViewController()
        chatVC = ChatMainViewController()
        contactVC = ContactMainViewController()
        photoVC = UIViewController()
        personalVC = PersonalMainViewController()
        
        gameNavVC = GameMainNavigationViewController(rootViewController: gameVC!)
        chatNavVC = ChatMainNavigationViewController(rootViewController:chatVC!)
        contactNavVC = ContactMainNavigationViewController(rootViewController:contactVC!)
        photoNavVC =  PhotoMainNavigationViewController(rootViewController:photoVC!)
        personalNavVC = PersonalMainNavigationViewController(rootViewController:personalVC!)
        
        let gameItem = gameNavVC!.tabBarItem
        gameItem.title = NSLocalizedString("Game",tableName:"Localizable", comment: "")
        let gameImage = UIImage(named: "home")
        let gameSelectImage = UIImage(named: "m_home")
        gameItem.image = gameImage?.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
        gameItem.selectedImage = gameSelectImage
        
        let contactItem = contactNavVC!.tabBarItem
        contactItem.title = NSLocalizedString("Contact",tableName:"Localizable", comment: "")
        let contactImage = UIImage(named: "friends")
        let contactSelectImage = UIImage(named: "m_friends")
        contactItem.image = contactImage?.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
        contactItem.selectedImage = contactSelectImage
        
        let chatItem = chatNavVC!.tabBarItem
        chatItem.title = NSLocalizedString("Chat",tableName:"Localizable", comment: "")
        let chatImage = UIImage(named: "message")
        let chatSelectImage = UIImage(named: "m_message")
        chatItem.image = chatImage?.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
        chatItem.selectedImage = chatSelectImage
        
        let personalItem = personalNavVC!.tabBarItem
        personalItem.title = NSLocalizedString("Personal",tableName:"Localizable", comment: "")
        let personalImage = UIImage(named: "profile")
        let personalSelectImage = UIImage(named: "m_profile")
        personalItem.image = personalImage?.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
        personalItem.selectedImage = personalSelectImage

        let emptyVC = UIViewController()
        self.viewControllers = [gameNavVC!,chatNavVC!,emptyVC,contactNavVC!,personalNavVC!]
        
        let photoimage = UIImage(named: "tab_add")
        let photoButton = UIButton(type: .System)
        photoButton.setBackgroundImage(photoimage, forState: .Normal)
        photoButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) -> Void in
            
            /*
            let pickerVC = TZImagePickerController(maxImagesCount: 1, delegate: self)
            pickerVC
            pickerVC.didFinishPickingPhotosHandle = {(photo,assets,isSelectOriginalPhoto) -> Void in
                if isSelectOriginalPhoto == true {
                    for item in assets {
                        TZImageManager().getPhotoWithAsset(item, completion: { (image, dic, bool) in
                            self.runInMainQueue({ 
                                self.present2CropperViewController(image)
                            })
                        })
                    }
                }
                else{
                    for item in photo {
                        self.runInMainQueue({
                            self.present2CropperViewController(item)
                        })
                    }
                }
            }
            self.presentViewController(pickerVC, animated: true, completion: nil)
 */
            
            let pickerController = DKImagePickerController()
            pickerController.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.getNavigationBarColor()), forBarMetrics: UIBarMetrics.Default)
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
            pickerController.singleSelect = true
            pickerController.maxSelectableCount = 1
            pickerController.assetType = .AllPhotos
            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                print("didSelectAssets")
                if assets.count != 0 {
                    self.asset = assets[0]
                }
                else{
                    self.asset = nil
                }
            }
            pickerController.didCancel = { () in
                if self.asset != nil {
                    self.asset!.fetchFullScreenImageWithCompleteBlock({ (image, info) in
                        self.runInMainQueue({
                            self.asset = nil
                            self.performSelector(#selector(self.present2CropperViewController(_:)), withObject: image,afterDelay: 0.1)
                        })
                    })
                }
            }
            self.presentViewController(pickerController, animated: true, completion: nil)
        }
        self.tabBar.addSubview(photoButton)
        photoButton.autoCenterInSuperview()
        
        self.tabBar.backgroundColor = UIColor.getNavigationBarColor()
        self.tabBar.backgroundImage = UIImage.imageWithColor(UIColor.getNavigationBarColor())
        self.tabBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
        self.tabBar.tintColor = UIColor.whiteColor()
        self.tabBar.barTintColor = UIColor.whiteColor()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.4)], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Selected)
    }
    
    func present2CropperViewController(image:UIImage){
        print(NSThread.currentThread())
        let viewController = PublishCropperViewController()
        viewController.photoImage = image
        let nav = PhotoMainNavigationViewController(rootViewController: viewController)
        self.presentViewController(nav, animated: true, completion: nil)
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
