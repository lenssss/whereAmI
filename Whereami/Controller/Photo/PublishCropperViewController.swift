//
//  PublishCropperViewController.swift
//  Whereami
//
//  Created by A on 16/5/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import BABCropperView
import PureLayout
//import MBProgressHUD
import SVProgressHUD

class PublishCropperViewController: UIViewController {
    
    let screenH = UIScreen.mainScreen().bounds.height
    let screenW = UIScreen.mainScreen().bounds.width
    
    var photoImage:UIImage? = nil
    var cropperView:BABCropperView? = nil
    var type:editType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func setUI(){
        self.cropperView = BABCropperView()
        self.cropperView?.image = photoImage
        self.cropperView!.cropSize = CGSize(width: screenW,height: screenW)
        self.cropperView!.cropsImageToCircle = false
        self.view.addSubview(self.cropperView!)
        
        self.cropperView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        
        let button = UIButton()
        button.setTitle("next", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            self.cropperView?.renderCroppedImage({ (image, rect) in
                self.runInMainQueue({
                    if self.type == editType.avator {
                        self.updateAvator(image)
                    }
                    else{
                        self.push2FilterViewController(image)
                    }
                })
            })
        }
        self.view.addSubview(button)
        
        button.autoPinEdgeToSuperviewEdge(.Bottom)
        button.autoPinEdgeToSuperviewEdge(.Right)
        button.autoSetDimensionsToSize(CGSize(width: 100,height: 100))
    }
    
    func push2FilterViewController(image:UIImage){
        let viewController = PhotoEditingViewController()
        viewController.photoImage = image
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func updateAvator(image:UIImage){
        let currentUser = UserModel.getCurrentUser()
        
//        var dic = [String:AnyObject]()
//        dic["accountId"] = currentUser?.id
//        dic["headPortrait"] = image.image2String()
//        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hub.opacity = 0.2
//        SocketManager.sharedInstance.sendMsg("accountUpdate", data: dic, onProto: "accountUpdateed") { (code, objs) in
//            if code == statusCode.Normal.rawValue {
//                self.runInMainQueue({
//                    currentUser?.headPortraitUrl = image.image2String()
//                    CoreDataManager.sharedInstance.increaseOrUpdateUser(currentUser!)
//                    NSNotificationCenter.defaultCenter().postNotificationName("KNotificationChangeAvatar", object: image)
//                    MBProgressHUD.hideHUDForView(self.view, animated: true)
//                })
//            }
//        }
//        self.dismissViewControllerAnimated(true, completion: nil)
        
        var dic = [String:AnyObject]()
        dic["userId"] = currentUser?.id
        dic["type"] = "jpg"
        dic["content"] = UIImageJPEGRepresentation(image, 1.0)
        
        self.runInMainQueue {
            SVProgressHUD.show()
        }
        
        SocketManager.sharedInstance.sendMsg("uploadImageFile", data: dic, onProto: "uploadImageFileed", callBack: { (code, objs) -> Void in
            if code == statusCode.Normal.rawValue {
                let file = objs[0]["file"] as! String
                var dict = [String:AnyObject]()
                dict["accountId"] = currentUser?.id
                dict["headPortrait"] = file
                SocketManager.sharedInstance.sendMsg("accountUpdate", data: dict, onProto: "accountUpdateed") { (code, objs) in
                    self.runInMainQueue({ 
                        if code == statusCode.Normal.rawValue {
                            currentUser?.headPortraitUrl = file
                            CoreDataManager.sharedInstance.increaseOrUpdateUser(currentUser!)
                            NSNotificationCenter.defaultCenter().postNotificationName("KNotificationChangeAvatar", object: image)
                            SVProgressHUD.dismiss()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        else{
                            self.uploadErrorAction()
                        }
                    })
                }
            }
            else{
                self.runInMainQueue({ 
                    self.uploadErrorAction()
                })
            }
        })
    }
    
    func uploadErrorAction(){
        SVProgressHUD.showErrorWithStatus("upload error")
        self.performSelector(#selector(self.dismissVC), withObject: nil, afterDelay: 2)
    }
    
    func dismissVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
