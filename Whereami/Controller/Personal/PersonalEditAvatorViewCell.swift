//
//  PersonalEditAvatorViewCell.swift
//  Whereami
//
//  Created by A on 16/5/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalEditAvatorViewCell: UITableViewCell {
    
    var avatorLabel:UILabel? = nil
    var avator:UIImageView? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.avator = UIImageView()
        self.avator?.layer.masksToBounds = true
        self.avator?.layer.cornerRadius = 30
        self.contentView.addSubview(avator!)
        
        self.avatorLabel = UILabel()
        self.avatorLabel?.textAlignment = .Left
        self.avatorLabel?.text = "Photo"
        self.avatorLabel?.textColor = UIColor.blackColor()
        self.contentView.addSubview(avatorLabel!)
        
        self.avatorLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
        self.avatorLabel?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.avatorLabel?.autoSetDimensionsToSize(CGSize(width: 200,height: 60))

        self.avator?.autoPinEdgeToSuperviewEdge(.Right,withInset: 16)
        self.avator?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.avator?.autoSetDimensionsToSize(CGSize(width: 60,height: 60))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
