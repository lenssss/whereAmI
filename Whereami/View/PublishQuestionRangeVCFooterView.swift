//
//  PublishQuestionRangeVCFooterView.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/21.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PublishQuestionRangeVCFooterView: UIView {
    typealias Callback = () -> Void
    
    var confirmButton:UIButton?
    var ButtonCallback:Callback?

    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
    }
    
    func setUI(){
        self.confirmButton = UIButton()
        self.confirmButton?.backgroundColor = UIColor.lightGrayColor()
        self.confirmButton?.layer.cornerRadius = 10.0
        self.confirmButton?.setTitle(NSLocalizedString("publish",tableName:"Localizable", comment: ""), forState: .Normal)
        self.confirmButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.confirmButton?.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (button) -> Void in
            self.ButtonCallback!()
        })
        self.addSubview(self.confirmButton!)
        
        self.confirmButton?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
    }
    
}
