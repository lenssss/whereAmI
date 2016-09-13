//
//  PersonalHeaderView.swift
//  Whereami
//
//  Created by A on 16/4/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalHeaderView: UIView {
    typealias ActionBlock = () -> Void
    
    var scrollView:UIScrollView? = nil
    var backImageView:UIImageView? = nil
    var headerImageView:UIImageView? = nil
    var titleLabel:UILabel? = nil
    var subTitleLabel:UILabel? = nil
    var prePoint:CGPoint? = nil
    var dataButton:UIButton? = nil
    var editButton:UIButton? = nil
    var followingLabel:UILabel? = nil
    var followerLabel:UILabel? = nil
    var following:UILabel? = nil
    var follower:UILabel? = nil
    var followerBtn:UIButton? = nil
    var followingBtn:UIButton? = nil
    
    var headerimgActionBlock:ActionBlock? = nil
    var backimgActionBlocck:ActionBlock? = nil
    var correctDataBlock:ActionBlock? = nil
    var getFriendsBlock:ActionBlock? = nil
    var getFansBlock:ActionBlock? = nil
    var editBlock:ActionBlock? = nil

    init(frame:CGRect,theTitle title:String,theSubTitle subTitle:String){
        super.init(frame:frame)
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor.clearColor()
        
//        let height = frame.height
        
        self.backImageView = UIImageView()
        self.backImageView?.contentMode = .ScaleAspectFill
        self.backImageView?.layer.masksToBounds = true
        self.backImageView?.image = UIImage(named: "personal_back")
        self.backImageView?.userInteractionEnabled = true
        let tapBack = UITapGestureRecognizer(target: self, action: #selector(self.backTapAction(_:)))
        tapBack.numberOfTapsRequired = 1
        self.backImageView?.addGestureRecognizer(tapBack)
        self.addSubview(self.backImageView!)
        
        let overrideView = UIView()
        overrideView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        self.addSubview(overrideView)
        
        self.headerImageView = UIImageView()
        self.headerImageView?.image = UIImage(named: "avator.png")
        self.headerImageView?.layer.borderWidth = 3.0
        self.headerImageView?.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.8).CGColor
        self.headerImageView?.layer.masksToBounds = true
        self.headerImageView?.layer.cornerRadius = 40
//        self.headerImageView?.layer.cornerRadius = 0.15*height
        self.headerImageView?.userInteractionEnabled = true
        let tapHead = UITapGestureRecognizer(target: self, action: #selector(self.headTapAction(_:)))
        self.headerImageView?.addGestureRecognizer(tapHead)
        self.addSubview(self.headerImageView!)
        
        self.titleLabel = UILabel()
        self.titleLabel?.textAlignment = .Center
        self.titleLabel?.font = UIFont.customFontWithStyle("Bold", size: 19.0)
        self.titleLabel?.text = title
        self.titleLabel?.textColor = UIColor.whiteColor()
        self.addSubview(self.titleLabel!)
        
        self.subTitleLabel = UILabel()
        self.subTitleLabel?.textAlignment = .Center
        self.subTitleLabel?.font = UIFont.systemFontOfSize(13.0)
        self.subTitleLabel?.text = subTitle
        self.subTitleLabel?.textColor = UIColor.whiteColor()
        self.addSubview(self.subTitleLabel!)
        
        self.editButton = UIButton(type: .System)
//        self.editButton?.setTitle(NSLocalizedString("edit",tableName:"Localizable", comment: ""), forState: .Normal)
//        self.editButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.editButton?.setAttributedTitle(NSAttributedString(string: NSLocalizedString("edit",tableName:"Localizable", comment: ""), attributes: [NSForegroundColorAttributeName:UIColor.grayColor(),NSFontAttributeName:UIFont.systemFontOfSize(17.0)]), forState: .Normal)
        self.editButton?.backgroundColor = UIColor.whiteColor()
        self.editButton?.layer.masksToBounds = true
        self.editButton?.layer.cornerRadius = 10
        self.editButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.editBlock!()
        })
        self.addSubview(self.editButton!)
        
//        let tapFollowing = UITapGestureRecognizer(target: self, action: #selector(self.tapFollowingAction(_:)))
//        let tapFollower = UITapGestureRecognizer(target: self, action: #selector(self.tapFollowerAction(_:)))
        
        self.followingLabel = UILabel()
        self.followingLabel?.text = "0"
//        self.followingLabel!.userInteractionEnabled = true
        self.followingLabel?.backgroundColor = UIColor.clearColor()
        self.followingLabel?.textColor = UIColor.whiteColor()
        self.followingLabel?.textAlignment = .Center
        self.followingLabel?.font = UIFont.systemFontOfSize(22.0)
//        self.followingLabel?.addGestureRecognizer(tapFollowing)
        self.addSubview(self.followingLabel!)
        
        self.followerLabel = UILabel()
        self.followerLabel?.text = "0"
//        self.followerLabel!.userInteractionEnabled = true
        self.followerLabel?.backgroundColor = UIColor.clearColor()
        self.followerLabel?.textColor = UIColor.whiteColor()
        self.followerLabel?.textAlignment = .Center
        self.followerLabel?.font = UIFont.systemFontOfSize(22.0)
//        self.followerLabel?.addGestureRecognizer(tapFollower)
        self.addSubview(self.followerLabel!)
        
        self.following = UILabel()
        following?.backgroundColor = UIColor.clearColor()
        following?.textColor = UIColor.whiteColor()
        following?.text = NSLocalizedString("following",tableName:"Localizable", comment: "")
        following?.textAlignment = .Center
        following?.font = UIFont.systemFontOfSize(12.0)
