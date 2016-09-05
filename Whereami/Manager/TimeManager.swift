//
//  TimeManager.swift
//  Whereami
//
//  Created by A on 16/4/29.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class TimeManager: NSObject {
    private static var instance:TimeManager? = nil
    private static var onceToken:dispatch_once_t = 0
    
    class var sharedInstance: TimeManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = TimeManager()
        }
        return instance!
    }
    
    func getDateStringFromString(string:String) -> String? {
        let str = NSString(string:string)
        let createAt = str.doubleValue/1000
        let now = NSDate().timeIntervalSince1970
        var time = (now - createAt)/60
        var dateString = ""
        if time >= 60 {
            time = time/60
            if time >= 24 {
                time = time/24
                if time <= 7 {
                    dateString = getDateFromString("\(createAt)", dateFormat: "EEEE")!
                }
                else{
                    dateString = getDateFromString("\(createAt)", dateFormat: "yyyy-MM-dd")!
                }
            }
            else{
                dateString = getDateFromString("\(createAt)", dateFormat: "EEEE HH:mm:ss")!
            }
        }
        else{
            dateString = "\(Int(time)) min ago"
        }
        return dateString
    }
    
    func getDateFromString(string:String,dateFormat:String) -> String? {
        let str = NSString(string:string)
        let createAt = str.doubleValue
        let time = NSDate(timeIntervalSince1970: createAt)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
//        "yyyy-MM-dd HH:mm:ss"
        var dateString = dateFormatter.stringFromDate(time)
        
        if dateFormat == "EEEE HH:mm:ss" {
            let now = dateFormatter.stringFromDate(NSDate())
            let dateWeek = dateString.componentsSeparatedByString(" ")
            let nowWeek = now.componentsSeparatedByString(" ")
            
            if dateWeek[0] != nowWeek[0] {
                dateString = "Yesterday "
            }
            else{
                dateString = dateWeek[1]
            }
        }
        
        return dateString
    }
}
