//
//  File.swift
//  Whereami
//
//  Created by 陈鹏宇 on 16/7/14.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout

typealias ButtonCallback = (UIButton) -> Void

class ContactItemTableViewCell: UITableViewCell {
    
    var avatar:UIImageView? = nil
    var chatName:UILabel? = nil
    var location:UILabel? = nil
    var addButton:UIButton? = nil
    var callBack:ButtonCallback? = nil
    
    private let idColor: UIColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    private let msgColor: UIColor = UIColor(red: 134/255.0, green: 134/255.0, blue: 134/255.0, alpha: 1.0)
    private let lineColor: UIColor = UIColor(red: 219/255.0, green: 219/255.0, blue: 219/255.0, alpha: 1.0)
    
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
        self.avatar?.layer.cornerRadius = 22.5
        
        self.chatName = UILabel()
        self.chatName?.textColor = idColor
        self.chatName?.font = UIFont.customFontWithStyle("Medium", size: 17.0)
        
        self.location = UILabel()
        self.location?.textColor = msgColor
        self.location?.font = UIFont.customFontWithStyle("Regular", size: 15.0)
        
//        let locationLogo = UIImageView()
//        locationLogo.image = UIImage(named: "location")
        
        self.addButton = UIButton()
        self.addButton?.layer.masksToBounds = true
        self.addButton?.layer.cornerRadius = 10
        self.addButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.addButton?.backgroundColor = UIColor.whiteColor()
        self.addButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.callBack!(button as! UIButton)
        })
        
        self.contentView.addSubview(self.avatar!)
        self.contentView.addSubview(self.chatName!)
        self.contentView.addSubview(self.location!)
//        self.contentView.addSubview(locationLogo)
        self.contentView.addSubview(self.addButton!)
        
        self.avatar?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.avatar?.autoSetDimensionsToSize(CGSize(width: 45,height: 45))
        self.avatar?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16.0)
        
        self.chatName?.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar!, withOffset: 0)
        self.chatName?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 13)
        self.chatName?.autoSetDimension(.Height, toSize: 22.5)
        self.chatName?.autoPinEdge(.Bottom, toEdge: .Top, ofView: location!,withOffset: 0)
        
        self.location?.autoPinEdge(.Left, toEdge: .Right, ofView: avatar!, withOffset: 13)
        self.location?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: avatar!)
        self.location?.autoSetDimension(.Height, toSize: 22.5)
        self.location?.autoSetDimension(.Width, toSize: 200)
        
        self.addButton?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.addButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        self.addButton?.autoSetDimensionsToSize(CGSize(width: 60,height: 30))
        
        let lineView = UIView();
        self.contentView.addSubview(lineView)
        lineView.backgroundColor = lineColor
        lineView.autoSetDimension(.Height, toSize: 0.5);
        lineView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        lineView.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
        lineView.autoPinEdgeToSuperviewEdge(.Right, withInset: 16)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

