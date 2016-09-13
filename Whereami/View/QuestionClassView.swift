//
//  QuestionClassView.swift
//  Whereami
//
//  Created by lens on 16/3/24.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class QuestionClassView: UIView {
    var QuestionClassName:UILabel? = nil
    var QuestionClassPicture:UIImageView? = nil
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }
    
    func setUI(){
        self.QuestionClassName = UILabel()
        self.QuestionClassName?.font = UIFont.systemFontOfSize(30)
        self.QuestionClassName?.textAlignment = .Center
        self.QuestionClassName?.textColor = UIColor.whiteColor()
        self.addSubview(self.QuestionClassName!)
        
        self.QuestionClassPicture = UIImageView()
        self.QuestionClassPicture?.layer.masksToBounds = true
        self.QuestionClassPicture?.layer.cornerRadius = 10
        self.addSubview(self.QuestionClassPicture!)
        
        self.QuestionClassName?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        self.QuestionClassName?.autoSetDimensionsToSize(CGSize(width: 200,height: 50))
        self.QuestionClassName?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.QuestionClassName?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.QuestionClassPicture!, withOffset: -20)

        self.QuestionClassPicture?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.QuestionClassPicture?.autoSetDimensionsToSize(CGSize(width: 150,height: 150))
    }
}
