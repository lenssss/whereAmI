//
//  PublishEditGameViewController.swift
//  Whereami
//
//  Created by A on 16/5/19.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PublishEditGameViewCell: UITableViewCell {
    
    var itemNameLabel:UILabel? = nil
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
        self.backgroundColor = UIColor(red: 90/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        
        self.itemNameLabel = UILabel()
        self.itemNameLabel?.textColor = UIColor.whiteColor()
        self.contentView.addSubview(self.itemNameLabel!)
        
        self.selectImageView = UIImageView()
        self.selectImageView?.image = UIImage(named: "pub_select")
        self.contentView.addSubview(self.selectImageView!)
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line)
        
        self.itemNameLabel?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.itemNameLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
//        self.itemNameLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
//        self.itemNameLabel?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)
        self.itemNameLabel?.autoSetDimensionsToSize(CGSize(width: 100,height: 30))
        
        self.selectImageView?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.selectImageView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 16)
        self.selectImageView?.autoSetDimensionsToSize(CGSize(width: 30,height: 30))
        
        line.autoPinEdgeToSuperviewEdge(.Bottom)
        line.autoPinEdgeToSuperviewEdge(.Left, withInset: 16.0)
        line.autoPinEdgeToSuperviewEdge(.Right, withInset: 16.0)
        line.autoSetDimension(.Height, toSize: 0.5)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
