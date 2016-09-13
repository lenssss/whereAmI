//
//  ContactPresentNewGameViewController.swift
//  Whereami
//
//  Created by A on 16/5/18.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ContactPresentNewGameViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate {
    var tipLabel:UILabel? = nil
    var countryCollectionView:UICollectionView? = nil
    var gameModelOfClassicButton:UIButton? = nil
    var gameModelOfChallengeButton:UIButton? = nil
    var startGameButton:UIButton? = nil
    var gameModeLabel:UILabel? = nil
    var countries:[CountryModel]? = nil
    var gameModel:Int? = gameMode.Classic.rawValue
    var gameRange:CountryModel? = nil
    let selectGameModeView:UIImageView = UIImageView(image: UIImage(named: "select"))
    var friend:FriendsModel? = nil
    
    var leftConstraintsOfSelectedGameModeView:NSLayoutConstraint? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries = FileManager.sharedInstance.readCountryListFromFile()
        
        let country = countries![0]
        self.gameRange = country
        
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        
        self.title = NSLocalizedString("newGame",tableName:"Localizable", comment: "")
        
        self.setUI()
    }
    
    func setUI(){
        self.view.backgroundColor = UIColor.getNavigationBarColor()
        
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
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
        self.gameModelOfClassicButton?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.startGameButton!, withOffset: -10.0)
        self.gameModelOfClassicButton?.autoSetDimension(.Height, toSize: 50)
        
        self.gameModelOfChallengeButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 16)
        self.gameModelOfChallengeButton?.autoMatchDimension(.Width, toDimension: .Width, ofView: self.gameModelOfClassicButton!)
        self.gameModelOfChallengeButton?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.gameModelOfClassicButton!)
        self.gameModelOfChallengeButton?.autoPinEdge(.Top, toEdge: .Top, ofView: self.gameModelOfClassicButton!)
        self.gameModelOfChallengeButton?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.startGameButton!)
        
        self.startGameButton?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 100)
        self.startGameButton?.autoSetDimension(.Height, toSize: 50)
        self.startGameButton?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.gameModelOfClassicButton!)
        self.startGameButton?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.gameModelOfChallengeButton!)
        
        self.view.addSubview(self.selectGameModeView)
        self.selectGameModeView.hidden = false
        leftConstraintsOfSelectedGameModeView = self.selectGameModeView.autoPinEdge(.Right, toEdge: .Right, ofView: self.gameModelOfClassicButton!, withOffset: 0, relation: NSLayoutRelation.Equal)
        self.selectGameModeView.autoPinEdge(.Top, toEdge: .Top, ofView: self.gameModelOfClassicButton!, withOffset: 0, relation: NSLayoutRelation.Equal)
        self.selectGameModeView.autoSetDimensionsToSize(CGSize(width: 20,height: 20))
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
        
        cell.countryImageView?.image = UIImage.string2Image(country.countrypicture!)
        cell.nameLabel!.text = country.countryName
        cell.selectedView?.hidden = true
        if self.gameRange == country {
            cell.selectedView?.hidden = false
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let maxIndex = (self.countries?.count)! - 1
        if indexPath.row < maxIndex {
            let country = countries![indexPath.row]
            print("=====================\(country.countryName)")
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
    
    func startANewGame(){
        if gameRange != nil {
            GameParameterManager.sharedInstance.clearGameParameter()
            
            GameParameterManager.sharedInstance.gameRange = self.gameRange
            GameParameterManager.sharedInstance.gameMode = ["gameModel":self.gameModel!,"competitor":Competitor.Friend.rawValue]
            GameParameterManager.sharedInstance.matchUser = [friend!]
            print("================\(GameParameterManager.sharedInstance)")
            if gameModel == gameMode.Classic.rawValue {
                let viewController = GameClassicBattleDetailsViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if gameModel == gameMode.Challenge.rawValue {
                let viewController = GameChallengeBenameViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else{
            let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: NSLocalizedString("chooseCountry",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: nil)
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
