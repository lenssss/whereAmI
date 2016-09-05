//
//  PersonalHeadTableViewCell.swift
//  Whereami
//
//  Created by A on 16/3/30.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalHeadTableViewCell: UITableViewCell {
    
    var userImageView:UIImageView? = nil
    var userNicknameLabel:UILabel? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.userImageView = UIImageView()
        self.userImageView?.layer.masksToBounds = true
        self.userImageView?.layer.cornerRadius = 30
        self.contentView.addSubview(userImageView!)
        
        self.userNicknameLabel = UILabel()
        self.userNicknameLabel?.textAlignment = .Left
        self.contentView.addSubview(userNicknameLabel!)
        
        self.userImageView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 15)
        self.userImageView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
        self.userImageView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15)
        self.userImageView?.autoSetDimensionsToSize(CGSize(width: 60,height: 60))
        
        self.userNicknameLabel?.autoPinEdge(.Left, toEdge: .Right, ofView: self.userImageView!, withOffset: 5)
        self.userNicknameLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 15)
        self.userNicknameLabel?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 15)
        self.userNicknameLabel?.autoSetDimensionsToSize(CGSize(width: 100,height: 60))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
