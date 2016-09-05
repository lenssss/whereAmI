//
//  PersonalMainViewCell.swift
//  Whereami
//
//  Created by A on 16/5/17.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalMainViewCell: UITableViewCell {
    
    var logoView:UIImageView? = nil
    var itemNameLabel:UILabel? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.logoView = UIImageView()
        self.contentView.addSubview(logoView!)
        
        self.itemNameLabel = UILabel()
        self.itemNameLabel?.textAlignment = .Left
        self.contentView.addSubview(itemNameLabel!)
        
        self.logoView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        self.logoView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
        self.logoView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        self.logoView?.autoSetDimensionsToSize(CGSize(width: 30,height: 30))
        
        self.itemNameLabel?.autoPinEdge(.Left, toEdge: .Right, ofView: self.logoView!, withOffset: 5)
        self.itemNameLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        self.itemNameLabel?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        self.itemNameLabel?.autoSetDimensionsToSize(CGSize(width: 200,height: 30))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
