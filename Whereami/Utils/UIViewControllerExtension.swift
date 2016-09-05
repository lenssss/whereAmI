//
//  UIViewControllerExtension.swift
//  Whereami
//
//  Created by WuQifei on 16/2/16.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    public func showNetworkIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    public func hideNetworkIndicator() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    public func runInMainQueue(queue : () ->Void) {
        dispatch_async(dispatch_get_main_queue(), queue)
    }
    
    public func runInGlobalQueue(queue : () -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), queue)
    }
    
    public func runAfterSecs(secs:Int64, queue:()->Void) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), queue)
    }
    
    
}