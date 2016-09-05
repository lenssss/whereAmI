//
//  PersonalPerformanceChallengesTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/26.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalPerformanceChallengesTableViewCell: UITableViewCell {

    var winLabel:UILabel? = nil
    var loseLabel:UILabel? = nil
    var totalLabel:UILabel? = nil
    
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
        
        let challengeLabel = UILabel()
        challengeLabel.text = NSLocalizedString("challenges",tableName:"Localizable", comment: "")
        challengeLabel.textAlignment = .Left
        challengeLabel.textColor = UIColor.blackColor()
        self.contentView.addSubview(challengeLabel)
        
        let failedView = UIView()
        failedView.layer.cornerRadius = 5.0
        failedView.backgroundColor = UIColor(red: 253/255.0, green: 121/255.0, blue: 126/255.0, alpha: 1)
        self.contentView.addSubview(failedView)
        
        let winedView = UIView()
        winedView.layer.cornerRadius = 5.0
        winedView.backgroundColor = UIColor(red: 137/255.0, green: 223/255.0, blue: 126/255.0, alpha: 1)
        failedView.addSubview(winedView)
        
        self.winLabel = UILabel()
        winLabel!.textAlignment = .Left
        winLabel!.layer.cornerRadius = 5.0
        winLabel!.textColor = UIColor.whiteColor()
        winLabel!.font = UIFont.boldSystemFontOfSize(20.0)
        failedView.addSubview(winLabel!)
        
        self.loseLabel = UILabel()
        loseLabel!.textAlignment = .Right
        loseLabel!.textColor = UIColor.whiteColor()
        loseLabel!.font = UIFont.boldSystemFontOfSize(20.0)
        failedView.addSubview(loseLabel!)
        
        self.totalLabel = UILabel()
        totalLabel!.textAlignment = .Center
        self.contentView.addSubview(totalLabel!)
        
        grayView.autoPinEdgeToSuperviewEdge(.Top)
        grayView.autoPinEdgeToSuperviewEdge(.Left)
        grayView.autoPinEdgeToSuperviewEdge(.Right)
        grayView.autoSetDimension(.Height, toSize: 20)
        
        line1.autoPinEdge(.Top, toEdge: .Bottom, ofView: grayView)
        line1.autoPinEdgeToSuperviewEdge(.Left)
        line1.autoPinEdgeToSuperviewEdge(.Right)
        line1.autoSetDimension(.Height, toSize: 1)
        
        challengeLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: line1)
        challengeLabel.autoPinEdgeToSuperviewEdge(.Left)
        challengeLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: line2)
        challengeLabel.autoSetDimensionsToSize(CGSize(width: 100,height: 50))
        
        line2.autoPinEdgeToSuperviewEdge(.Left)
        line2.autoPinEdgeToSuperviewEdge(.Right)
        line2.autoSetDimension(.Height, toSize: 1)
        line2.autoPinEdge(.Bottom, toEdge: .Top, ofView: failedView, withOffset: -15)
        
        failedView.autoPinEdgeToSuperviewEdge(.Left, withInset: 40)
        failedView.autoPinEdgeToSuperviewEdge(.Right, withInset: 40)
        failedView.autoPinEdge(.Bottom, toEdge: .Top, ofView: totalLabel!,withOffset: -8)
        
        winedView.autoPinEdgeToSuperviewEdge(.Top)
        winedView.autoPinEdgeToSuperviewEdge(.Left)
        winedView.autoPinEdgeToSuperviewEdge(.Bottom)
        winedView.autoMatchDimension(.Width, toDimension: .Width, ofView: failedView, withMultiplier: 0.5)
        
        winLabel!.autoPinEdgeToSuperviewEdge(.Top)
        winLabel!.autoPinEdgeToSuperviewEdge(.Bottom)
        winLabel!.autoPinEdgeToSuperviewEdge(.Left,withInset: 8)
        winLabel!.autoSetDimension(.Width, toSize: 150)
        
        loseLabel!.autoPinEdgeToSuperviewEdge(.Top)
        loseLabel!.autoPinEdgeToSuperviewEdge(.Bottom)
        loseLabel!.autoPinEdgeToSuperviewEdge(.Right,withInset: 8)
        loseLabel!.autoSetDimension(.Width, toSize: 150)
        
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
