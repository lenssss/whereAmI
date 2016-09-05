//
//  CountryCollectionViewCell.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    var countryImageView:UIImageView? = nil
    var nameLabel:UILabel? = nil
    var selectedView:UIImageView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.countryImageView = UIImageView()
        self.countryImageView?.contentMode = .ScaleAspectFit
        self.countryImageView?.backgroundColor = UIColor.clearColor()
        self.addSubview(countryImageView!)
        
        self.nameLabel = UILabel()
        self.nameLabel?.font = UIFont.systemFontOfSize(12.0)
        self.nameLabel?.textAlignment = .Center
        self.nameLabel?.textColor = UIColor.whiteColor()
        self.addSubview(nameLabel!)
        
        self.selectedView = UIImageView()
        self.selectedView?.image = UIImage(named: "select")
        self.selectedView?.hidden = true
        self.countryImageView?.addSubview(self.selectedView!)
        
        self.countryImageView?.autoPinEdgeToSuperviewEdge(.Top)
        self.countryImageView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.countryImageView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        self.countryImageView?.autoSetDimension(.Height, toSize: 60)
        self.countryImageView?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.nameLabel!)
        
        self.selectedView?.autoCenterInSuperview()
        self.selectedView?.autoSetDimensionsToSize(CGSize(width: 20,height: 20))
        
        self.nameLabel?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.countryImageView!)
        self.nameLabel?.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: self.countryImageView!)
        self.nameLabel?.autoSetDimension(.Height, toSize: 20)
    }
}
