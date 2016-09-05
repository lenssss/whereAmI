//
//  RotationGestureRecognizer.swift
//  wheelViewTest
//
//  Created by ChenPengyu on 16/3/8.
//  Copyright © 2016年 ChenPengYu. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class RotationGestureRecognizer: UIPanGestureRecognizer {
    
    var rotation:CGFloat? = nil
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        if(event.touchesForGestureRecognizer(self)?.count>1){
            state = .Failed
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        if(state == .Possible){
            state = .Began
        }
        else{
            state = .Changed
        }
        let touch = (touches as NSSet).anyObject()
        let view = self.view
        let center = CGPoint(x: CGRectGetMidX((view?.bounds)!),y: CGRectGetMidY((view?.bounds)!))
        let currentTouchPoint = touch?.locationInView(view)
        let previousTouchPoint = touch?.previousLocationInView(view)
        let angleInRadians = atan2f(Float(currentTouchPoint!.y - center.y), Float(currentTouchPoint!.x - center.x)) - atan2f(Float(previousTouchPoint!.y - center.y), Float(previousTouchPoint!.x - center.x))
        self.rotation = CGFloat(angleInRadians)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        if(state == .Changed){
            state = .Ended
        }
        else{
            state = .Failed
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        state = .Failed
    }
}
