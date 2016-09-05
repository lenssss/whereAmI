//
//  PersonalPhotoCollectionViewCell.swift
//  Whereami
//
//  Created by A on 16/4/26.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalPhotoCollectionViewCell: UICollectionViewCell {
    
    var photoView:UIImageView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }
    
    func setUI(){
        self.photoView = UIImageView()
        self.photoView?.image = UIImage(named: "placeholder")
        self.photoView?.layer.masksToBounds = true
        self.photoView?.contentMode = .ScaleAspectFill
        self.contentView.addSubview(self.photoView!)
        
        self.photoView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    }
}
