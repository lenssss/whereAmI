//
//  GameQuestionHeadView.swift
//  Whereami
//
//  Created by A on 16/3/25.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class GameQuestionHeadView: UIView {
    typealias theCallback = () -> Void
    
    var QuestionTitle:UILabel? = nil
    var QuestionPicture:UIImageView? = nil
//    var collectButton:UIButton? = nil
//    var callBack:theCallback? = nil
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }
    
    func setUI(){
        self.QuestionTitle = UILabel()
        self.QuestionTitle?.font = UIFont.systemFontOfSize(12.0)
        self.QuestionTitle?.textAlignment = .Center
        self.QuestionTitle?.numberOfLines = 0
        self.QuestionTitle?.textColor = UIColor.whiteColor()
        self.addSubview(self.QuestionTitle!)
        
        self.QuestionPicture = UIImageView()
        self.QuestionPicture?.layer.masksToBounds = true
        self.QuestionPicture?.layer.cornerRadius = 10.0
        self.QuestionPicture?.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.QuestionPicture?.layer.borderWidth = 2.0
        self.addSubview(self.QuestionPicture!)
        
//        self.collectButton = UIButton()
//        self.collectButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
//            self.callBack!()
//        })
//        self.addSubview(self.collectButton!)
        
        self.QuestionTitle?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        self.QuestionTitle?.autoPinEdgeToSuperviewEdge(.Left, withInset: 80)
        self.QuestionTitle?.autoPinEdgeToSuperviewEdge(.Right, withInset: 80)
        self.QuestionTitle?.autoSetDimension(.Height, toSize: 60)
        self.QuestionTitle?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.QuestionPicture!, withOffset: 0)
        
//        self.QuestionPicture?.autoAlignAxisToSuperviewAxis(.Vertical)
//        self.QuestionPicture?.autoSetDimensionsToSize(CGSize(width: 220,height: 220))
        self.QuestionPicture?.autoPinEdgeToSuperviewEdge(.Left, withInset: 80)
        self.QuestionPicture?.autoPinEdgeToSuperviewEdge(.Right, withInset: 80)
        self.QuestionPicture?.autoMatchDimension(.Height, toDimension: .Width, ofView: self.QuestionPicture!)
        
//        self.collectButton?.autoPinEdgeToSuperviewEdge(.Left, withInset: 90)
//        self.collectButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 90)
//        self.collectButton?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.QuestionTitle!)
//        self.collectButton?.autoSetDimension(.Height, toSize: 50)
    }
}
