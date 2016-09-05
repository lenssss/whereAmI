//
//  PersonalPerformanceAchievementsTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/26.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalPerformanceAchievementsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        let grayView = UIView()
        grayView.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
        self.contentView.addSubview(grayView)
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line1)
        
        let line2 = UIView()
        line2.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line2)
        
        let line3 = UIView()
        line3.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line3)

        let achievementsLabel = UILabel()
        achievementsLabel.text = NSLocalizedString("achievements",tableName:"Localizable", comment: "")
        achievementsLabel.textAlignment = .Left
        achievementsLabel.textColor = UIColor.blackColor()
        self.contentView.addSubview(achievementsLabel)
        
        grayView.autoPinEdgeToSuperviewEdge(.Top)
        grayView.autoPinEdgeToSuperviewEdge(.Left)
        grayView.autoPinEdgeToSuperviewEdge(.Right)
        grayView.autoSetDimension(.Height, toSize: 20)
        
        line1.autoPinEdge(.Top, toEdge: .Bottom, ofView: grayView)
        line1.autoPinEdgeToSuperviewEdge(.Left)
        line1.autoPinEdgeToSuperviewEdge(.Right)
        line1.autoSetDimension(.Height, toSize: 1)
        
        achievementsLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: line1)
        achievementsLabel.autoPinEdgeToSuperviewEdge(.Left)
        achievementsLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: line2)
        achievementsLabel.autoSetDimensionsToSize(CGSize(width: 200,height: 50))
        
        line2.autoPinEdgeToSuperviewEdge(.Left)
        line2.autoPinEdgeToSuperviewEdge(.Right)
        line2.autoSetDimension(.Height, toSize: 1)
        
        line3.autoPinEdgeToSuperviewEdge(.Left)
        line3.autoPinEdgeToSuperviewEdge(.Right)
        line3.autoPinEdgeToSuperviewEdge(.Bottom)
        line3.autoSetDimension(.Height, toSize: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
