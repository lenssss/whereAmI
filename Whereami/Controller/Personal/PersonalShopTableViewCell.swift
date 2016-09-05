//
//  PersonalShopTableViewCell.swift
//  Whereami
//
//  Created by A on 16/6/1.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalShopTableViewCell: UITableViewCell {
    
    var itemLogo:UIImageView? = nil
    var itemName:UILabel? = nil
    var priceBtn:UIButton? = nil
    var buyAction:theCallback? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI(){
        itemLogo = UIImageView()
        self.contentView.addSubview(itemLogo!)
        
        itemName = UILabel()
        itemName?.textAlignment = .Center
        itemName?.textColor = UIColor.grayColor()
        itemName?.font = UIFont.boldSystemFontOfSize(24.0)
        self.contentView.addSubview(itemName!)
        
        priceBtn = UIButton()
        priceBtn?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        priceBtn?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in

        })
        self.contentView.addSubview(priceBtn!)
        
        itemLogo?.autoPinEdgeToSuperviewEdge(.Left, withInset: 30)
        itemLogo?.autoPinEdgeToSuperviewEdge(.Top, withInset: 25)
        itemLogo?.autoSetDimensionsToSize(CGSize(width: 50,height: 50))
        
        itemName?.autoPinEdge(.Left, toEdge: .Right, ofView: itemLogo!)
        itemName?.autoPinEdge(.Top, toEdge: .Top, ofView: itemLogo!)
        itemName?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: itemLogo!)
        itemName?.autoPinEdge(.Right, toEdge: .Left, ofView: priceBtn!)
        
        priceBtn?.autoPinEdgeToSuperviewEdge(.Top, withInset: 35)
        priceBtn?.autoPinEdgeToSuperviewEdge(.Right, withInset: 5)
        priceBtn?.autoSetDimensionsToSize(CGSize(width: 90,height: 30))
    }
}
