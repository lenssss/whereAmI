//
//  NSDateExtension.swift
//  Whereami
//
//  Created by A on 16/4/13.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation

extension NSDate {
    static func  string2Date(dateStr:String)->NSDate {
        let long = dateStr.toDouble()
        let date = self.long2Date(long!)
        return date
    }
    
    static func long2Date(dateFloat:Double)->NSDate {
        let date = NSDate(timeIntervalSince1970: dateFloat)
        return date
    }
}