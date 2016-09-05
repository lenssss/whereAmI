//
//  GameEndGameTableViewCell.swift
//  filterView
//
//  Created by A on 16/4/8.
//  Copyright © 2016年 lens. All rights reserved.
//

import UIKit

class GameEndGameTableViewCell: UITableViewCell {
    
    var avatar:UIImageView? = nil
    var chatName:UILabel? = nil
    var point:UILabel? = nil
    var time:UILabel? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI() {
        self.avatar = UIImageView()
        self.avatar?.layer.masksToBounds = true
        self.avatar?.layer.cornerRadius = 20
        
        self.chatName = UILabel()
        self.chatName?.textAlignment = .Left
        self.chatName?.textColor = UIColor.blackColor()
        self.chatName?.font = UIFont.systemFontOfSize(15.0)
        
        self.point = UILabel()
        self.point?.textAlignment = .Center
        self.point?.textColor = UIColor.blackColor()
        self.point?.font = UIFont.systemFontOfSize(12.0)
        
        self.time = UILabel()
        self.time?.textColor = UIColor.blackColor()
        self.time?.textAlignment = .Center
        self.time?.font = UIFont.systemFontOfSize(12.0)
        
        self.contentView.addSubview(self.avatar!)
        self.contentView.addSubview(self.chatName!)
        self.contentView.addSubview(self.point!)
        self.contentView.addSubview(self.time!)
        
        self.avatar?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.avatar?.autoSetDimensionsToSize(CGSize(width: 40,height: 40))
        self.avatar?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16.0)
        
        self.chatName?.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar!, withOffset: 3)
        self.chatName?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 10)
        self.chatName?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!, withOffset: -5)
        
        self.point?.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar!, withOffset: 3)
        self.point?.autoSetDimension(.Width, toSize: 40)
        self.point?.autoPinEdge(.Right, toEdge: .Left, ofView: self.time!)
        self.point?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!, withOffset: -5)
        
        self.time?.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar!, withOffset: 3)
        self.time?.autoSetDimension(.Width, toSize: 80)
        self.time?.autoPinEdgeToSuperviewEdge(.Right)
        self.time?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!, withOffset: -5)
        
        let lineView = UIView();
        self.contentView.addSubview(lineView)
        lineView.backgroundColor = UIColor.lightGrayColor()
        lineView.autoSetDimension(.Height, toSize: 0.7);
        lineView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        lineView.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        lineView.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

