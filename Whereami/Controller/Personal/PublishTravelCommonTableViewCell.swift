//
//  PublishTravelCommonTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PublishTravelCommonTableViewCell: UITableViewCell {
    
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
    
    func setupUI(){
        let locationLogo = UIImageView()
        locationLogo.image = UIImage(named: "location")
        self.contentView.addSubview(locationLogo)
        
        let locationLabel = UILabel()
        locationLabel.text = "location"
        locationLabel.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(locationLabel)
        
        let location = UILabel()
        location.text = LocationManager.sharedInstance.geoDes
        location.textColor = UIColor.lightGrayColor()
        location.font = UIFont.systemFontOfSize(12.0)
        location.textAlignment = .Right
        self.contentView.addSubview(location)
        
        locationLogo.autoPinEdgeToSuperviewEdge(.Left, withInset: 16.0)
        locationLogo.autoSetDimensionsToSize(CGSize(width: 25,height: 25))
        locationLogo.autoAlignAxisToSuperviewAxis(.Horizontal)
        locationLogo.autoPinEdge(.Right, toEdge: .Left, ofView: locationLabel)
        
        locationLabel.autoPinEdge(.Top, toEdge: .Top, ofView: locationLogo)
        locationLabel.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: locationLogo)
        locationLabel.autoSetDimension(.Width, toSize: 100)
        
        location.autoPinEdgeToSuperviewEdge(.Right, withInset: 16.0)
        location.autoPinEdge(.Top, toEdge: .Top, ofView: locationLogo)
        location.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: locationLogo)
        location.autoSetDimension(.Width, toSize: 150)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
