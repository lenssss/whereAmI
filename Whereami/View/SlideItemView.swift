//
//  SlideItemView.swift
//  Whereami
//
//  Created by WuQifei on 16/2/19.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout

class SlideItemView: UIView {
    
    var viewDescription:UILabel? = nil
    var viewIcon:UIImageView? = nil
    var row:Int = 0
    var section:Int = 0
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI(){
        self.viewDescription = UILabel()
        self.viewDescription?.font = UIFont.systemFontOfSize(12.0)
        self.viewIcon = UIImageView()
        self.addSubview(self.viewIcon!)
        self.addSubview(self.viewDescription!)
        
        self.viewIcon?.autoSetDimensionsToSize(CGSize(width: 25, height: 25))
        self.viewIcon?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.viewIcon?.autoAlignAxis(.Horizontal, toSameAxisOfView: self, withOffset: -10)
        
        self.viewDescription?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.viewIcon!, withOffset: 1)
        self.viewDescription?.autoAlignAxisToSuperviewAxis(.Vertical)
    }

}
