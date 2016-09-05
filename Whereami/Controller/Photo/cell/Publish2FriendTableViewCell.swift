//
//  Publish2FriendTableViewCell.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/21.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class Publish2FriendTableViewCell: UITableViewCell {
    
    var avatar:UIImageView? = nil
    var chatName:UILabel? = nil
    var location:UILabel? = nil
    var selectImageView:UIImageView? = nil
    
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
        self.avatar?.layer.cornerRadius = 25
        
        self.chatName = UILabel()
        self.chatName?.textColor = UIColor.blackColor()
        self.chatName?.font = UIFont.systemFontOfSize(16.0)
        
        self.location = UILabel()
        self.location?.textColor = UIColor(red: 121.0/255.0, green: 121.0/255.0, blue: 123.0/255.0, alpha: 1.0)
        self.location?.font = UIFont.systemFontOfSize(14.0)
        
        let locationLogo = UIImageView()
        locationLogo.image = UIImage(named: "location")
        
        self.selectImageView = UIImageView()
        self.selectImageView?.image = UIImage(named: "pub_select")
        self.contentView.addSubview(self.selectImageView!)
        
        self.contentView.addSubview(self.avatar!)
        self.contentView.addSubview(self.chatName!)
        self.contentView.addSubview(self.location!)
        self.contentView.addSubview(locationLogo)
        self.contentView.addSubview(self.selectImageView!)
        
        self.avatar?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.avatar?.autoSetDimensionsToSize(CGSize(width: 50,height: 50))
        self.avatar?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16.0)
        
        self.chatName?.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar!, withOffset: 2)
        self.chatName?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 10)
        self.chatName?.autoSetDimension(.Height, toSize: 20)
        self.chatName?.autoPinEdge(.Bottom, toEdge: .Top, ofView: locationLogo,withOffset: -8)
        
        locationLogo.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 10)
        locationLogo.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!, withOffset: -5)
        locationLogo.autoSetDimensionsToSize(CGSize(width: 15,height: 15))
        
        self.location?.autoPinEdge(.Left, toEdge: .Right, ofView: locationLogo, withOffset: 0)
        self.location?.autoPinEdge(.Top, toEdge: .Top, ofView: locationLogo)
        self.location?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: locationLogo)
        
        self.selectImageView?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.selectImageView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 16)
        self.selectImageView?.autoSetDimensionsToSize(CGSize(width: 30,height: 30))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
