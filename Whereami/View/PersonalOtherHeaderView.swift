//
//  PersonalOtherHeaderView.swift
//  Whereami
//
//  Created by A on 16/5/20.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalOtherHeaderView: PersonalHeaderView {
    typealias theCallback = () -> Void

    var playButton:UIButton? = nil
    var chatButton:UIButton? = nil

    var playBlock:theCallback? = nil
    var chatBlock:theCallback? = nil
    
    override init(frame:CGRect, theTitle title:String, theSubTitle subTitle:String){
        super.init(frame: frame, theTitle: title, theSubTitle: subTitle)
        
//        let height = frame.height

        self.editButton?.removeFromSuperview()
        
        self.playButton = UIButton(type: .System)
//        self.playButton?.setTitle(NSLocalizedString("playNow",tableName:"Localizable", comment: ""), forState: .Normal)
//        self.playButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.playButton?.setAttributedTitle(NSAttributedString(string: NSLocalizedString("playNow",tableName:"Localizable", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor(),NSFontAttributeName:UIFont.systemFontOfSize(17.0)]), forState: .Normal)
        self.playButton?.backgroundColor = UIColor.whiteColor()
        self.playButton?.layer.masksToBounds = true
        self.playButton?.layer.cornerRadius = 10
        self.playButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.playBlock!()
        })
        self.addSubview(self.playButton!)
        
        self.chatButton = UIButton(type: .System)
//        self.chatButton?.setTitle(NSLocalizedString("message",tableName:"Localizable", comment: ""), forState: .Normal)
//        self.chatButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.chatButton?.setAttributedTitle(NSAttributedString(string: NSLocalizedString("message",tableName:"Localizable", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor(),NSFontAttributeName:UIFont.systemFontOfSize(17.0)]), forState: .Normal)
        self.chatButton?.backgroundColor = UIColor.whiteColor()
        self.chatButton?.layer.masksToBounds = true
        self.chatButton?.layer.cornerRadius = 10
        self.chatButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.chatBlock!()
        })
        self.addSubview(self.chatButton!)

        self.playButton?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.following!,withOffset: 15)
        self.playButton?.autoAlignAxis(.Vertical, toSameAxisOfView: self, withOffset: -55)
//        self.playButton?.autoSetDimensionsToSize(CGSize(width: 100,height: 0.13*height))
        self.playButton?.autoSetDimensionsToSize(CGSize(width: 100,height: 40))
        
        
        self.chatButton?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.following!,withOffset: 15)
        self.chatButton?.autoAlignAxis(.Vertical, toSameAxisOfView: self, withOffset: 55)
//        self.chatButton?.autoSetDimensionsToSize(CGSize(width: 100,height: 0.13*height))
        self.chatButton?.autoSetDimensionsToSize(CGSize(width: 100,height: 40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
