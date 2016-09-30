//
//  UIFontExtension.swift
//  Whereami
//
//  Created by A on 16/5/4.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    static func setCustomFontWithSize(size:CGFloat) -> UIFont{
        let font = UIFont(name: "AvenirNextCondensed-Medium", size: size)
        return font!
    }
    
    static func setCustomFont() -> UIFont {
        return UIFont(name: "AvenirNextCondensed-Medium", size: 17.0)!
    }
    
    static func setCustomBolderFontWithSize(size:CGFloat) -> UIFont{
        return UIFont(name: "AvenirNextCondensed-Bold", size: size)!
    }
    
    static func customFont(size:CGFloat) -> UIFont? {
        return UIFont.customFontWithStyle("Thin", size: size)
    }
    
    static func customFontWithStyle(style:String,size:CGFloat) -> UIFont?{
        var path = ""
        if style == "Thin" {
            path = self.getFontPath("SF-UI-Display-Thin")!
        }
        else if style == "Medium" {
            path = self.getFontPath("SF-UI-Display-Medium")!
        }
        else if style == "Bold" {
            path = self.getFontPath("SF-UI-Display-Bold")!
        }
        else if style == "Regular" {
            path = self.getFontPath("SF-UI-Display-Regular")!
        }
        let fontUrl = NSURL.fileURLWithPath(path)
        let fontDataProvider =  CGDataProviderCreateWithURL(fontUrl)
        let fontRef = CGFontCreateWithDataProvider(fontDataProvider!)
        CTFontManagerRegisterGraphicsFont(fontRef, nil)
        let fontName:NSString = CGFontCopyPostScriptName(fontRef)!
        let font = UIFont(name: fontName as String,size: size)
        return font
    }
    
    static func getFontPath(fileName:String) -> String?{
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "otf")
        return path
    }
}
