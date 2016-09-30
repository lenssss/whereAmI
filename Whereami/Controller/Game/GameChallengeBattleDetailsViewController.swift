//
//  GameChallengeBattleDetailsViewController.swift
//  Whereami
//
//  Created by A on 16/3/29.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class GameChallengeBattleDetailsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var readyLabel:UILabel? = nil
    var startButton:UIButton? = nil
    var userCollectionView:UICollectionView? = nil
    
    var matchDetailModel:MatchDetailModel? = nil
    var matchUser:[AnyObject]? = nil
    var matchUserCollectionView:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        
        self.matchDetailModel = GameParameterManager.sharedInstance.matchDetailModel
        if GameParameterManager.sharedInstance.matchUser == nil {
            self.matchUser = matchDetailModel?.acceptInfo
        }
        else{
            self.matchUser = GameParameterManager.sharedInstance.matchUser
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
        
        self.view.backgroundColor = UIColor.getGameColor()
        
        self.readyLabel = UILabel()
        self.readyLabel?.text = NSLocalizedString("ready",tableName:"Localizable", comment: "")
        self.readyLabel?.textAlignment = .Center
        self.view.addSubview(self.readyLabel!)
        
        let flowLayout = UICollectionViewFlowLayout()
        self.matchUserCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout:flowLayout)
        self.matchUserCollectionView?.backgroundColor = UIColor.clearColor()
        self.matchUserCollectionView?.delegate = self
        self.matchUserCollectionView?.dataSource = self
        self.matchUserCollectionView?.registerClass(GameMatchUserCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(self.matchUserCollectionView!)
        
        self.startButton = UIButton()
        self.startButton?.layer.masksToBounds = true
        self.startButton?.layer.cornerRadius = 10
        self.startButton?.setTitle(NSLocalizedString("start",tableName:"Localizable", comment: ""), forState: .Normal)
        self.startButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.startButton?.backgroundColor = UIColor.whiteColor()
        self.startButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.pushToPlayRoomVC()
        })
        self.view.addSubview(self.startButton!)
        
        self.readyLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 50)
        self.readyLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 90)
        self.readyLabel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 90)
        self.readyLabel?.autoSetDimension(.Height, toSize: 50)
        
        self.matchUserCollectionView?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.readyLabel!, withOffset: 10)
        self.matchUserCollectionView?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.startButton!, withOffset: -20)
        self.matchUserCollectionView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 30)
        self.matchUserCollectionView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 30)
        
        self.startButton?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 50)
        self.startButton?.autoPinEdgeToSuperviewEdge(.Left, withInset: 90)
        self.startButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 90)
        self.startButton?.autoSetDimension(.Height, toSize: 50)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if self.matchUser != nil {
            return (self.matchUser?.count)!
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.matchUserCollectionView!.bounds.width/4,height: self.matchUserCollectionView!.bounds.height/2)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GameMatchUserCollectionViewCell
        let user = self.matchUser![indexPath.row]
        if user.isKindOfClass(FriendsModel.self) == true {
            let avatar = (user as! FriendsModel).headPortrait != nil ? (user as! FriendsModel).headPortrait : ""
//            cell.avatarImageView?.setImageWithString(avatar!, placeholderImage: UIImage(named: "avator.png")!)
            cell.avatarImageView?.kf_setImageWithURL(NSURL(string:avatar!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            cell.usernameLabel?.text = user.nickname
        }
        else{
            print(matchUser)
            let avatar = (user as! AcceptInfoModel).headPortrait != nil ? (user as! AcceptInfoModel).headPortrait:""
//            cell.avatarImageView?.setImageWithString(avatar!, placeholderImage: UIImage(named: "avator.png")!)
            cell.avatarImageView?.kf_setImageWithURL(NSURL(string:avatar!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            cell.usernameLabel?.text = (user as! AcceptInfoModel).nickname
        }
        return cell
    }
    
    func pushToPlayRoomVC(){
        var dict = [String: AnyObject]()
        dict["battleId"] = matchDetailModel?.battleId
        dict["questionId"] = matchDetailModel?.problemId
        
        SocketManager.sharedInstance.sendMsg("queryProblemById", data: dict, onProto: "queryProblemByIded") { (code, objs) in
            print("=======================\(objs)")
            if code == statusCode.Normal.rawValue {
                self.runInMainQueue({
                    GameParameterManager.sharedInstance.battleModel = BattleModel.getModelFromDictionary(objs[0] as! NSDictionary)
                    let playRoomVC = GameQuestionPlayRoomViewController()
                    self.navigationController?.pushViewController(playRoomVC, animated: true)
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
