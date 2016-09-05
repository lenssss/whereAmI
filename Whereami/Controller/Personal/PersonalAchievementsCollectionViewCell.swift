//
//  PersonalAchievementsCollectionViewCell.swift
//  Whereami
//
//  Created by A on 16/6/1.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalAchievementsCollectionViewCell: UICollectionViewCell {
    
    var itemLogo:UIImageView? = nil
    var progressLabel:UILabel? = nil
    var itemName:UILabel? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI(){
        itemLogo = UIImageView()
        itemLogo?.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(itemLogo!)
        
        /*
        progress = UIProgressView()
        progress?.progressTintColor = UIColor.greenColor()
        progress?.trackTintColor = UIColor.grayColor()
        progress?.progress = 0.5
        self.contentView.addSubview(progress!)
        */
        
        progressLabel = UILabel()
        progressLabel?.textAlignment = .Center
        progressLabel?.textColor = UIColor.grayColor()
        progressLabel?.font = UIFont.customFont(12.0)
        self.contentView.addSubview(progressLabel!)
        
        itemName = UILabel()
        itemName?.textAlignment = .Center
        itemName?.textColor = UIColor.grayColor()
        self.contentView.addSubview(itemName!)
        
        itemLogo?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        itemLogo?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        itemLogo?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        itemLogo?.autoSetDimension(.Height, toSize: 60)
        
        progressLabel?.autoPinEdge(.Top, toEdge: .Bottom, ofView: itemLogo!, withOffset: 10)
        progressLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        progressLabel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        progressLabel?.autoSetDimension(.Height, toSize: 13)
        
        itemName?.autoPinEdge(.Top, toEdge: .Bottom, ofView: progressLabel!)
        itemName?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        itemName?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        itemName?.autoPinEdgeToSuperviewEdge(.Bottom)
    }
}
