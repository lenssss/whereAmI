//
//  ChatItemTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/6.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class ChatItemTableViewCell: UITableViewCell {
    var avatar:UIImageView? = nil
    var chatName:UILabel? = nil
    var lastMsg:UILabel? = nil
    var lastMsgTime:UILabel? = nil
    var msgSum:UILabel? = nil
    
    private let idColor: UIColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    private let msgColor: UIColor = UIColor(red: 134/255.0, green: 134/255.0, blue: 134/255.0, alpha: 1.0)
    private let timeColor: UIColor = UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1.0)
    private let unreadBgColor: UIColor = UIColor(red: 255/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1.0)
    private let unreadTextColor: UIColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    private let lineColor: UIColor = UIColor(red: 219/255.0, green: 219/255.0, blue: 219/255.0, alpha: 1.0)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI(){
        self.avatar = UIImageView()
        self.avatar?.layer.masksToBounds = true
        self.avatar?.layer.cornerRadius = 22.5
        
        self.chatName = UILabel()
        self.chatName?.textColor = idColor
        self.chatName?.font = UIFont.customFontWithStyle("Medium", size: 17.0)
        
        self.lastMsg = UILabel()
        self.lastMsg?.textColor = msgColor
        self.lastMsg?.font = UIFont.customFontWithStyle("Regular", size: 17.0)
        
        self.lastMsgTime = UILabel()
        self.lastMsgTime?.textAlignment = .Right
        self.lastMsgTime?.textColor = timeColor
        self.lastMsgTime?.font = UIFont.systemFontOfSize(14.0)
        
        self.msgSum = UILabel()
        self.msgSum?.backgroundColor = unreadBgColor
        self.msgSum?.textColor = unreadTextColor
        self.msgSum?.textAlignment = .Center
        self.msgSum?.font = UIFont.systemFontOfSize(9.0)
        self.msgSum?.layer.masksToBounds = true
        self.msgSum?.layer.cornerRadius = 7
        
        let line = UIView()
        line.backgroundColor = lineColor
        
        self.contentView.addSubview(self.avatar!)
        self.contentView.addSubview(self.chatName!)
        self.contentView.addSubview(self.lastMsg!)
        self.contentView.addSubview(self.lastMsgTime!)
        self.contentView.addSubview(self.msgSum!)
        self.contentView.addSubview(line)
        
        self.avatar?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.avatar?.autoSetDimensionsToSize(CGSize(width: 45,height: 45))
        self.avatar?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16.0)
        
        self.chatName?.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar!, withOffset: 0)
        self.chatName?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 13)
        self.chatName?.autoSetDimension(.Height, toSize: 22.5)
        self.chatName?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.lastMsg!,withOffset: 0)
        
        self.lastMsg?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 13)
        self.lastMsg?.autoSetDimension(.Height, toSize: 22.5)
        self.lastMsg?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!, withOffset: 0)
        
        self.lastMsgTime?.autoPinEdge(.Top, toEdge: .Top, ofView: self.chatName!)
        self.lastMsgTime?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.chatName!)
        self.lastMsgTime?.autoSetDimension(.Width, toSize: 100)
        self.lastMsgTime?.autoPinEdgeToSuperviewEdge(.Right, withInset: 16.0)
        
//        self.msgSum?.autoPinEdge(.Top, toEdge: .Top, ofView: self.lastMsg!, withOffset: 3)
        self.msgSum?.autoPinEdgeToSuperviewEdge(.Right, withInset: 16)
        self.msgSum?.autoPinEdge(.Top, toEdge: .Top, ofView: self.lastMsg!,withOffset: 4.25)
        self.msgSum?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.lastMsg!,withOffset: -4.25)
        self.msgSum?.autoSetDimensionsToSize(CGSize(width: 14,height: 14))
        
        line.autoPinEdgeToSuperviewEdge(.Bottom)
        line.autoPinEdgeToSuperviewEdge(.Left,withInset: 16)
        line.autoPinEdgeToSuperviewEdge(.Right,withInset: 16)
        line.autoSetDimension(.Height, toSize: 0.5)
    }
}
