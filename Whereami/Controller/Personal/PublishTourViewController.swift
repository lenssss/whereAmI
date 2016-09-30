//
//  PublishTourViewController.swift
//  Whereami
//
//  Created by A on 16/4/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import SVProgressHUD
import DKImagePickerController

class PublishTourViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var tableView:UITableView? = nil
    var photoArray:[AnyObject]? = nil
    var photoRows:CGFloat? = nil
    var textView:UITextView? = nil
    var photoList:[AnyObject]? = nil
    
    var assets:[DKAsset]? = nil
    var isSuccess:Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfig()
        self.photoRows = ceil(CGFloat(self.photoArray!.count)/3.0)
        self.getPhoto()
        self.setUI()
        self.registerNotification()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func getPhoto(){
        var array = [UIImage]()
        for item in self.photoArray!{
            if item.isKindOfClass(UIImage){
                array.append(item as! UIImage)
            }
        }
        self.photoArray = array
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Publish", style: .Done, target: self, action: #selector(self.publishTour))
        
        self.tableView = UITableView()
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.separatorStyle = .None
        self.view.addSubview(self.tableView!)
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        
        self.tableView?.registerClass(PublishTourTextViewTableViewCell.self, forCellReuseIdentifier: "PublishTourTextViewTableViewCell")
        self.tableView?.registerClass(PublishTourPhotoCollectionTableViewCell.self, forCellReuseIdentifier: "PublishTourPhotoCollectionTableViewCell")
        self.tableView?.registerClass(PublishTravelCommonTableViewCell.self, forCellReuseIdentifier: "PublishTravelCommonTableViewCell")
    }
    
    func publishTour(){
        let currentUser = UserModel.getCurrentUser()
        
        self.photoList = [AnyObject]()
        for i in 0...(self.photoArray?.count)!-1 {
            let image = self.photoArray![i] as! UIImage
            let photoString = UIImageJPEGRepresentation(image, 1.0)
            self.photoList!.append(photoString!)
        }
        
        var dic = [String:AnyObject]()
        dic["userId"] = currentUser?.id
        dic["type"] = "jpg"
        dic["contents"] = self.photoList

        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SocketManager.sharedInstance.sendMsg("saveMutileImageFile", data: dic, onProto: "saveMutileImageFileed", callBack: { (code, objs) -> Void in
            if code == statusCode.Normal.rawValue {
                let files = objs[0]["files"] as! [String]
                var dic = [String:AnyObject]()
                dic["creatorId"] = UserModel.getCurrentUser()?.id
                dic["content"] = self.textView?.text
                dic["picList"] = files
                dic["ginwave"] = LocationManager.sharedInstance.currentLocation
                dic["ginwaveDes"] = LocationManager.sharedInstance.geoDes
                
                SocketManager.sharedInstance.sendMsg("createAFeed", data: dic, onProto: "createAFeeded", callBack: { (code, objs) -> Void in
                    if code == statusCode.Normal.rawValue {
                        print(objs)
                        self.runInMainQueue({
                            SVProgressHUD.showSuccessWithStatus("success")
                            self.isSuccess = true
                            self.performSelector(#selector(self.dismiss), withObject: self, afterDelay: 2)
                        })
                    }
                    else{
                        self.runInMainQueue({ 
                            SVProgressHUD.showErrorWithStatus("error")
                            self.performSelector(#selector(self.dismiss), withObject: self, afterDelay: 2)
                        })
                    }
                })
            }
        })
    }
    
    func registerNotification(){
        NSNotificationCenter.defaultCenter().rac_addObserverForName("didTouchAddButton", object: nil).subscribeNext { (notification) in
            let pickerController = DKImagePickerController()
            pickerController.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.getNavigationBarColor()), forBarMetrics: UIBarMetrics.Default)
            UINavigationBar.appearance().titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
            pickerController.maxSelectableCount = 9
            pickerController.showsCancelButton = true
            pickerController.assetType = .AllPhotos
            pickerController.defaultSelectedAssets = self.assets
            pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
                print("didSelectAssets")
                if assets.count != 0 {
                    self.assets = assets
                }
                else{
                    self.assets = nil
                }
            }
            pickerController.didCancel = { () in
                if self.assets != nil {
                    self.photoArray?.removeAll()
                    for asset in self.assets! {
                        asset.fetchFullScreenImageWithCompleteBlock({ (image, info) in
                            self.photoArray?.append(image!)
                            if self.photoArray?.count == self.assets?.count {
                                self.photoRows = ceil(CGFloat(self.photoArray!.count)/3.0)
                                self.tableView?.reloadData()
                            }
                        })
                    }
                }
            }
            self.presentViewController(pickerController, animated: true, completion: nil)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("PublishTourTextViewTableViewCell", forIndexPath: indexPath) as? PublishTourTextViewTableViewCell
                self.textView = cell!.textView
                cell!.textView!.becomeFirstResponder()
                return cell!
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("PublishTourPhotoCollectionTableViewCell", forIndexPath: indexPath) as? PublishTourPhotoCollectionTableViewCell
                cell!.photoArray = self.photoArray
                cell!.updateCollections()
                return cell!
            }
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("PublishTravelCommonTableViewCell", forIndexPath: indexPath)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section==0 {
            if indexPath.row==0 {
                return 80
            }else {
                let screenW = UIScreen.mainScreen().bounds.width
                let photoWidth = (screenW-16*2-8*3)/4
                let totalHeight = (photoWidth+8)*photoRows!+8
                return totalHeight;
            }
        }
        else {
            return 44
        }
    }
    
    func dismiss(){
        SVProgressHUD.dismiss()
        if isSuccess == true {
            NSNotificationCenter.defaultCenter().postNotificationName("publishTour", object: nil)
            let index = self.navigationController?.viewControllers.count
            let viewController = self.navigationController?.viewControllers[index!-2] as! TourRecordsViewController
            self.navigationController?.popToViewController(viewController, animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.textView?.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
