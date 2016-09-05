//
//  TheBackBarButtonItem.swift
//  Whereami
//
//  Created by A on 16/5/18.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class TheBackBarButton: UIButton {
    
    typealias theCallback = () -> Void
    
    class func initWithAction(action:theCallback) -> UIButton {
        let button = UIButton()
        button.bounds = CGRect(x: 0,y: 0,width: 30,height: 30)
        let image = UIImage(named: "back")
        button.setBackgroundImage(image, forState: .Normal)
        button.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            action()
        }
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
