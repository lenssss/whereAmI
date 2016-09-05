//
//  AssetsItemsView.swift
//  Whereami
//
//  Created by WuQifei on 16/2/17.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout

class AssetsItemsView: UIView {
    
    var assetsButton1:AssetsItemsButtonView? = nil
    var assetsButton2:AssetsItemsButtonView? = nil
    var assetsButton3:AssetsItemsButtonView? = nil
    var assetsButton4:AssetsItemsButtonView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.getNavigationBarColor()
        
        assetsButton1 = AssetsItemsButtonView()
        assetsButton2 = AssetsItemsButtonView()
        assetsButton3 = AssetsItemsButtonView()
        assetsButton4 = AssetsItemsButtonView()
        
        assetsButton1?.backgroundColor = UIColor.getNavigationBarColor()
        assetsButton2?.backgroundColor = UIColor.getNavigationBarColor()
        assetsButton3?.backgroundColor = UIColor.getNavigationBarColor()
        assetsButton4?.backgroundColor = UIColor.getNavigationBarColor()
        
        assetsButton1?.count?.textColor = UIColor.whiteColor()
        assetsButton2?.count?.textColor = UIColor.whiteColor()
        assetsButton3?.count?.textColor = UIColor.whiteColor()
        assetsButton4?.count?.textColor = UIColor.whiteColor()
        
//        assetsButton1?.count?.text = NSLocalizedString("full",tableName:"Localizable",comment: "Full")
//        assetsButton2?.count?.text = "10"
//        assetsButton3?.count?.text = "12"
//        assetsButton4?.count?.text = "15"
        
        assetsButton1?.count?.font = UIFont.customFont(12.0)
        assetsButton2?.count?.font = UIFont.customFont(12.0)
        assetsButton3?.count?.font = UIFont.customFont(12.0)
        assetsButton4?.count?.font = UIFont.customFont(12.0)
        
        assetsButton1?.icon?.image = UIImage(named: "main_life")
        assetsButton2?.icon?.image = UIImage(named: "main_chance")
        assetsButton3?.icon?.image = UIImage(named: "main_diamond")
        assetsButton4?.icon?.image = UIImage(named: "main_gold")
        
//        assetsButton1?.setTitle(NSLocalizedString("full",tableName:"Localizable",comment: "Full"), forState: .Normal)
//        assetsButton2?.setTitle("10", forState: .Normal)
//        assetsButton3?.setTitle("12", forState: .Normal)
//        assetsButton4?.setTitle("15", forState: .Normal)
        
        self.addSubview(assetsButton1!)
        self.addSubview(assetsButton2!)
        self.addSubview(assetsButton3!)
        self.addSubview(assetsButton4!)
        
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 0.7)
        
        let lineView2 = UIView()
        lineView2.backgroundColor = UIColor(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 0.7)
        
        let lineView3 = UIView()
        lineView3.backgroundColor = UIColor(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 0.7)
        
        self.addSubview(lineView1)
        self.addSubview(lineView2)
        self.addSubview(lineView3)
        
        lineView1.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
        lineView1.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)
        lineView1.autoSetDimension(.Width, toSize: 0.5)
        
        lineView2.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
        lineView2.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)
        lineView2.autoSetDimension(.Width, toSize: 0.5)
        
        lineView3.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
        lineView3.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 5)
        lineView3.autoSetDimension(.Width, toSize: 0.5)
        
        assetsButton1?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        assetsButton1?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        assetsButton1?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        
        assetsButton2?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        assetsButton2?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        
        assetsButton3?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        assetsButton3?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        
        assetsButton4?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        assetsButton4?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        assetsButton4?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        
        assetsButton1?.autoMatchDimension(.Width, toDimension: .Width, ofView: assetsButton2!)
        assetsButton1?.autoMatchDimension(.Width, toDimension: .Width, ofView: assetsButton3!)
        assetsButton1?.autoMatchDimension(.Width, toDimension: .Width, ofView: assetsButton4!)
        
        assetsButton1?.autoPinEdge(.Right, toEdge: .Left, ofView: lineView1)
        
        assetsButton2?.autoPinEdge(.Left, toEdge: .Right, ofView: lineView1)
        assetsButton2?.autoPinEdge(.Right, toEdge: .Left, ofView: lineView2)
        
        assetsButton3?.autoPinEdge(.Left, toEdge: .Right, ofView: lineView2)
        assetsButton3?.autoPinEdge(.Right, toEdge: .Left, ofView: lineView3)
        
        assetsButton4?.autoPinEdge(.Left, toEdge: .Right, ofView: lineView3)
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

class AssetsItemsButtonView: UIView {
    
    typealias theCallback = () -> Void
    
    var icon:UIImageView? = nil
    var count:UILabel? = nil
    var button:UIButton? = nil
    var buttonAction:theCallback? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView(){
        icon = UIImageView()
        self.addSubview(icon!)
        
        count = UILabel()
        self.addSubview(count!)
        
        button = UIButton()
        button?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.buttonAction?()
        })
        self.addSubview(button!)
        
        icon?.autoPinEdgeToSuperviewEdge(.Top)
        icon?.autoPinEdgeToSuperviewEdge(.Bottom)
        icon?.autoMatchDimension(.Width, toDimension: .Height, ofView: icon!)
        icon?.autoAlignAxis(.Vertical, toSameAxisOfView: self, withOffset: -15)
        
        count?.autoPinEdgeToSuperviewEdge(.Top)
        count?.autoPinEdgeToSuperviewEdge(.Bottom)
        count?.autoMatchDimension(.Width, toDimension: .Height, ofView: count!)
        count?.autoAlignAxis(.Vertical, toSameAxisOfView: self, withOffset: 15)
        
        button?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    }
}
