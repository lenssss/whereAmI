//
//  PersonalFollowView.swift
//  Whereami
//
//  Created by A on 16/4/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout

class PersonalFollowView: UIView {
    var followingLabel:UILabel? = nil
    var followerLabel:UILabel? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUI(){
        self.followingLabel = UILabel()
        self.followingLabel?.backgroundColor = UIColor.clearColor()
        self.followingLabel?.textColor = UIColor.whiteColor()
        self.followingLabel?.text = "40"
        self.followingLabel?.textAlignment = .Center
        self.followingLabel?.font = UIFont.boldSystemFontOfSize(20.0)
        self.addSubview(self.followingLabel!)
        
        self.followerLabel = UILabel()
        self.followerLabel?.backgroundColor = UIColor.clearColor()
        self.followerLabel?.textColor = UIColor.whiteColor()
        self.followerLabel?.text = "80"
        self.followerLabel?.textAlignment = .Center
        self.followerLabel?.font = UIFont.boldSystemFontOfSize(20.0)
        self.addSubview(self.followerLabel!)
        
        let following = UILabel()
        following.backgroundColor = UIColor.clearColor()
        following.textColor = UIColor.whiteColor()
        following.text = NSLocalizedString("following",tableName:"Localizable", comment: "")
        following.textAlignment = .Center
        following.font = UIFont.systemFontOfSize(17.0)
        self.addSubview(following)
        
        let follower = UILabel()
        follower.backgroundColor = UIColor.clearColor()
        follower.textColor = UIColor.whiteColor()
        follower.text = NSLocalizedString("followers",tableName:"Localizable", comment: "")
        follower.textAlignment = .Center
        follower.font = UIFont.systemFontOfSize(17.0)
        self.addSubview(follower)
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(line)
        
        line.autoAlignAxisToSuperviewAxis(.Vertical)
        line.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
        line.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)
        line.autoSetDimension(.Width, toSize: 2)
        
        self.followingLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        self.followingLabel?.autoPinEdge(.Bottom, toEdge: .Top, ofView: following)
        self.followingLabel?.autoPinEdge(.Right, toEdge: .Left, ofView: line)
        self.followingLabel?.autoSetDimension(.Width, toSize: 100)
        self.followingLabel?.autoMatchDimension(.Height, toDimension: .Height, ofView: following)
        
        following.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        following.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.followingLabel!)
        following.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.followingLabel!)
        
        self.followerLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        self.followerLabel?.autoPinEdge(.Bottom, toEdge: .Top, ofView: follower)
        self.followerLabel?.autoPinEdge(.Left, toEdge: .Right, ofView: line)
        self.followerLabel?.autoSetDimension(.Width, toSize: 100)
        self.followerLabel?.autoMatchDimension(.Height, toDimension: .Height, ofView: follower)
        
        follower.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        follower.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.followerLabel!)
        follower.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.followerLabel!)
    }

}