//        following?.addGestureRecognizer(tapFollowing)
        self.addSubview(following!)
        
        self.follower = UILabel()
        follower?.backgroundColor = UIColor.clearColor()
        follower?.textColor = UIColor.whiteColor()
        follower?.text = NSLocalizedString("followers",tableName:"Localizable", comment: "")
        follower?.textAlignment = .Center
        follower?.font = UIFont.systemFontOfSize(12.0)
//        follower?.addGestureRecognizer(tapFollower)
        self.addSubview(follower!)
        
        let line = UIView()
        line.backgroundColor = UIColor.whiteColor()
        self.addSubview(line)
        
        followerBtn = UIButton()
        followerBtn!.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            self.tapFollowerAction(button)
        }
        self.addSubview(followerBtn!)
        
        followingBtn = UIButton()
        followingBtn!.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            self.tapFollowingAction(button)
        }
        self.addSubview(followingBtn!)
        
        self.backImageView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        
        overrideView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        
        self.headerImageView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 64)
        self.headerImageView?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.headerImageView?.autoSetDimensionsToSize(CGSize(width: 80,height: 80))
//        self.headerImageView?.autoSetDimensionsToSize(CGSize(width: 0.3*height,height: 0.3*height))
        
        self.titleLabel?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.headerImageView!, withOffset: 9)
        self.titleLabel?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.titleLabel?.autoSetDimensionsToSize(CGSize(width: 300,height: 22.0))
//        self.titleLabel?.autoSetDimensionsToSize(CGSize(width: 300,height: 0.1*height))
        
        self.subTitleLabel?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.titleLabel!,withOffset: 2)
        self.subTitleLabel?.autoAlignAxisToSuperviewAxis(.Vertical)
//        self.subTitleLabel?.autoMatchDimension(.Height, toDimension: .Height, ofView: self, withMultiplier: 0.1)
//        self.subTitleLabel?.autoSetDimensionsToSize(CGSize(width: 300,height: 0.1*height))
        self.subTitleLabel?.autoSetDimensionsToSize(CGSize(width: 300,height: 16.0))
//        self.subTitleLabel?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.followingLabel!, withOffset: -0.2*height)
        self.subTitleLabel?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.followingLabel!, withOffset: -13.0)
        
        self.followingLabel?.autoPinEdge(.Bottom, toEdge: .Top, ofView: following!)
        self.followingLabel?.autoPinEdge(.Right, toEdge: .Left, ofView: line)
//        self.followingLabel?.autoSetDimensionsToSize(CGSize(width: 100,height: 0.1*height))
        self.followingLabel?.autoSetDimensionsToSize(CGSize(width: 100, height: 17))
        
        following?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.followingLabel!)
        following?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.followingLabel!)
//        following?.autoSetDimensionsToSize(CGSize(width: 100,height: 0.08*height))
        following?.autoSetDimensionsToSize(CGSize(width: 100, height: 13))
        
        line.autoAlignAxisToSuperviewAxis(.Vertical)
        line.autoPinEdge(.Top, toEdge: .Top, ofView: self.followingLabel!, withOffset: 2)
        line.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: following!, withOffset: -2)
        line.autoSetDimension(.Width, toSize: 2)
        
        self.followerLabel?.autoPinEdge(.Top, toEdge: .Top, ofView: self.followingLabel!)
        self.followerLabel?.autoPinEdge(.Bottom, toEdge: .Top, ofView: follower!)
        self.followerLabel?.autoPinEdge(.Left, toEdge: .Right, ofView: line)
//        self.followerLabel?.autoSetDimensionsToSize(CGSize(width: 100,height: 0.1*height))
        self.followerLabel?.autoSetDimensionsToSize(CGSize(width: 100, height: 17))
        
        follower?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.followerLabel!)
        follower?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.followerLabel!)
//        follower?.autoSetDimensionsToSize(CGSize(width: 100,height: 0.08*height))
        follower?.autoSetDimensionsToSize(CGSize(width: 100, height: 13))
        
        self.editButton?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.following!,withOffset: 15)
        self.editButton?.autoAlignAxisToSuperviewAxis(.Vertical)
//        self.editButton?.autoSetDimensionsToSize(CGSize(width: 100,height: 0.13*height))
        self.editButton?.autoSetDimensionsToSize(CGSize(width: 130,height: 42))
        
        followerBtn!.autoPinEdge(.Top, toEdge: .Top, ofView: followerLabel!)
        followerBtn!.autoPinEdge(.Left, toEdge: .Left, ofView: followerLabel!)
        followerBtn!.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: follower!)
        followerBtn!.autoPinEdge(.Right, toEdge: .Right, ofView: follower!)
        
        followingBtn!.autoPinEdge(.Top, toEdge: .Top, ofView: followingLabel!)
        followingBtn!.autoPinEdge(.Left, toEdge: .Left, ofView: followingLabel!)
        followingBtn!.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: following!)
        followingBtn!.autoPinEdge(.Right, toEdge: .Right, ofView: following!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func backTapAction(sender:AnyObject){
        self.backimgActionBlocck!()
    }
    
    func tapFollowingAction(sender:AnyObject){
        self.getFriendsBlock!()
    }
    
    func tapFollowerAction(sender:AnyObject){
        self.getFansBlock!()
    }
    
    func headTapAction(sender:AnyObject){
//        self.headerimgActionBlock!()
    }
}
