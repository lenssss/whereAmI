//
//  UIColorExtension.swift
//  Whereami
//
//  Created by WuQifei on 16/2/15.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func getMainColor() -> UIColor {
        return UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    }
    
    class func getGameColor() -> UIColor {
        return UIColor(red: 64/255.0, green: 76/255.0, blue: 109/255.0, alpha: 1)
    }
    
    class func getNavigationBarColor() -> UIColor {
        return UIColor(red: 57/255.0, green: 169/255.0, blue: 184/255.0, alpha: 1.0)
    }
}