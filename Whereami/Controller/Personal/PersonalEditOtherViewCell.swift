//
//  PersonalEditOtherViewCell.swift
//  Whereami
//
//  Created by A on 16/5/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalEditOtherViewCell: UITableViewCell {
    
    var itemLabel:UILabel? = nil
    var tipLabel:UILabel? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.itemLabel = UILabel()
        self.itemLabel?.textAlignment = .Left
        self.itemLabel?.textColor = UIColor.blackColor()
        self.contentView.addSubview(itemLabel!)
        
        self.tipLabel = UILabel()
        self.tipLabel?.textAlignment = .Right
        self.tipLabel?.textColor = UIColor.blackColor()
        self.contentView.addSubview(tipLabel!)
        
        self.itemLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
        self.itemLabel?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.itemLabel?.autoSetDimensionsToSize(CGSize(width: 200,height: 50))
        
        self.tipLabel?.autoPinEdgeToSuperviewEdge(.Right,withInset: 16)
        self.tipLabel?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.tipLabel?.autoSetDimensionsToSize(CGSize(width: 200,height: 50))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
