//
//  GameClassicSelectFriendTableViewCell.swift
//  Whereami
//
//  Created by A on 16/3/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class GameClassicSelectFriendTableViewCell: UITableViewCell {
    
    var avatar:UIImageView? = nil
    var chatName:UILabel? = nil
    var locationIcon:UIImageView? = UIImageView(image: UIImage(named: "location"))
    var location:UILabel? = nil
    
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
        
        self.contentView.addSubview(self.avatar!)
        self.contentView.addSubview(self.chatName!)
        self.contentView.addSubview(self.location!)
//        self.contentView.addSubview(self.locationIcon!)
        
        self.avatar?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.avatar?.autoSetDimensionsToSize(CGSize(width: 45,height: 45))
        self.avatar?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16.0)
        
        self.chatName?.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar!, withOffset: 0)
        self.chatName?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 13)
        self.chatName?.autoSetDimension(.Height, toSize: 22.5)
        self.chatName?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.location!, withOffset: 0)

//        self.locationIcon?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 10)
//        self.locationIcon?.autoSetDimensionsToSize(CGSize(width: 15,height: 15))
//        self.locationIcon?.autoPinEdge(.Top, toEdge: .Top, ofView: self.location!, withOffset: 0)
//        self.locationIcon?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.location!, withOffset: 0)
//        
        self.location?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 13)
        self.location?.autoSetDimension(.Height, toSize: 22.5)
        self.location?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!, withOffset: 0)
        
        let lineView = UIView();
        self.contentView.addSubview(lineView)
        lineView.backgroundColor = lineColor
        lineView.autoSetDimension(.Height, toSize: 0.7);
        lineView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        lineView.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
        lineView.autoPinEdgeToSuperviewEdge(.Right, withInset: 16)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
