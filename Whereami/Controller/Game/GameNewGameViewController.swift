//
//  GameNewGameViewController.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//


import UIKit

class GameNewGameViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate{
    var tipLabel:UILabel? = nil
    var countryCollectionView:UICollectionView? = nil
    var gameModelOfClassicButton:UIButton? = nil
    var gameModelOfChallengeButton:UIButton? = nil
    var competitorFriendButton:UIButton? = nil
    var competitorRandomButton:UIButton? = nil
    var startGameButton:UIButton? = nil
    var gameModeLabel:UILabel? = nil
    let selectGameModeView:UIImageView = UIImageView(image: UIImage(named: "select"))
    let selectCompetitorView:UIImageView = UIImageView(image: UIImage(named: "select"))
    var leftConstraintsOfSelectedGameModeView:NSLayoutConstraint? = nil
    var leftConstraintsOfSelectedCompetitorView:NSLayoutConstraint? = nil
    
    var countries:[CountryModel]? = nil //所有国家
    var gameModel:Int? = 1 //游戏模式
    var competitor:Int? = 3 //游戏类型
    var gameRange:CountryModel? = nil //选中国家
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries = FileManager.sharedInstance.readCountryListFromFile()
        
        guard countries?.count != 0 && countries != nil else{
            return
        }
        let country = countries![0]
        self.gameRange = country
        
        self.setConfig()
        
        self.setUI()
        
