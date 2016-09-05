//
//  UIImageViewExtension.swift
//  Whereami
//
//  Created by A on 16/5/24.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    
    typealias theCallback = (UIImage?) -> Void
    
    public func setImageWithString(string:String,placeholderImage image:UIImage){
        if string != "" {
            self.image = UIImage.string2Image(string)
        }
        else{
            self.image = image
        }
    }
    
    func setImageWithId(photoId:String){
        PicDownloadManager.sharedInstance.getPicById(photoId) { (image) in
            self.runInMainQueue({ 
                self.image = image!
            })
        }
    }
}
