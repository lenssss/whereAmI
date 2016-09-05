//
//  PicDownloadManager.swift
//  Whereami
//
//  Created by A on 16/6/3.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PicDownloadManager: NSObject {
    typealias theCallback = (UIImage?) -> Void
    
    private static var instance:PicDownloadManager? = nil
    private static var onceToken:dispatch_once_t = 0
    private var picArray:[PhotoModel]? = []
    
    class var sharedInstance: PicDownloadManager {
        dispatch_once(&onceToken) { () -> Void in
            instance = PicDownloadManager()
        }
        return instance!
    }
    
    func getPicById(photoId:String,complete:theCallback){
        let array = picArray?.filter({$0.id == photoId})
        if array?.count != 0 {
            let image = UIImage.string2Image(array![0].file!)
            complete(image!)
            return
        }
        
        let photoModel = CoreDataManager.sharedInstance.fetchPhotoById(photoId)
        if photoModel != nil {
            if photoModel?.file != nil{
                let content = photoModel!.file
                let image = UIImage.string2Image(content!)
                
                let arr = self.picArray?.filter({$0.id == photoId})
                if arr?.count == 0 {
                    self.picArray?.append(photoModel!)
                }
                
                complete(image!)
                return
            }
        }
        
        var dict = [String: AnyObject]()
        dict["id"] = photoId
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            SocketManager.sharedInstance.sendMsg("getPhotoByPhotoId", data: dict, onProto: "getPhotoByPhotoIded") { (code, objs) in
                if code == statusCode.Normal.rawValue {
                    let photoModel = PhotoModel.getPhotoModelFromDictionary(objs[0] as! NSDictionary)
                    CoreDataManager.sharedInstance.increasePhoto(photoModel!)
                    if photoModel?.file != nil{
                        let arr = self.picArray?.filter({$0.id == photoId})
                        if arr?.count == 0 {
                            self.picArray?.append(photoModel!)
                        }
                        self.getPicById(photoId, complete: complete)
                    }
                }
            }
        })
    }
}
