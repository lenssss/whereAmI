//
//  PersonalCommentInputView.swift
//  Whereami
//
//  Created by A on 16/4/29.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalCommentInputView: UIView {
    
    typealias theCallback = () -> Void
    
    var textView:MessageTextView? = nil
    var publishButton:UIButton? = nil
    var publishAction:theCallback? = nil
    var contentConstraint:NSLayoutConstraint? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }
    
    func setUI(){
        self.backgroundColor = UIColor.whiteColor()
        
        self.textView = MessageTextView()
        self.textView?.placeHolder = ""
        self.textView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.textView?.layer.borderWidth = 1.0
        self.textView?.layer.cornerRadius = 5.0
        
        self.addSubview(self.textView!)
        
        self.publishButton = UIButton()
        self.publishButton?.setTitle("发送", forState: .Normal)
        self.publishButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        self.publishButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) in
            self.publishAction!()
        })
        self.addSubview(self.publishButton!)
        
        self.textView?.autoPinEdgeToSuperviewEdge(.Left,withInset: 5)
        self.textView?.autoPinEdgeToSuperviewEdge(.Top,withInset: 5)
        self.textView?.autoPinEdge(.Right, toEdge: .Left, ofView: self.publishButton!,withOffset: -5)
        self.contentConstraint = self.textView?.autoSetDimension(.Height, toSize: 30)
        self.textView?.autoPinEdgeToSuperviewEdge(.Bottom,withInset: 5)
        
        self.publishButton?.autoPinEdgeToSuperviewEdge(.Bottom,withInset: 5)
        self.publishButton?.autoSetDimensionsToSize(CGSize(width: 50,height: 30))
        self.publishButton?.autoPinEdgeToSuperviewEdge(.Right,withInset: 5)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
