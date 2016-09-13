//
//  GameClassicStartGameViewController.swift
//  Whereami
//
//  Created by lens on 16/3/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import SVProgressHUD

class GameClassicStartGameViewController: UIViewController {
    var questionClassView:QuestionClassView? = nil
    var restartButton:UIButton? = nil
    var startButton:UIButton? = nil
    var matchDetailModel:MatchDetailModel? = nil
    var kindModel:GameKindModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        self.matchDetailModel = GameParameterManager.sharedInstance.matchDetailModel
        self.getKindOfGame()
        self.setUI()
    }
    
    func getKindOfGame(){
        let kinds = FileManager.sharedInstance.readGameKindListFromFile()
        for item in kinds! {
            if item.kindCode == self.matchDetailModel?.classifyCode {
                self.kindModel = item
                break
            }
        }
    }
    
    func setUI(){
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor.getGameColor()
        
        self.questionClassView = QuestionClassView()
        self.questionClassView?.QuestionClassName?.text = self.kindModel!.kindName
        self.questionClassView?.QuestionClassPicture?.image = UIImage(named: "kindGame")
        self.view.addSubview(self.questionClassView!)
        
        self.questionClassView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 40)
        self.questionClassView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        self.questionClassView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
        self.questionClassView?.autoSetDimension(.Height, toSize: 250)
        
        self.restartButton = UIButton(type: .System)
        self.restartButton?.layer.masksToBounds = true
        self.restartButton?.layer.cornerRadius = 10
        self.restartButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.restartButton?.setTitle("3", forState: .Normal)
        self.restartButton?.setBackgroundImage(UIImage(named: "icon_classic_start_game"), forState:.Normal)
        self.restartButton?.backgroundColor = UIColor.whiteColor()
        self.restartButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.restartGame()
        })
        self.view.addSubview(self.restartButton!)
        
        self.restartButton?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20)
        self.restartButton?.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        self.restartButton?.autoSetDimensionsToSize(CGSize(width: 100,height: 50))
        
        let restartIcon = UIImageView()
        restartIcon.image = UIImage(named: "icon_classic_new_game")
        self.view.addSubview(restartIcon)
        
        restartIcon.autoPinEdge(.Left, toEdge: .Left, ofView: self.restartButton!, withOffset: 10, relation: .Equal)
        restartIcon.autoPinEdge(.Top, toEdge: .Top, ofView: self.restartButton!, withOffset: 10, relation: .Equal)
        restartIcon.autoSetDimensionsToSize(CGSize(width: 30,height: 30))
        
        self.startButton = UIButton(type: .System)
        self.startButton?.layer.masksToBounds = true
        self.startButton?.layer.cornerRadius = 10
        self.startButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.startButton?.setTitle(NSLocalizedString("play",tableName: "Localizable", comment: ""), forState: .Normal)
        self.startButton?.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        self.startButton?.setBackgroundImage(UIImage(named: "icon_classic_start_game"), forState:.Normal)
        self.startButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.pushToPlayRoomVC()
        })
        self.view.addSubview(self.startButton!)
        
        self.startButton?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20)
        self.startButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
        self.startButton?.autoSetDimensionsToSize(CGSize(width: 100,height: 50))
    }
    
    func pushToPlayRoomVC(){
        let playRoomVC = GameQuestionPlayRoomViewController()
//      playRoomVC.battleModel = battleModel
        self.navigationController?.pushViewController(playRoomVC, animated: true)
    }
    
    func restartGame(){
        let battle = GameParameterManager.sharedInstance.battleModel
        
        var dict = [String:AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["battleId"] = matchDetailModel?.battleId
        dict["questionId"] = battle?.questions?.originalProId
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.Clear)
        
        SocketManager.sharedInstance.sendMsg("chooseagain", data: dict, onProto: "chooseagained") { (code, objs) in
            print("=======================\(objs)")
            self.runInMainQueue({ 
                SVProgressHUD.dismiss()
            })
            if code == statusCode.Normal.rawValue {
                let battleModel = BattleModel.getModelFromDictionary(objs[0] as! NSDictionary)
                self.runInMainQueue({ 
                    let viewControllers = self.navigationController?.viewControllers
                    let index = (viewControllers?.count)!-2
                    let viewController = viewControllers![index] as? GameClassicBattleDetailsViewController
                    viewController?.battle = battleModel
                    self.navigationController?.popToViewController(viewController!, animated: true)
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
