//
//  PublishEditGameViewController.swift
//  Whereami
//
//  Created by A on 16/5/19.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
//import MBProgressHUD
import SVProgressHUD

class PublishEditGameViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var questionModel:QuestionModel? = nil
    var tableView:UITableView? = nil
    var classList:[GameKindModel]? = nil
    var classNameArray:[String]? = nil
    var classCodeArray:[String]? = nil
    var classIndex:Int? = 0
    var rangeList:[CountryModel]? = nil
    var rangeNameArray:[String]? = nil
    var rangeCodeArray:[String]? = nil
    var rangeIndex:Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getClassAndRange()
        self.setUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func setUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("done",tableName:"Localizable", comment: ""), style: .Done, target: self, action: #selector(PublishQuestionViewController.doneMyQuestion))
        
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(PublishEditGameViewCell.self , forCellReuseIdentifier: "PublishEditGameViewCell")
        self.tableView?.separatorStyle = .None
        self.tableView?.backgroundColor = UIColor.blackColor()
        self.view.addSubview(tableView!)
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            self.rangeIndex = indexPath.row
        }
        else{
            self.classIndex = indexPath.row
        }
        self.tableView?.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (rangeList?.count)!
        }
        else{
            return (classList?.count)!
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PublishEditGameViewCell") as! PublishEditGameViewCell
        cell.selectionStyle = .None
        if indexPath.section == 0 {
            cell.itemNameLabel?.text = rangeNameArray![indexPath.row]
            cell.selectImageView?.hidden = true
            if indexPath.row == self.rangeIndex {
                cell.selectImageView?.hidden = false
            }
        }
        else{
            cell.itemNameLabel?.text = classNameArray![indexPath.row]
            cell.selectImageView?.hidden = true
            if indexPath.row == self.classIndex {
                cell.selectImageView?.hidden = false
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UIView = UIView()
        view.backgroundColor = UIColor.blackColor()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40)
        let label:UILabel = UILabel(frame: CGRect(x: 14, y: 0, width: 300, height: 40))
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(14.0)
        view .addSubview(label)
        if section == 0 {
            label.text = "select the country in which"
            return view
        }else  if section == 1 {
            label.text = "Select a topic you want to publish"
            return view
        }
        return nil
    }
    
    func doneMyQuestion(){
        self.questionModel?.classificationCode = classCodeArray![classIndex!]
        self.questionModel?.classificationName = classNameArray![classIndex!]
        self.questionModel?.countryName = rangeNameArray![rangeIndex!]
        self.questionModel?.countryCode = rangeCodeArray![rangeIndex!]
        var dic = PhotoModel.getPhotoDictionaryFromQuestionModel(self.questionModel!)
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SocketManager.sharedInstance.sendMsg("uploadImageFile", data: dic!, onProto: "uploadImageFileed", callBack: { (code, objs) -> Void in
            if code == statusCode.Normal.rawValue {
                let pictureUrl = objs[0]["file"] as! String
                self.questionModel!.pictureUrl = pictureUrl
                dic = PhotoModel.getPhotoFromQuestionModel(self.questionModel!)
                SocketManager.sharedInstance.sendMsg("uploadPhoto", data: dic!, onProto: "uploadPhotoed", callBack: { (code, objs) -> Void in
                    print(objs)
                    let pictureId = objs[0]["id"] as! String
                    self.questionModel!.pictureId = pictureId
                    dic = QuestionModel.getPublishDictionaryFromQuestionModel(self.questionModel!)
                    SocketManager.sharedInstance.sendMsg("uploadQueAndAns", data: dic!, onProto: "uploadQueAndAnsed", callBack: { (code, objs) -> Void in
                        print(objs)
                        self.runInMainQueue({
                            if code == statusCode.Normal.rawValue {
//                            let alertController = UIAlertController(title: "", message: NSLocalizedString("uploadSuccess",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
//                            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (confirmAction) in
//                                self.dismissViewControllerAnimated(true, completion: nil)
//                            })
//                            alertController.addAction(confirmAction)
//                            self.presentViewController(alertController, animated: true, completion: nil)
                            SVProgressHUD.showSuccessWithStatus("success")                        }
                            else{
                                SVProgressHUD.showErrorWithStatus("error")
                            }
                            self.performSelector(#selector(self.dismiss), withObject: nil, afterDelay: 2)
                        })
                    })
                })
            }
        })
    }
    
    func getClassAndRange(){
        
        self.classList = FileManager.sharedInstance.readGameKindListFromFile()
        if classList != nil {
            self.classNameArray = GameKindModel.getNamesFromModels(classList!)
            self.classCodeArray = GameKindModel.getCodesFromModels(classList!)
        }
        else{
            self.classList = [GameKindModel]()
        }
        
        let ranges = FileManager.sharedInstance.readCountryListFromFile()
        if ranges != nil {
            self.rangeList = [CountryModel]()
            for item in ranges! {
                if item.countryOpened == 0 {
                    self.rangeList?.append(item)
                }
            }
            self.rangeNameArray = CountryModel.getNamesFromModels(rangeList!)
            self.rangeCodeArray = CountryModel.getCodesFromModels(rangeList!)
        }
        else{
            self.rangeList = [CountryModel]()
        }
    }
    
    func dismiss(){
        SVProgressHUD.dismiss()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
