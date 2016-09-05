//
//  PulsingHaloLayer.swift
//  font
//
//  Created by A on 16/5/16.
//  Copyright © 2016年 A. All rights reserved.
//

import UIKit

class PulsingHaloLayer: CALayer {
    var radius:CGFloat? = nil
    var animationDuration:NSTimeInterval? = nil
    var pulseInterval:NSTimeInterval? = nil
    var animationGroup:CAAnimationGroup? = nil
    
    func initWithRadius(radius:CGFloat,animationDuration:NSTimeInterval,pulseInterval:NSTimeInterval) -> PulsingHaloLayer {
        self.radius = radius
        self.animationDuration = animationDuration
        self.pulseInterval = pulseInterval
//        self.backgroundColor = UIColor(red: 71/255.0, green: 80/255.0, blue: 108/255.0, alpha: 1).CGColor
        self.backgroundColor = UIColor.grayColor().CGColor
        
        let tempPos = self.position
        let diameter = self.radius! * 2
        self.bounds = CGRectMake(0, 0, diameter, diameter)
        self.cornerRadius = self.radius!
        self.position = tempPos
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            self.setupAnimationGroup()
            
            if(self.pulseInterval != NSTimeInterval(CGFloat.max)) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.addAnimation(self.animationGroup!, forKey: "pulse")
                });
            }
        });
        return self
    }
    
    func setupAnimationGroup() {
        let defaultCurve = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionDefault)
        
        self.animationGroup = CAAnimationGroup()
        self.animationGroup?.duration = self.animationDuration! + self.pulseInterval!
        self.animationGroup?.repeatCount = Float(CGFloat.max)
        self.animationGroup?.removedOnCompletion = false
        self.animationGroup?.timingFunction = defaultCurve
        
        let scaleAnimation = CABasicAnimation.init(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = self.animationDuration!
        
        let opacityAnimation = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnimation.duration = self.animationDuration!
        opacityAnimation.values = [0.8,0.45,0]
        opacityAnimation.keyTimes = [0,0.2,1]
        opacityAnimation.removedOnCompletion = false
        
        let animations = [scaleAnimation,opacityAnimation]
        self.animationGroup?.animations = animations
    }
}
