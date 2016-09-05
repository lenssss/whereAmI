//
//  GameChallengeMatchViewController.swift
//  Whereami
//
//  Created by A on 16/5/12.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import SVProgressHUD

class GameChallengeMatchViewController: UIViewController {
    
    var timer:NSTimer? = nil
    var matchTime:Int = 10
    var timeLabel:UILabel? = nil
    var isMatch:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }

        self.setUI()
        self.addTimer()
        self.getMatchDetailModel()
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.view.backgroundColor = UIColor.getGameColor()
        
        let radius = self.view.bounds.width/2
        let halo = PulsingHaloLayer().initWithRadius(radius, animationDuration: 3, pulseInterval: 0)
        halo.position = self.view.center
        self.view.layer.addSublayer(halo)
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.text = "RANDOM CHALLENGE"
        titleLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(titleLabel)
        
        let user = UserModel.getCurrentUser()
        let avatarUrl = user?.headPortraitUrl != nil ? user?.headPortraitUrl:""
        
        let logoView = UIImageView()
//        logoView.setImageWithString(avatarUrl!, placeholderImage: UIImage(named: "avator.png")!)
        logoView.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        logoView.contentMode = .ScaleAspectFit
        logoView.layer.masksToBounds = true
        logoView.layer.cornerRadius = 50
        self.view.addSubview(logoView)
        
        let tipLabel = UILabel()
        tipLabel.text = "The Challenge Starts In"
        tipLabel.textColor = UIColor.whiteColor()
        tipLabel.textAlignment = .Center
        self.view.addSubview(tipLabel)
        
        self.timeLabel = UILabel()
        self.timeLabel?.textAlignment = .Center
        self.timeLabel?.textColor = UIColor.whiteColor()
        self.timeLabel?.font = UIFont.boldSystemFontOfSize(20.0)
        self.timeLabel?.text = "\(self.matchTime)"
        self.view.addSubview(self.timeLabel!)
        
//        logoView.autoPinEdgeToSuperviewEdge(.Top, withInset: 60)
//        logoView.autoSetDimensionsToSize(CGSize(width: 100,height: 100))
//        logoView.autoAlignAxisToSuperviewAxis(.Vertical)
//        logoView.autoPinEdge(.Bottom, toEdge: .Top, ofView: tipLabel, withOffset: -50)
        
        logoView.autoAlignAxisToSuperviewAxis(.Vertical)
        logoView.autoAlignAxisToSuperviewAxis(.Horizontal)
        logoView.autoSetDimensionsToSize(CGSize(width: 100,height: 100))
        logoView.autoPinEdge(.Bottom, toEdge: .Top, ofView: tipLabel, withOffset: -30)
        
        titleLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: logoView, withOffset: -60)
        titleLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        titleLabel.autoSetDimensionsToSize(CGSize(width: 200,height: 50))
        
        tipLabel.autoSetDimensionsToSize(CGSize(width: 200,height: 50))
        tipLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        tipLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.timeLabel!, withOffset: -10)
        
        self.timeLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 50)
        self.timeLabel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 50)
        self.timeLabel?.autoSetDimension(.Height, toSize: 50)
    }
    
    func addTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.matchTimeChange), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func getMatchDetailModel(){
        var dict = [String: AnyObject]()
        dict["countryCode"] = GameParameterManager.sharedInstance.gameRange?.countryCode
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["title"] = "Random Changellenge"
        
        SocketManager.sharedInstance.sendMsg("startChangellengeRandomBattle", data: dict, onProto: "startChangellengeRandomBattleed") { (code, objs) in
            if code == statusCode.Normal.rawValue{
//                CoreDataManager.sharedInstance.consumeLifeItem()
                self.isMatch = true
                print("=====================\(objs)")
                let matchDetailModel = MatchDetailModel.getModelFromDictionary(objs[0] as! [String : AnyObject])
                GameParameterManager.sharedInstance.matchDetailModel = matchDetailModel
            }
            else if code == statusCode.Error.rawValue {
                self.runInMainQueue({
                    SVProgressHUD.showErrorWithStatus("error")
                    self.performSelector(#selector(self.SVProgressDismiss), withObject: nil, afterDelay: 1)
                })
            }
        }
    }
    
    func matchTimeChange(){
        self.matchTime -= 1
        self.timeLabel?.text = "\(self.matchTime)"
        if self.matchTime <= 0 {
            self.dismissViewControllerAnimated(false, completion: {
                if self.isMatch {
                    NSNotificationCenter.defaultCenter().postNotificationName(KNotificationPushToBattleDetailsVC, object: nil)
                }
            })
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func SVProgressDismiss(){
        SVProgressHUD.dismiss()
        self.backAction()
    }
    
    func backAction(){
        let viewControllers = self.navigationController?.viewControllers
        if viewControllers?.count != 1{
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