        LNotificationCenter().rac_addObserverForName(KNotificationPushToBattleDetailsVC, object: nil).subscribeNext { (notification) in
            self.runInMainQueue({ 
                let battleDetailsVC = GameChallengeBattleDetailsViewController()
                self.navigationController?.pushViewController(battleDetailsVC, animated: true)
                self.navigationItem.rightBarButtonItem?.enabled = true
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        self.title = NSLocalizedString("newGame",tableName:"Localizable", comment: "")
        
        let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        self.tipLabel = UILabel()
        self.tipLabel?.text = NSLocalizedString("selectCountry",tableName:"Localizable", comment: "")
        self.tipLabel?.textColor = UIColor.whiteColor()
        self.tipLabel?.font = UIFont.systemFontOfSize(12.0)
        self.tipLabel?.textAlignment = .Center
        self.view.addSubview(self.tipLabel!)
        
        let flowLayout = UICollectionViewFlowLayout()
        self.countryCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout:flowLayout)
        self.countryCollectionView?.backgroundColor = UIColor.clearColor()
        self.countryCollectionView?.delegate = self
        self.countryCollectionView?.dataSource = self
        self.countryCollectionView?.registerClass(CountryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(self.countryCollectionView!)
        
        self.gameModeLabel = UILabel()
        self.gameModeLabel?.text = NSLocalizedString("gameMode",tableName:"Localizable", comment: "")
        self.gameModeLabel?.font = UIFont.systemFontOfSize(20.0)
        self.gameModeLabel?.textAlignment = .Center
        self.gameModeLabel?.textColor = UIColor.whiteColor()
        self.view.addSubview(self.gameModeLabel!)
        
        self.gameModelOfClassicButton = UIButton()
        self.gameModelOfClassicButton?.setTitle(NSLocalizedString("classic",tableName:"Localizable", comment: ""), forState: .Normal)
        self.gameModelOfClassicButton?.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        self.gameModelOfClassicButton?.layer.cornerRadius = 10
        self.gameModelOfClassicButton?.setBackgroundImage(UIImage(named: "gameMode"), forState: .Normal)
        self.gameModelOfClassicButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.gameModelOfClassicButton?.selected = true
        self.gameModelOfClassicButton?.tag = gameMode.Classic.rawValue
        self.gameModelOfClassicButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.changeGameModel(button! as! UIButton)
        })
        self.view.addSubview(self.gameModelOfClassicButton!)
        
        self.gameModelOfChallengeButton = UIButton()
        self.gameModelOfChallengeButton?.setTitle(NSLocalizedString("challenge",tableName:"Localizable", comment: ""), forState: .Normal)
        self.gameModelOfChallengeButton?.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        self.gameModelOfChallengeButton?.layer.cornerRadius = 10
        self.gameModelOfChallengeButton?.setBackgroundImage(UIImage(named: "gameMode"), forState: .Normal)
        self.gameModelOfChallengeButton?.tag = gameMode.Challenge.rawValue
        self.gameModelOfChallengeButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.gameModelOfChallengeButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.changeGameModel(button! as! UIButton)
        })
        self.view.addSubview(self.gameModelOfChallengeButton!)
        
        self.competitorFriendButton = UIButton()
        self.competitorFriendButton?.setTitle(NSLocalizedString("friends",tableName:"Localizable", comment: ""), forState: .Normal)
        self.competitorFriendButton?.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        self.competitorFriendButton?.layer.cornerRadius = 10
        self.competitorFriendButton?.setBackgroundImage(UIImage(named: "competitor"), forState: .Normal)
        self.competitorFriendButton?.tag = Competitor.Friend.rawValue
        self.competitorFriendButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.competitorFriendButton?.selected = true
        self.competitorFriendButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.changeCompetitor(button! as! UIButton)
        })
        self.view.addSubview(self.competitorFriendButton!)
        
        self.competitorRandomButton = UIButton()
        self.competitorRandomButton?.setTitle(NSLocalizedString("random",tableName:"Localizable", comment: ""), forState: .Normal)
        self.competitorRandomButton?.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        self.competitorRandomButton?.layer.cornerRadius = 10
        self.competitorRandomButton?.setBackgroundImage(UIImage(named: "competitor"), forState: .Normal)
        self.competitorRandomButton?.tag = Competitor.Random.rawValue
        self.competitorRandomButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.competitorRandomButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.changeCompetitor(button! as! UIButton)
        })
        self.view.addSubview(self.competitorRandomButton!)
        
        self.startGameButton = UIButton()
        self.startGameButton?.setTitle(NSLocalizedString("playGame",tableName:"Localizable", comment: ""), forState: .Normal)
        self.startGameButton?.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        self.startGameButton?.layer.cornerRadius = 10
        self.startGameButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.startGameButton?.setBackgroundImage(UIImage(named: "playGame"), forState: .Normal)
        self.startGameButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.startANewGame()
        })
        self.view.addSubview(self.startGameButton!)
        
        self.tipLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        self.tipLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 30)
        self.tipLabel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 30)
        self.tipLabel?.autoSetDimension(.Height, toSize: 50)
        
        self.countryCollectionView?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.tipLabel!, withOffset: 10)
        self.countryCollectionView?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.gameModeLabel!, withOffset: -20)
        self.countryCollectionView?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.tipLabel!)
        self.countryCollectionView?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.tipLabel!)
        
        self.gameModeLabel?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.startGameButton!)
        self.gameModeLabel?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.startGameButton!)
        self.gameModeLabel?.autoSetDimension(.Height, toSize: 50)
        self.gameModeLabel?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.gameModelOfClassicButton!, withOffset: -10.0)
        
        self.gameModelOfClassicButton?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
        self.gameModelOfClassicButton?.autoPinEdge(.Right, toEdge: .Left, ofView: self.gameModelOfChallengeButton!, withOffset: -20.0)
        self.gameModelOfClassicButton?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.competitorFriendButton!, withOffset: -10.0)
        self.gameModelOfClassicButton?.autoSetDimension(.Height, toSize: 50)
        
        self.gameModelOfChallengeButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 16)
        self.gameModelOfChallengeButton?.autoMatchDimension(.Width, toDimension: .Width, ofView: self.gameModelOfClassicButton!)
        self.gameModelOfChallengeButton?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.gameModelOfClassicButton!)
        self.gameModelOfChallengeButton?.autoPinEdge(.Top, toEdge: .Top, ofView: self.gameModelOfClassicButton!)
        self.gameModelOfChallengeButton?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.competitorRandomButton!)
        
        self.competitorFriendButton?.autoMatchDimension(.Width, toDimension: .Width, ofView: self.gameModelOfClassicButton!)
        self.competitorFriendButton?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.gameModelOfClassicButton!)
        self.competitorFriendButton?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.gameModelOfClassicButton!)
        self.competitorFriendButton?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.competitorRandomButton!)
        self.competitorFriendButton?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.startGameButton!, withOffset: -10.0)
        
        self.competitorRandomButton?.autoMatchDimension(.Width, toDimension: .Width, ofView: self.gameModelOfClassicButton!)
        self.competitorRandomButton?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.gameModelOfClassicButton!)
        
        self.startGameButton?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 50)
        self.startGameButton?.autoSetDimension(.Height, toSize: 50)
        self.startGameButton?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.gameModelOfClassicButton!)
        self.startGameButton?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.gameModelOfChallengeButton!)
        
        self.view.addSubview(self.selectGameModeView)
        self.selectGameModeView.hidden = false
        leftConstraintsOfSelectedGameModeView = self.selectGameModeView.autoPinEdge(.Right, toEdge: .Right, ofView: self.gameModelOfClassicButton!, withOffset: 0, relation: NSLayoutRelation.Equal)
        self.selectGameModeView.autoPinEdge(.Top, toEdge: .Top, ofView: self.gameModelOfClassicButton!, withOffset: 0, relation: NSLayoutRelation.Equal)
        self.selectGameModeView.autoSetDimensionsToSize(CGSize(width: 20,height: 20))
        
        self.view.addSubview(self.selectCompetitorView)
        self.selectCompetitorView.hidden = false
        leftConstraintsOfSelectedCompetitorView = self.selectCompetitorView.autoPinEdge(.Right, toEdge: .Right, ofView: self.competitorFriendButton!, withOffset: 0, relation: NSLayoutRelation.Equal)
        self.selectCompetitorView.autoPinEdge(.Top, toEdge: .Top, ofView: self.competitorFriendButton!, withOffset: 0, relation: NSLayoutRelation.Equal)
        self.selectCompetitorView.autoSetDimensionsToSize(CGSize(width: 20,height: 20))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if self.countries != nil {
            return (self.countries?.count)!
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.countryCollectionView!.bounds.width/4,height: self.countryCollectionView!.bounds.height/2)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CountryCollectionViewCell
        let country = countries![indexPath.row]

        if country.countrypicture != nil {
           cell.countryImageView?.image = UIImage.string2Image(country.countrypicture!)
        }
        cell.nameLabel!.text = country.countryName
        cell.selectedView?.hidden = true
        if self.gameRange == country{
            cell.selectedView?.hidden = false
        }
        /*
        if indexPath.row == 0 {
            cell.countryImageView?.image = UIImage(named: "CN")
        }
        else if indexPath.row == 1 {
            cell.countryImageView?.image = UIImage(named: "US")
        }
        else{
            cell.countryImageView?.image = UIImage(named: "AU")
        }
        
        cell.selectedView?.hidden = true
        if indexPath.row == 0 || indexPath.row == 1 {
            let country = countries![indexPath.row]
            cell.nameLabel!.text = country.countryName
            if self.gameRange == country{
                cell.selectedView?.hidden = false
            }
        }
        else{
            cell.nameLabel?.text = "新加坡"
        }
 */

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let maxIndex = (self.countries?.count)! - 1
//        if indexPath.row < maxIndex {
//            let country = countries![indexPath.row]
//            print("=====================\(country.countryName)")
//            self.gameRange = country
//            collectionView.reloadData()
//        }
        let country = countries![indexPath.row]
        if country.countryOpened == 0 {
            self.gameRange = country
            collectionView.reloadData()
        }
    }
    
    func changeGameModel(sender:UIButton){
        let tag = sender.tag
        if gameModel == tag {
            return
        }
        let width = sender.frame.size.width
        if sender == gameModelOfClassicButton {
            self.leftConstraintsOfSelectedGameModeView?.constant = 0
        }
        else{
            self.leftConstraintsOfSelectedGameModeView?.constant = width + 20
        }
        self.gameModel = tag
    }
    
    func changeCompetitor(sender:UIButton){
        let tag = sender.tag
        if competitor == tag {
            return
        }
        let width = sender.frame.size.width
        if sender == competitorFriendButton {
            self.leftConstraintsOfSelectedCompetitorView?.constant = 0
        }
        else{
            self.leftConstraintsOfSelectedCompetitorView?.constant = width + 20
        }
        self.competitor = tag
    }
    
    func startANewGame(){
        if gameRange != nil {
            GameParameterManager.sharedInstance.clearGameParameter()
            
            GameParameterManager.sharedInstance.gameRange = self.gameRange
            GameParameterManager.sharedInstance.gameMode = ["gameModel":self.gameModel!,"competitor":self.competitor!]
            print("================\(GameParameterManager.sharedInstance)")
            if gameModel == gameMode.Classic.rawValue && competitor == Competitor.Friend.rawValue {
                let viewController = GameClassicSelectFriendViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            if gameModel == gameMode.Classic.rawValue && competitor == Competitor.Random.rawValue  {
                let viewController = GameClassicBattleDetailsViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            if gameModel == gameMode.Challenge.rawValue && competitor == Competitor.Friend.rawValue  {
                let viewController = GameChallengeBenameViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            if gameModel == gameMode.Challenge.rawValue && competitor == Competitor.Random.rawValue  {
                let viewController = GameChallengeMatchViewController()
//                self.navigationController?.pushViewController(viewController, animated: true)
                self.presentViewController(viewController, animated: true, completion: nil)
            }
        }
        else{
            let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: NSLocalizedString("chooseCountry",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: nil)
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
