//
//  RankFullItemsView.swift
//  Whereami
//
//  Created by WuQifei on 16/2/18.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout

class RankFullItemsView: UIView {
    
    var rankItemView1:RankItemView? = nil
    var rankItemView2:RankItemView? = nil
    var rankItemView3:RankItemView? = nil
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
    
    func fakeData() {
        rankItemView1?.avatar?.image = UIImage(named: "temp001.jpg");
        rankItemView1?.username?.text = "nick"
        rankItemView1?.rankGrade?.text = "1";
        
        rankItemView2?.avatar?.image = UIImage(named: "temp001.jpg");
        rankItemView2?.username?.text = "luak"
        rankItemView2?.rankGrade?.text = "2";
        
        rankItemView3?.avatar?.image = UIImage(named: "temp001.jpg");
        rankItemView3?.username?.text = "monk"
        rankItemView3?.rankGrade?.text = "3";
    }
    
    func setupUI() {
        self.rankItemView1 = RankItemView()
        self.rankItemView2 = RankItemView()
        self.rankItemView3 = RankItemView()
        
        self.fakeData()
        
        self.addSubview(self.rankItemView1!)
        self.addSubview(self.rankItemView2!)
        self.addSubview(self.rankItemView3!)
        
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor(red: 184/255.0, green: 184/255.0, blue: 184/255.0, alpha: 1.0)
        let lineView2 = UIView()
        lineView2.backgroundColor = UIColor(red: 184/255.0, green: 184/255.0, blue: 184/255.0, alpha: 1.0)
        let lineView3 = UIView()
        lineView3.backgroundColor = UIColor(red: 184/255.0, green: 184/255.0, blue: 184/255.0, alpha: 1.0)
        
        self.addSubview(lineView1)
        self.addSubview(lineView2)
        self.addSubview(lineView3)
        
        self.rankItemView1?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.rankItemView1?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        self.rankItemView1?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        
        self.rankItemView2?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.rankItemView2?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        self.rankItemView3?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.rankItemView3?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        self.rankItemView3?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        
        self.rankItemView1?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.rankItemView2!)
        self.rankItemView1?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.rankItemView3!)
        
        lineView1.autoSetDimension(.Height, toSize: 0.5)
        lineView1.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        lineView1.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        lineView2.autoSetDimension(.Height, toSize: 0.5)
        lineView2.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        lineView2.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        lineView3.autoSetDimension(.Height, toSize: 0.5)
        lineView3.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        lineView3.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        self.rankItemView1?.autoPinEdge(.Bottom, toEdge: .Top, ofView: lineView1)
        
        self.rankItemView2?.autoPinEdge(.Top, toEdge: .Bottom, ofView: lineView1)
        self.rankItemView2?.autoPinEdge(.Bottom, toEdge: .Top, ofView: lineView2)
        
        self.rankItemView3?.autoPinEdge(.Top, toEdge: .Bottom, ofView: lineView2)
        self.rankItemView3?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: lineView3)
    }
}
