//
//  GameEvaluateBottomView.swift
//  Whereami
//
//  Created by A on 16/3/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

enum GameEvaluateButtonType:Int {
    case Boring = 1
    case Fun = 2
    case Continue = 3
    case Collect = 4
    case report = 5
}

class GameEvaluateBottomView: UIView {
    typealias ButtonCallback = (UIButton) -> Void
    
    var creatorNameLabel:UILabel? = nil
    var creatorAvatar:UIImageView? = nil
    var creatorLocation:UILabel? = nil
    var collectionButton:UIButton? = nil
    var boringButton:UIButton? = nil
    var interestingButton:UIButton? = nil
    var continueButton:UIButton? = nil
    var reportButton:UIButton? = nil
    var callBack:ButtonCallback? = nil

    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }
    
    func setUI(){
//        self.creatorAvatar = UIImageView()
//        self.creatorAvatar?.layer.masksToBounds = true
//        self.creatorAvatar?.layer.cornerRadius = 20
//        self.addSubview(self.creatorAvatar!)
//        
//        self.creatorNameLabel = UILabel()
//        self.creatorNameLabel?.textAlignment = .Left
//        self.creatorNameLabel?.textColor = UIColor.whiteColor()
//        self.creatorNameLabel?.text = "lens"
//        self.addSubview(self.creatorNameLabel!)
//        
//        self.creatorLocation = UILabel()
//        self.creatorLocation?.textAlignment = .Left
//        self.creatorLocation?.textColor = UIColor.whiteColor()
//        self.creatorLocation?.text = "Chengdu,China"
//        self.addSubview(self.creatorLocation!)
        
        self.collectionButton = UIButton(type:.System)
//        self.collectionButton?.setTitle("+", forState: .Normal)
        self.collectionButton?.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.collectionButton?.setBackgroundImage(UIImage(named: "collect"), forState: .Normal)
        self.collectionButton?.tag = GameEvaluateButtonType.Collect.rawValue
        self.collectionButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.callBack!(button as! UIButton)
        })
        self.addSubview(self.collectionButton!)
        
        self.boringButton = UIButton(type: .System)
        self.boringButton?.setTitle(NSLocalizedString("Borign",tableName:"Localizable", comment: ""), forState: .Normal)
        self.boringButton?.tag = GameEvaluateButtonType.Boring.rawValue
        self.boringButton?.layer.masksToBounds = true
        self.boringButton?.layer.cornerRadius = 10
        self.boringButton?.setBackgroundImage(UIImage(named: "boring"), forState: .Normal)
        self.boringButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.boringButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.callBack!(button as! UIButton)
        })
        self.addSubview(self.boringButton!)
        
        self.interestingButton = UIButton(type: .System)
        self.interestingButton?.setTitle(NSLocalizedString("Fun",tableName:"Localizable", comment: ""), forState: .Normal)
        self.interestingButton?.tag = GameEvaluateButtonType.Fun.rawValue
        self.interestingButton?.layer.masksToBounds = true
        self.interestingButton?.layer.cornerRadius = 10
        self.interestingButton?.setBackgroundImage(UIImage(named: "interesting"), forState: .Normal)
        self.interestingButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.interestingButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.callBack!(button as! UIButton)
        })
        self.addSubview(self.interestingButton!)
        
        self.continueButton = UIButton(type: .System)
        self.continueButton?.setTitle(NSLocalizedString("Continue",tableName:"Localizable", comment: ""), forState: .Normal)
        self.continueButton?.tag = GameEvaluateButtonType.Continue.rawValue
        self.continueButton?.layer.masksToBounds = true
        self.continueButton?.layer.cornerRadius = 10
        self.continueButton?.setBackgroundImage(UIImage(named: "continue"), forState: .Normal)
        self.continueButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.continueButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.callBack!(button as! UIButton)
        })
        self.addSubview(self.continueButton!)
        
        self.reportButton = UIButton(type: .System)
        self.reportButton?.setTitle(NSLocalizedString("report",tableName:"Localizable", comment: ""), forState: .Normal)
        self.reportButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.reportButton?.tag = GameEvaluateButtonType.report.rawValue
        self.reportButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.callBack!(button as! UIButton)
        })
        self.addSubview(self.reportButton!)
        
//        self.creatorAvatar?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
//        self.creatorAvatar?.autoPinEdgeToSuperviewEdge(.Left, withInset: 70)
//        self.creatorAvatar?.autoSetDimensionsToSize(CGSize(width: 40,height: 40))
//        
//        self.creatorNameLabel?.autoPinEdge(.Top, toEdge: .Top, ofView: self.creatorAvatar!)
//        self.creatorNameLabel?.autoPinEdge(.Left, toEdge: .Right, ofView: self.creatorAvatar!, withOffset: 10)
//        self.creatorNameLabel?.autoSetDimension(.Height, toSize: 20)
//        self.creatorNameLabel?.autoPinEdge(.Right, toEdge: .Left, ofView: self.collectionButton!)
//        self.creatorNameLabel?.autoPinEdge(.Bottom, toEdge: .Top, ofView:self.creatorLocation!)
//        
//        self.creatorLocation?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.creatorAvatar!)
//        self.creatorLocation?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.creatorNameLabel!)
//        self.creatorLocation?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.creatorNameLabel!)
        
        self.collectionButton?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
//        self.collectionButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 70)
        self.collectionButton?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.collectionButton?.autoSetDimensionsToSize(CGSize(width: 40,height: 40))
        
        self.boringButton?.autoPinEdgeToSuperviewEdge(.Left, withInset: 20.0)
        self.boringButton?.autoPinEdge(.Right, toEdge: .Left, ofView: self.interestingButton!, withOffset: -20)
        self.boringButton?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.continueButton!, withOffset: -10.0)
        self.boringButton?.autoSetDimension(.Width, toSize: 100)
        
        self.interestingButton?.autoMatchDimension(.Width, toDimension: .Width, ofView: self.boringButton!)
        self.interestingButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 20.0)
        self.interestingButton?.autoPinEdge(.Top, toEdge: .Top, ofView: self.boringButton!)
        
        self.continueButton?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.boringButton!)
        self.continueButton?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.interestingButton!)
        self.continueButton?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.reportButton!, withOffset: -20.0)
        
        self.reportButton?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.continueButton!)
        self.reportButton?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.continueButton!)
        self.reportButton?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)
        
        let buttonArray = NSArray(objects: self.boringButton!,self.interestingButton!,self.continueButton!,self.reportButton!)
        buttonArray.autoMatchViewsDimension(.Height)
    }

}
