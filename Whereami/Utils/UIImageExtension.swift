//
//  UIImageExtension.swift
//  Whereami
//
//  Created by WuQifei on 16/2/15.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIImage {
    
    typealias theCallback = (UIImage?,Int?) -> Void
    
    public class func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size);
        let ref:CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextSetFillColorWithColor(ref, color.CGColor)
        CGContextFillRect(ref, rect)
        
        let image:UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func imageWithColor(color:UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context!, 0, self.size.height);
        CGContextScaleCTM(context!, 1.0, -1.0);
        CGContextSetBlendMode(context!, .Normal);
        let rect = CGRectMake(0, 0, self.size.width, self.size.height);
        CGContextClipToMask(context!, rect, self.CGImage!);
        color.setFill()
        CGContextFillRect(context!, rect);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }
    
    func resized_Image(newSize:CGSize, interpolationQuality quality:CGInterpolationQuality) -> UIImage {
        var drawTransposed:Bool? = nil
        switch self.imageOrientation {
        case .Left:
            drawTransposed = true
        case .LeftMirrored:
            drawTransposed = true
        case .Right:
            drawTransposed = true
        case .RightMirrored:
            drawTransposed = true
            
        default:
            drawTransposed = false
        }
        
        return self.resizedImage(newSize, Transform: self.transformForOrientation(newSize), DrawTransposed: drawTransposed!, interpolationQuality: quality)
    }
    
    func transformForOrientation(newSize:CGSize) -> CGAffineTransform {
    var transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
    case .Down:
        transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI));// EXIF = 3
    case .DownMirrored:   // EXIF = 4
        transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
    break;
    
    case .Left:           // EXIF = 6
        transform = CGAffineTransformTranslate(transform, newSize.width, 0);
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
    case .LeftMirrored:   // EXIF = 5
    transform = CGAffineTransformTranslate(transform, newSize.width, 0);
    transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
    break;
    
    case .Right:          // EXIF = 8
        transform = CGAffineTransformTranslate(transform, 0, newSize.height);
        transform = CGAffineTransformRotate(transform, -CGFloat(M_PI_2));
    case .RightMirrored:  // EXIF = 7
    transform = CGAffineTransformTranslate(transform, 0, newSize.height);
    transform = CGAffineTransformRotate(transform, -CGFloat(M_PI_2));
    break;
    default:
    break;
    }
    
    switch (self.imageOrientation) {
    case .UpMirrored:     // EXIF = 2
        transform = CGAffineTransformTranslate(transform, newSize.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    case .DownMirrored:   // EXIF = 4
    transform = CGAffineTransformTranslate(transform, newSize.width, 0);
    transform = CGAffineTransformScale(transform, -1, 1);
    break;
    
    case .LeftMirrored:   // EXIF = 5
        transform = CGAffineTransformTranslate(transform, newSize.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    case .RightMirrored:  // EXIF = 7
    transform = CGAffineTransformTranslate(transform, newSize.height, 0);
    transform = CGAffineTransformScale(transform, -1, 1);
    break;
    default:
    break;
    }
    
    return transform;
    }
    
    func resizedImage(newSize:CGSize,Transform transform:CGAffineTransform,DrawTransposed transpose:Bool, interpolationQuality quality:CGInterpolationQuality) -> UIImage {
        let newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height))
        let transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width)
        let imageRef = self.CGImage
        let bitmap = CGBitmapContextCreate(nil, Int(newRect.size.width), Int(newRect.size.height), CGImageGetBitsPerComponent(imageRef!), 0, CGImageGetColorSpace(imageRef!)!, CGImageGetBitmapInfo(imageRef!).rawValue)
        CGContextConcatCTM(bitmap!, transform)
        CGContextSetInterpolationQuality(bitmap!, quality)
        CGContextDrawImage(bitmap!, transpose ? transposedRect : newRect, imageRef!)
        let newImageRef = CGBitmapContextCreateImage(bitmap!)
        let newImage = UIImage(CGImage: newImageRef!)
        return newImage
    }
    
    func image2String() -> String{
        let imageData = UIImageJPEGRepresentation(self, 0.8)
        let base64String = imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        return base64String!
    }
    
    public static func string2Image(string:String) -> UIImage? {
        let imageData = NSData.init(base64EncodedString: string, options: .IgnoreUnknownCharacters)
        let image = UIImage.init(data: imageData!)
        
        return image
    }
    
    static func setImageWithPhotoId(photoId:String, index:Int?, completion:theCallback){
        PicDownloadManager.sharedInstance.getPicById(photoId) { (image) in
            completion(image,index)
        }
//        let photoModel = CoreDataManager.sharedInstance.fetchPhotoById(photoId)
//        if photoModel != nil {
//            if photoModel?.file != nil{
//                let content = photoModel!.file
//                let id = photoModel?.id
//                let image = UIImage.string2Image(content!)
//                completion(image!,id)
//            }else{
//                completion(nil,nil)
//            }
//        }else{
//            var dict = [String: AnyObject]()
//            dict["id"] = photoId
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { 
//                SocketManager.sharedInstance.sendMsg("getPhotoByPhotoId", data: dict, onProto: "getPhotoByPhotoIded") { (code, objs) in
//                    if code == statusCode.Normal.rawValue {
//                        let photoModel = PhotoModel.getPhotoModelFromDictionary(objs[0] as! NSDictionary)
//                        CoreDataManager.sharedInstance.increasePhoto(photoModel!)
//                        if photoModel?.file != nil{
//                            let image = UIImage.string2Image((photoModel?.file)!)
//                            let id = photoModel?.id
//                            completion(image!,id)
//                        }else{
//                            completion(nil,nil)
//                        }
//                    }
//                }
//            })
//        }
    }
    
    func scaleFromImage(size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
