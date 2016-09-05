//
//  UIButtonPointedExtension.swift
//  Whereami
//
//  Created by 陈鹏宇 on 16/7/18.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        var viewController:UIViewController? = nil
        for var next = self.superview;(next != nil);next = next?.superview {
            let nextResponder = next?.nextResponder()
            if nextResponder!.isKindOfClass(UIViewController.self){
                viewController = nextResponder as? UIViewController
            }
        }
        guard viewController != nil else{
            return super.pointInside(point, withEvent: event)
        }

        var bounds = self.bounds
        let widthDelta = max(50-bounds.size.width, 0)
        let heightDelta = max(50-bounds.size.height, 0)
        bounds = CGRectInset(bounds, -0.5*widthDelta, -0.5*heightDelta)
        return CGRectContainsPoint(bounds, point)
    }
}
