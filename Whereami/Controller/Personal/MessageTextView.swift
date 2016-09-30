//
//  MessageTextView.swift
//  ChatView
//
//  Created by 吴启飞 on 16/4/27.
//  Copyright © 2016年 Amazing W. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MessageTextView: UITextView {
    
    var maxCharacerPerLine:Int {
        return 33
    }
    
    private var _placeHolder:String = "Write Something ..."
    
    var placeHolder:String = "Write Something ..." {
        willSet(newValue) {
            if newValue == placeHolder {
                return
            }
            var dealedValue = ""
            if newValue.characters.count > maxCharacerPerLine {
                let length = maxCharacerPerLine - 8
                dealedValue = newValue.substring(0, length: length)
                dealedValue.appendContentsOf("...")
            }else {
                dealedValue = newValue
            }
            _placeHolder = dealedValue
        }
        didSet {
            if placeHolder !=  _placeHolder {
                placeHolder = _placeHolder
            }
            self.setNeedsDisplay()
        }
    }
    
    private var _placeHolderTextColor:UIColor = UIColor.lightGrayColor()
    
    var placeHolderTextColor:UIColor = UIColor.lightGrayColor() {
        willSet (newValue) {
            if newValue.isEqual(placeHolderTextColor) {
                return
            }
            _placeHolderTextColor = newValue
            
        }
        didSet {
            if placeHolderTextColor != _placeHolderTextColor {
                placeHolderTextColor = _placeHolderTextColor
            }
            
            
        }
    }
    
    func numberOfLinesOfText()->(Int) {
        let lines = text.length / maxCharacerPerLine + 1
        return lines
    }
    
    func setup() {
        LNotificationCenter().rac_addObserverForName(UITextViewTextDidChangeNotification, object: nil).subscribeNext { (anyObj) in
            self.setNeedsDisplay()
        }
        self.placeHolderTextColor = UIColor.lightGrayColor()
        self.autoresizingMask = .FlexibleWidth
        self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0, 0.0, 10.0, 8.0)
        self.contentInset = UIEdgeInsetsZero
        self.scrollEnabled = true
        self.scrollsToTop = false
        self.userInteractionEnabled = true
        self.font = UIFont.systemFontOfSize(16.0)
        self.textColor = UIColor.lightGrayColor()
        self.backgroundColor = UIColor.whiteColor()
        self.keyboardAppearance = .Default;
        self.keyboardType = .Default;
        self.returnKeyType = .Default;
        self.textAlignment = .Left;
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        
        if self.text.length == 0 && self.placeHolder.length > 0 {
            let placeHolderRect = CGRect(x: 10,y: 7.0,width: rect.width,height: rect.height)
            self.placeHolderTextColor.set()
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .ByTruncatingTail
            paragraphStyle.alignment = self.textAlignment
            
            (self.placeHolder as NSString).drawInRect(placeHolderRect, withAttributes: [NSFontAttributeName:self.font!,NSForegroundColorAttributeName:self.placeHolderTextColor,NSParagraphStyleAttributeName:paragraphStyle])
            
        }
    }
    
}
