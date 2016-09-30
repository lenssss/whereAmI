//
//  GameChallengeBenameViewController.swift
//  Whereami
//
//  Created by A on 16/3/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import SVProgressHUD

class GameChallengeBenameViewController: UIViewController {
    var challengeLogoView:UIImageView? = nil
    var tipLabel:UILabel? = nil
    var nameTextField:UITextField? = nil
    var gameRange:CountryModel? = nil //地区
    var isRandom:Bool? = nil //是否挑战
    var matchUsers:[FriendsModel]? = nil //匹配对手
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        
        self.title = NSLocalizedString("challengeFriend",tableName:"Localizable", comment: "")
        
        self.matchUsers = GameParameterManager.sharedInstance.matchUser
        if self.matchUsers == nil {
            GameParameterManager.sharedInstance.matchUser = [FriendsModel]()
        }
        self.getGameModel()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    func getGameModel(){
        let gameMode = GameParameterManager.sharedInstance.gameMode
        let gameModel = gameMode!["competitor"] as! Int
        if gameModel == Competitor.Friend.rawValue {
            self.isRandom = false
        }
        else{
            self.isRandom = true
        }
    }
    
    func setUI(){
        self.view.backgroundColor = UIColor.getGameColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("next",tableName:"Localizable", comment: ""), style: .Done, target: self, action: #selector(GameChallengeBenameViewController.pushToNextVC))
        
        self.challengeLogoView = UIImageView()
        self.challengeLogoView?.image = UIImage(named: "ChallengeLogo")
        self.challengeLogoView?.contentMode = .ScaleAspectFit
        self.challengeLogoView?.layer.masksToBounds = true
        self.challengeLogoView?.layer.cornerRadius = 50
        self.view.addSubview(self.challengeLogoView!)
        
        self.tipLabel = UILabel()
        self.tipLabel?.text = NSLocalizedString("namingChallenge",tableName:"Localizable", comment: "")
        self.tipLabel?.textAlignment = .Center
        self.view.addSubview(self.tipLabel!)
        
        self.nameTextField = UITextField()
        self.nameTextField?.rac_signalForControlEvents(.EditingDidEndOnExit).subscribeNext({ (textField) in
            textField.resignFirstResponder()
        })
        self.nameTextField?.borderStyle = .RoundedRect
        self.nameTextField?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.nameTextField!)
        
        self.challengeLogoView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 60)
        self.challengeLogoView?.autoSetDimensionsToSize(CGSize(width: 100,height: 100))
        self.challengeLogoView?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.challengeLogoView?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.tipLabel!, withOffset: -50)
        
        self.tipLabel?.autoSetDimensionsToSize(CGSize(width: 200,height: 50))
        self.tipLabel?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.tipLabel?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.nameTextField!, withOffset: -10)
        
        self.nameTextField?.autoPinEdgeToSuperviewEdge(.Left, withInset: 50)
        self.nameTextField?.autoPinEdgeToSuperviewEdge(.Right, withInset: 50)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem?.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pushToNextVC(){
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        if isRandom == false {
            let selectFriendVC = GameChallengeSelectFriendViewController()
            GameParameterManager.sharedInstance.roomTitle = self.nameTextField?.text
            self.navigationController?.pushViewController(selectFriendVC, animated: true)
        }
        else{
            var dict = [String: AnyObject]()
            dict["countryCode"] = GameParameterManager.sharedInstance.gameRange?.countryCode
            dict["accountId"] = UserModel.getCurrentUser()?.id
            dict["title"] = GameParameterManager.sharedInstance.roomTitle
            dict["friendId"] = self.getFriendIdArray()
            SocketManager.sharedInstance.sendMsg("startChangellengeFriendBattle", data: dict, onProto: "startChangellengeFriendBattleed") { (code, objs) in
                if code == statusCode.Normal.rawValue{
//                    CoreDataManager.sharedInstance.consumeLifeItem()
                    print("=====================\(objs)")
                    self.pushVC(objs)
                    self.navigationItem.rightBarButtonItem?.enabled = true
                }
                else if code == statusCode.Error.rawValue {
                    self.runInMainQueue({
                        SVProgressHUD.showErrorWithStatus("error")
                        self.performSelector(#selector(self.SVProgressDismiss), withObject: nil, afterDelay: 1)
                    })
                }
            }
        }
    }
    
    func pushVC(objs:[AnyObject]){
        let matchDetailModel = MatchDetailModel.getModelFromDictionary(objs[0] as! [String : AnyObject])
        GameParameterManager.sharedInstance.matchDetailModel = matchDetailModel
        
        self.runInMainQueue({
            let battleDetailsVC = GameChallengeBattleDetailsViewController()
            self.navigationController?.pushViewController(battleDetailsVC, animated: true)
        })
    }
    
    func getFriendIdArray() -> [AnyObject] {
        var array = [AnyObject]()
        for item in self.matchUsers! {
            var dic = [String: AnyObject]()
            dic["id"] = item.friendId
            array.append(dic)
        }
        return array
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
