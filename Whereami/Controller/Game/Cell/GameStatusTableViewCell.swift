//
//  GameStatusTableViewCell.swift
//  Whereami
//
//  Created by WuQifei on 16/2/19.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout

class GameStatusTableViewCell: HHPanningTableViewCell {

    var avatar:UIImageView? = nil
    var levelBadge:UILabel? = nil
    var username:UILabel? = nil
    var missionDescription:UILabel? = nil
    var timeDescription:UILabel? = nil
    var score:UILabel? = nil
    
    override init!(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        self.contentView.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None
        
        self.avatar = UIImageView()
    
        self.levelBadge = UILabel()
        self.levelBadge?.font = UIFont.systemFontOfSize(9.0)
        self.levelBadge?.backgroundColor = UIColor.redColor()
        self.levelBadge?.textColor = UIColor.whiteColor()
        self.levelBadge?.textAlignment =  .Center
        
        self.username = UILabel()
        self.username?.font = UIFont.systemFontOfSize(14.0)
        self.username?.textColor = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
        
        self.missionDescription = UILabel()
        self.missionDescription?.font = UIFont.systemFontOfSize(12.0)
        self.missionDescription?.textColor = UIColor(red: 119/255.0, green: 119/255.0, blue: 119/255.0, alpha: 1.0)
        
        self.timeDescription = UILabel()
        self.timeDescription?.font = UIFont.systemFontOfSize(12.0)
        self.timeDescription?.textColor = UIColor(red: 119/255.0, green: 119/255.0, blue: 119/255.0, alpha: 1.0)
        
        self.score = UILabel()
        self.score?.font = UIFont.systemFontOfSize(14.0)
        self.score?.textColor =  UIColor(red: 119/255.0, green: 119/255.0, blue: 119/255.0, alpha: 1.0)
        self.score?.textAlignment = .Center
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGrayColor()
        
        self.contentView.addSubview(self.avatar!)
        self.contentView.addSubview(self.levelBadge!)
        self.contentView.addSubview(self.username!)
        self.contentView.addSubview(self.missionDescription!)
        self.contentView.addSubview(self.timeDescription!)
        self.contentView.addSubview(self.score!)
        self.contentView.addSubview(line)
        
        self.avatar!.layer.masksToBounds = true;
        self.avatar!.layer.cornerRadius = 50.0/2.0
        
        self.levelBadge!.layer.masksToBounds = true;
        self.levelBadge!.layer.cornerRadius = 20.0/2.0;
        self.levelBadge!.layer.borderColor = UIColor.whiteColor().CGColor
        self.levelBadge!.layer.borderWidth = 1;
        
        self.avatar?.autoSetDimensionsToSize(CGSize(width: 50, height: 50))
        self.avatar?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.avatar?.autoPinEdgeToSuperviewEdge(.Left,withInset:13)
        
        self.levelBadge?.autoPinEdge(.Right, toEdge: .Right, ofView: self.avatar!)
        self.levelBadge?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!)
        self.levelBadge!.autoSetDimensionsToSize(CGSize(width: 20, height: 20))
        
        self.missionDescription?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.missionDescription?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 13)
        
        self.username?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.missionDescription!, withOffset: -4)
        self.username?.autoPinEdge(.Left, toEdge: .Left, ofView: self.missionDescription!, withOffset: 0)
        
        self.timeDescription?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.missionDescription!, withOffset: 2)
        self.timeDescription?.autoPinEdge(.Left, toEdge: .Left, ofView: self.missionDescription!, withOffset: 0)
        
        self.score?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.score?.autoPinEdgeToSuperviewEdge(.Right, withInset: 13)
        
        line.autoPinEdgeToSuperviewEdge(.Bottom)
        line.autoPinEdgeToSuperviewEdge(.Left, withInset: 16.0)
        line.autoPinEdgeToSuperviewEdge(.Right, withInset: 16.0)
        line.autoSetDimension(.Height, toSize: 0.5)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
