//
//  PersonalPerformanceLevelTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/26.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalPerformanceLevelTableViewCell: UITableViewCell {
    var levelLabel:UILabel? = nil
    var pointLabel:UILabel? = nil
    var nextPointLabel:UILabel? = nil
    var totalLabel:UILabel? = nil
    var winedView:UIView? = nil
    var failedView:UIView? = nil

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
        
        self.levelLabel = UILabel()
        self.levelLabel!.textAlignment = .Left
        self.levelLabel!.textColor = UIColor.blackColor()
        self.contentView.addSubview(self.levelLabel!)
        
        self.failedView = UIView()
        failedView!.layer.cornerRadius = 5.0
        failedView!.backgroundColor = UIColor(red: 253/255.0, green: 121/255.0, blue: 126/255.0, alpha: 1)
        self.contentView.addSubview(failedView!)
        
        self.winedView = UIView()
        winedView!.layer.cornerRadius = 5.0
        winedView!.backgroundColor = UIColor(red: 137/255.0, green: 223/255.0, blue: 126/255.0, alpha: 1)
        failedView!.addSubview(winedView!)
        
        self.pointLabel = UILabel()
        self.pointLabel!.textAlignment = .Left
        self.pointLabel!.layer.cornerRadius = 5.0
        self.pointLabel!.textColor = UIColor.whiteColor()
        self.pointLabel!.font = UIFont.boldSystemFontOfSize(20.0)
        failedView!.addSubview(self.pointLabel!)
        
        self.nextPointLabel = UILabel()
        self.nextPointLabel!.textAlignment = .Right
        self.nextPointLabel!.textColor = UIColor.whiteColor()
        self.nextPointLabel!.font = UIFont.boldSystemFontOfSize(20.0)
        failedView!.addSubview(self.nextPointLabel!)
        
        self.totalLabel = UILabel()
        self.totalLabel!.textAlignment = .Center
        self.contentView.addSubview(self.totalLabel!)
        
        grayView.autoPinEdgeToSuperviewEdge(.Top)
        grayView.autoPinEdgeToSuperviewEdge(.Left)
        grayView.autoPinEdgeToSuperviewEdge(.Right)
        grayView.autoSetDimension(.Height, toSize: 20)
        
        line1.autoPinEdge(.Top, toEdge: .Bottom, ofView: grayView)
        line1.autoPinEdgeToSuperviewEdge(.Left)
        line1.autoPinEdgeToSuperviewEdge(.Right)
        line1.autoSetDimension(.Height, toSize: 1)
        
        levelLabel!.autoPinEdge(.Top, toEdge: .Bottom, ofView: line1)
        levelLabel!.autoPinEdgeToSuperviewEdge(.Left)
        levelLabel!.autoPinEdge(.Bottom, toEdge: .Top, ofView: line2)
        levelLabel!.autoSetDimensionsToSize(CGSize(width: 100,height: 50))
        
        line2.autoPinEdgeToSuperviewEdge(.Left)
        line2.autoPinEdgeToSuperviewEdge(.Right)
        line2.autoSetDimension(.Height, toSize: 1)
        line2.autoPinEdge(.Bottom, toEdge: .Top, ofView: failedView!, withOffset: -15)
        
        failedView!.autoPinEdgeToSuperviewEdge(.Left, withInset: 40)
        failedView!.autoPinEdgeToSuperviewEdge(.Right, withInset: 40)
        failedView!.autoPinEdge(.Bottom, toEdge: .Top, ofView: totalLabel!,withOffset: -8)
        
        winedView!.autoPinEdgeToSuperviewEdge(.Top)
        winedView!.autoPinEdgeToSuperviewEdge(.Left)
        winedView!.autoPinEdgeToSuperviewEdge(.Bottom)
        winedView!.autoMatchDimension(.Width, toDimension: .Width, ofView: failedView!, withMultiplier: 0)
        
        pointLabel!.autoPinEdgeToSuperviewEdge(.Top)
        pointLabel!.autoPinEdgeToSuperviewEdge(.Bottom)
        pointLabel!.autoPinEdgeToSuperviewEdge(.Left,withInset: 8)
        pointLabel!.autoSetDimension(.Width, toSize: 150)
        
        nextPointLabel!.autoPinEdgeToSuperviewEdge(.Top)
        nextPointLabel!.autoPinEdgeToSuperviewEdge(.Bottom)
        nextPointLabel!.autoPinEdgeToSuperviewEdge(.Right,withInset: 8)
        nextPointLabel!.autoSetDimension(.Width, toSize: 150)
        
        totalLabel!.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        totalLabel!.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        totalLabel!.autoPinEdge(.Bottom, toEdge: .Top, ofView: line3,withOffset: -8)
        
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
