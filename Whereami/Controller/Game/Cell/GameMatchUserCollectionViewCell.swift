//
//  GameMatchUserCollectionViewCell.swift
//  Whereami
//
//  Created by A on 16/4/1.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class GameMatchUserCollectionViewCell: UICollectionViewCell {
    var avatarImageView:UIImageView?
    var usernameLabel:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.avatarImageView = UIImageView()
        self.avatarImageView?.layer.masksToBounds = true
        self.avatarImageView?.layer.cornerRadius = 25
        self.addSubview(avatarImageView!)
        
        self.usernameLabel = UILabel()
        self.usernameLabel?.textAlignment = .Center
        self.usernameLabel?.font = UIFont.systemFontOfSize(12.0)
        self.addSubview(usernameLabel!)
        
        self.avatarImageView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        self.avatarImageView?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.avatarImageView?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.usernameLabel!, withOffset: -15)
        self.avatarImageView?.autoSetDimensionsToSize(CGSize(width: 50,height: 50))
        
        self.usernameLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        self.usernameLabel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
//        self.usernameLabel?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        self.usernameLabel?.autoSetDimension(.Height, toSize: 50)
    }
}
