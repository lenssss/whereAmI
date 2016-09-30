import UIKit
import MagicalRecord
import FBSDKCoreKit

let jpAppKey:String = "1d435341cd319fb94ee414e9"
let jpChannel:String = "App Store"
let isProduction:Bool = true

let umAppKey:String = "5791bb9167e58e01b0001209"
let umChannel:String = "App Store"

@UIApplicationMain
class AppDelegate:UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //JPUSH
        JPUSHService.registerForRemoteNotificationTypes((UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Alert.rawValue), categories: nil)
        JPUSHService.setupWithOption(launchOptions, appKey: jpAppKey, channel: jpChannel, apsForProduction: isProduction)
        
        LNotificationCenter().rac_addObserverForName(kJPFNetworkDidLoginNotification, object: nil).subscribeNext { (anyObject) in
            let uniqueObj = LUserDefaults().valueForKey("uniqueId")
            if(uniqueObj == nil) {
                return
            }
            
            let uniqueId = uniqueObj as! String
            JPUSHService.setAlias(uniqueId, callbackSelector: nil, object: nil)
        }
        
        //UM
        let config = UMAnalyticsConfig()
        config.appKey = umAppKey
        config.channelId = umChannel
        MobClick.startWithConfigure(config)
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //启动设置
        SettingUpManager.sharedInstance.launch(application, launchOptions: launchOptions)
        
        //window
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        let sessionId = LUserDefaults().objectForKey("sessionId") as? String
        if sessionId != nil {
            self.window?.rootViewController = CustomTabBarViewController()
        }else{
            self.window?.rootViewController  = LoginNavViewController(rootViewController: ChooseLoginItemViewController())
        }
        self.window?.makeKeyAndVisible()
        
        //显示状态栏
        application.statusBarHidden = false
        NSThread.sleepForTimeInterval(1)
        
        return true
    }
    
    /** 注册用户通知(推送) */
    func registerUserNotification(application: UIApplication) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        let userSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(userSettings)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let obj = userInfo as! [String:AnyObject];
        print(obj);//{type:0,battleId:battle.battleId,questionId:question._id};
        
        /*
        if(obj["type"] != nil) {
            let battleType = obj["type"] as! Int
            if(battleType == 1) {
                //收到别人战斗的信息
                let questionId = obj["questionId"] as! String
                
                let alert = UIAlertController.init(title: "挑战", message: "来自好友的挑战", preferredStyle: UIAlertControllerStyle.Alert)
                let action1 = UIAlertAction.init(title: "接受", style: UIAlertActionStyle.Default, handler: { (action) in
                    
                    Alamofire.request(.GET, ProjectConfig.combineUrl(ProjectConfig.findQuestionByIdProto), parameters: ["uniqueId":questionId]).responseJSON { (jsonResponse) in
                        switch jsonResponse.result {
                        case .Success(let json):
                            let response = json as! NSDictionary
                            let statusCode = response.objectForKey("status") as! Int
                            if(statusCode == 200) {
                                
                                let modelDic = response.objectForKey("obj") as! [String:AnyObject]
                                let model = QuestionModel.dic2Model(modelDic)
                                
                                
                                let qVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PointQuestionViewController")
                                qVC.setValue(model, forKey: "questionModel")
                                let nav = UINavigationController.init(rootViewController: qVC)
                                nav.navigationBar.backgroundColor = UIColor(red: 60/255.0, green: 63/255.0, blue: 76/255.0, alpha: 1.0)
                                nav.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 60/255.0, green: 63/255.0, blue: 76/255.0, alpha: 1.0)), forBarMetrics: UIBarMetrics.Default)
                                nav.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
                                nav.navigationBar.tintColor = UIColor.whiteColor()
                                nav.navigationBar.barTintColor = UIColor.whiteColor()
                                nav.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(15.0),NSForegroundColorAttributeName:UIColor.whiteColor()]
                                
                                self.window?.rootViewController?.presentViewController(nav, animated: true, completion: nil)
                            }
                            print(json)
                        case .Failure(let error):
                            print(error)
                        }
                    }
                })
                let action2 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.Default, handler: { (action) in
                    
                })
                
                alert.addAction(action1)
                alert.addAction(action2)
                
            }
        }
 */
        
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.NewData)
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error);
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
        JPUSHService.clearAllLocalNotifications()
        JPUSHService.resetBadge()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        MagicalRecord.cleanUp()
    }

}

