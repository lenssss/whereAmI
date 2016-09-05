//
//  RankItemView.swift
//  Whereami
//
//  Created by WuQifei on 16/2/18.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout

class RankItemView: UIView {

    var avatar:UIImageView? = nil
    var username:UILabel? = nil
    var rankGrade:UILabel? = nil
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI() {
        self.avatar = UIImageView()
        self.username = UILabel()
        self.rankGrade = UILabel()
        
        self.addSubview(self.avatar!)
        self.addSubview(self.username!)
        self.addSubview(self.rankGrade!)
        
        self.avatar?.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        self.avatar?.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 16)
        self.avatar?.autoSetDimensionsToSize(CGSize(width: 30, height: 30))
        
        self.username?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!, withOffset: 10)
        self.username?.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        self.username?.autoPinEdgeToSuperviewEdge(.Bottom)
        self.username?.autoPinEdgeToSuperviewEdge(.Top)
        self.username?.autoPinEdge(.Right, toEdge: .Left, ofView: self.rankGrade!, withOffset: 10)
        self.username?.textColor = UIColor.blackColor()
        
        self.rankGrade?.autoPinEdgeToSuperviewEdge(.Right, withInset: 24)
        self.rankGrade?.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        self.rankGrade?.autoSetDimensionsToSize(CGSize(width: 20, height: 20))
        
        self.rankGrade?.layer.masksToBounds = true
        self.rankGrade?.layer.cornerRadius = 10.0
        self.rankGrade?.textColor = UIColor.whiteColor()
        self.rankGrade?.backgroundColor = UIColor.redColor()
        self.rankGrade?.font = UIFont.systemFontOfSize(13.0)
        self.rankGrade?.textAlignment = .Center
        
        self.avatar?.layer.masksToBounds = true
        self.avatar?.layer.cornerRadius = 15.0
        
        self.username?.font = UIFont.systemFontOfSize(14.0)
    }
}
