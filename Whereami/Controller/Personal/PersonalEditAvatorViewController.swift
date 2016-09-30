//
//  PersonalEditAvatorViewController.swift
//  Whereami
//
//  Created by A on 16/5/23.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import DKImagePickerController

public var KNotificationChangeAvatar: String { get{ return "KNotificationChangeAvatar"} }

class PersonalEditAvatorViewController: UIViewController {
    
    var backImageView:UIImageView? = nil
    var imageString:String? = nil
    var asset:DKAsset? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        
        self.title = NSLocalizedString("Avatar",tableName:"Localizable", comment: "")
        
        self.setUI()
        
        LNotificationCenter().rac_addObserverForName("KNotificationChangeAvatar", object: nil).subscribeNext { (notification) in
            let image = notification.object as! UIImage
            self.backImageView?.image = image
        }
    }
    
    func setUI(){
        self.view.backgroundColor = UIColor.blackColor()
        
        let backBtn = TheBackBarButton.initWithAction({
            self.pushBack()
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:  NSLocalizedString("next",tableName:"Localizable", comment: ""), style: .Done, target: self, action: #selector(self.presentImagePicker))
        
        self.backImageView = UIImageView()
        self.backImageView?.kf_setImageWithURL(NSURL(string:self.imageString!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        self.view.addSubview(self.backImageView!)
        
        self.backImageView?.autoCenterInSuperview()
        self.backImageView?.autoSetDimensionsToSize(CGSize(width: LScreenW,height: LScreenW))
    }
    
    func presentImagePicker(){
        let pickerController = DKImagePickerController()
        pickerController.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.getNavigationBarColor()), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        pickerController.singleSelect = true
        pickerController.maxSelectableCount = 1
        pickerController.assetType = .AllPhotos
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            self.asset = assets[0]
        }
        pickerController.didCancel = { () in
            if self.asset != nil {
                self.asset!.fetchFullScreenImageWithCompleteBlock({ (image, info) in
                    self.runInMainQueue({
                        self.asset = nil
                        self.performSelector(#selector(self.present2CropperViewController(_:)), withObject: image,afterDelay: 0.1)
                    })
                })
            }
        }
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func pushBack(){
        let viewControllers = self.navigationController?.viewControllers
        let index = (viewControllers?.count)! - 2
        let viewController = viewControllers![index]
        self.navigationController?.popToViewController(viewController, animated: false)
    }
    
    func present2CropperViewController(image:UIImage){
        let viewController = PublishCropperViewController()
        viewController.photoImage = image
        viewController.type = editType.avator
        let nav = PhotoMainNavigationViewController(rootViewController: viewController)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
