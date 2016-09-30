//
//  GameAnswerBottomView.swift
//  Whereami
//
//  Created by A on 16/3/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

enum GameAnswerButtonType:Int {
    case answer1 = 1
    case answer2 = 2
    case answer3 = 3
    case answer4 = 4
    case bomb = 5
    case chance = 6
    case skip = 7
    case wrong = 100
}

class GameAnswerBottomView: UIView {
    typealias ButtonCallback = (UIButton) -> Void
    
    var answerBtn1:UIButton? = nil
    var answerBtn2:UIButton? = nil
    var answerBtn3:UIButton? = nil
    var answerBtn4:UIButton? = nil
    var answerButtonArray:[AnyObject]? = nil
    var bombBtn:UIButton? = nil
    var chanceBtn:UIButton? = nil
    var skipBtn:UIButton? = nil
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
        self.answerBtn1 = UIButton()
        self.answerBtn1?.layer.cornerRadius = 10
        self.answerBtn1?.tag = GameAnswerButtonType.answer1.rawValue
        self.answerBtn1?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.answerBtn1?.setTitleShadowColor(UIColor.lightGrayColor(), forState: .Normal)
        self.answerBtn1?.backgroundColor = UIColor.whiteColor()
        self.answerBtn1?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.AnswerButtonClick(button as! UIButton)
        })
        self.addSubview(self.answerBtn1!)
        
        self.answerBtn2 = UIButton()
        self.answerBtn2?.layer.cornerRadius = 10
        self.answerBtn2?.tag = GameAnswerButtonType.answer2.rawValue
        self.answerBtn2?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.answerBtn2?.backgroundColor = UIColor.whiteColor()
        self.answerBtn2?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.AnswerButtonClick(button as! UIButton)
        })
        self.addSubview(self.answerBtn2!)
        
        self.answerBtn3 = UIButton()
        self.answerBtn3?.layer.cornerRadius = 10
        self.answerBtn3?.tag = GameAnswerButtonType.answer3.rawValue
        self.answerBtn3?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.answerBtn3?.backgroundColor = UIColor.whiteColor()
        self.answerBtn3?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.AnswerButtonClick(button as! UIButton)
        })
        self.addSubview(self.answerBtn3!)
        
        self.answerBtn4 = UIButton()
        self.answerBtn4?.layer.cornerRadius = 10
        self.answerBtn4?.tag = GameAnswerButtonType.answer4.rawValue
        self.answerBtn4?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.answerBtn4?.backgroundColor = UIColor.whiteColor()
        self.answerBtn4?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.AnswerButtonClick(button as! UIButton)
        })
        self.addSubview(self.answerBtn4!)
        
        self.bombBtn = UIButton()
        self.bombBtn?.tag = GameAnswerButtonType.bomb.rawValue
        self.bombBtn?.hidden = false
        self.bombBtn?.setBackgroundImage(UIImage(named: "bomb"), forState: .Normal)
        self.bombBtn?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.AnswerButtonClick(button as! UIButton)
        })
        self.addSubview(self.bombBtn!)
        
        self.chanceBtn = UIButton()
        self.chanceBtn?.tag = GameAnswerButtonType.chance.rawValue
        self.chanceBtn?.hidden = false
        self.chanceBtn?.setBackgroundImage(UIImage(named: "chance"), forState: .Normal)
        self.chanceBtn?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.AnswerButtonClick(button as! UIButton)
        })
        self.addSubview(self.chanceBtn!)
        
        self.skipBtn = UIButton()
        self.skipBtn?.tag = GameAnswerButtonType.skip.rawValue
        self.skipBtn?.hidden = false
        self.skipBtn?.setBackgroundImage(UIImage(named: "skip"), forState: .Normal)
        self.skipBtn?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.AnswerButtonClick(button as! UIButton)
        })
        self.addSubview(self.skipBtn!)
        
        self.answerBtn1?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
//        self.answerBtn1?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.answerBtn1?.autoPinEdgeToSuperviewEdge(.Left, withInset: 40)
        self.answerBtn1?.autoPinEdgeToSuperviewEdge(.Right, withInset: 40)
        self.answerBtn1?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.answerBtn2!, withOffset: -10)
        self.answerBtn2?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.answerBtn3!, withOffset: -10)
        self.answerBtn3?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.answerBtn4!, withOffset: -10)
        self.answerBtn4?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 90)
        
        self.answerButtonArray = [self.answerBtn1!,self.answerBtn2!,self.answerBtn3!,self.answerBtn4!]
//        let buttonArray = self.answerButtonArray as! NSArray
        let buttonArray = NSArray(array: self.answerButtonArray!)
        buttonArray.autoMatchViewsDimension(.Height)
        buttonArray.autoAlignViewsToEdge(.Trailing)
        buttonArray.autoAlignViewsToEdge(.Leading)
        
        self.bombBtn?.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        self.bombBtn?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        self.bombBtn?.autoSetDimensionsToSize(CGSize(width: 40,height: 40))
        
        self.chanceBtn?.autoSetDimensionsToSize(CGSize(width: 40,height: 40))
        self.chanceBtn?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.chanceBtn?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        
        self.skipBtn?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        self.skipBtn?.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
        self.skipBtn?.autoSetDimensionsToSize(CGSize(width: 40,height: 40))
    }
    
    func AnswerButtonClick(sender:UIButton){
        print("---------------------\(sender.tag)")
        self.callBack!(sender)
    }
}
