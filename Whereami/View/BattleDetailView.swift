//
//  BattleDetailView.swift
//  Whereami
//
//  Created by lens on 16/3/24.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class BattleDetailView: UIView {
//    var backgroudImageView:UIImageView? = nil
    var vsLogo:UIImageView? = nil
    var currentUserAvatar:UIImageView? = nil
    var matchUserAvatar:UIImageView? = nil
    var currentUserName:UILabel? = nil
    var matchUserName:UILabel? = nil
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }
    
    func setUI(){
        self.backgroundColor = UIColor.whiteColor()
//        self.backgroudImageView = UIImageView()
//        self.backgroudImageView?.image = UIImage(named: "battleDetaiBackground")
//        self.backgroudImageView?.contentMode = .ScaleAspectFit
//        self.addSubview(self.backgroudImageView!)
        
        self.currentUserAvatar = UIImageView()
        self.currentUserAvatar?.contentMode = .ScaleAspectFit
        self.currentUserAvatar?.layer.masksToBounds = true
        self.currentUserAvatar?.layer.cornerRadius = 15
        self.addSubview(self.currentUserAvatar!)
        
        self.matchUserAvatar = UIImageView()
        self.matchUserAvatar?.contentMode = .ScaleAspectFit
        self.matchUserAvatar?.layer.masksToBounds = true
        self.matchUserAvatar?.layer.cornerRadius = 15
        self.addSubview(self.matchUserAvatar!)
        
        self.currentUserName = UILabel()
        self.currentUserName!.numberOfLines = 0
        self.currentUserName?.font = UIFont.systemFontOfSize(12.0)
        self.currentUserName?.textAlignment = .Left
        self.addSubview(self.currentUserName!)
        
        self.matchUserName = UILabel()
        self.matchUserName?.textAlignment = .Right
        self.matchUserName?.font = UIFont.systemFontOfSize(12.0)
        self.matchUserName!.numberOfLines = 0
        self.addSubview(self.matchUserName!)
        
        let line = UIView()
        line.backgroundColor = UIColor.getGameColor()
        self.addSubview(line)
        
        self.vsLogo = UIImageView()
        self.vsLogo?.backgroundColor = UIColor.redColor()
        self.vsLogo?.layer.masksToBounds = true
        self.vsLogo?.layer.cornerRadius = 20
        self.addSubview(self.vsLogo!)
        
//        self.backgroudImageView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        self.currentUserAvatar?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        self.currentUserAvatar?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
//        self.currentUserAvatar?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.currentUserAvatar?.autoSetDimensionsToSize(CGSize(width: 30, height: 30))
        self.currentUserAvatar?.autoPinEdge(.Right, toEdge: .Left, ofView: currentUserName!, withOffset: -10)
        
        self.currentUserName?.autoPinEdge(.Top, toEdge: .Top, ofView: self.currentUserAvatar!)
        self.currentUserName?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.currentUserAvatar!)
        self.currentUserAvatar?.autoSetDimension(.Width, toSize: 100)
        
        self.matchUserAvatar?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        self.matchUserAvatar?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
//        self.matchUserAvatar?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.matchUserAvatar?.autoSetDimensionsToSize(CGSize(width: 30,height: 30))
        
        self.matchUserName?.autoPinEdge(.Top, toEdge: .Top, ofView: self.matchUserAvatar!)
        self.matchUserName?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.matchUserAvatar!)
        self.matchUserName?.autoSetDimension(.Width, toSize: 100)
        self.matchUserName?.autoPinEdge(.Right, toEdge: .Left, ofView: matchUserAvatar!, withOffset: -10)
        
        line.autoAlignAxisToSuperviewAxis(.Vertical)
        line.autoPinEdgeToSuperviewEdge(.Top)
        line.autoPinEdgeToSuperviewEdge(.Bottom)
        line.autoSetDimension(.Width, toSize: 2)
        
        self.vsLogo?.autoAlignAxisToSuperviewAxis(.Horizontal)
        self.vsLogo?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.vsLogo?.autoSetDimensionsToSize(CGSize(width: 40,height: 40))
    }
}
