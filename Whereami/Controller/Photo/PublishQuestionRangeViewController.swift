//
//  PublishQuestionRangeViewController.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/21.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PublishQuestionRangeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var questionModel:QuestionModel?
    var tableView:UITableView?
    var rangeList:[CountryModel]?
    var nameArray:[String]?
    var codeArray:[String]?
    var selectedIndex:Int?
    var footerView:PublishQuestionRangeVCFooterView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rangeList = FileManager.sharedInstance.readCountryListFromFile()
        if rangeList != nil {
        self.nameArray = CountryModel.getNamesFromModels(rangeList!)
        self.codeArray = CountryModel.getCodesFromModels(rangeList!)
        }
        self.setUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(UITableViewCell.self , forCellReuseIdentifier: "PublishQuestionRangeViewCell")
        self.view.addSubview(tableView!)
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        self.footerView = PublishQuestionRangeVCFooterView()
        footerView!.ButtonCallback = {() -> Void in
            self.ConfirmButtonClick()
        }
        return footerView
    }
    
    func ConfirmButtonClick(){
        self.footerView?.confirmButton?.enabled = false
        if self.selectedIndex != nil {
            print(selectedIndex)
            self.questionModel!.countryName = nameArray![selectedIndex!]
            self.questionModel!.countryCode = codeArray![selectedIndex!]
            let dic = PhotoModel.getPhotoDictionaryFromQuestionModel(self.questionModel!)
            
//            let dict = QuestionModel.getPublishDictionaryFromQuestionModel(self.questionModel!)

            SocketManager.sharedInstance.sendMsg("uploadPhoto", data: dic!, onProto: "uploadPhotoed", callBack: { (code, objs) -> Void in
                print(objs)
                let pictureId = objs[0]["id"] as! String
                self.questionModel!.pictureId = pictureId
                let dict = QuestionModel.getPublishDictionaryFromQuestionModel(self.questionModel!)
                SocketManager.sharedInstance.sendMsg("uploadQueAndAns", data: dict!, onProto: "uploadQueAndAnsed", callBack: { (code, objs) -> Void in
                    print(objs)
                    if code == statusCode.Normal.rawValue {
                        let alertController = UIAlertController(title: "", message: NSLocalizedString("uploadSuccess",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
                        let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: { (confirmAction) in
                            self.navigationController?.popToRootViewControllerAnimated(true)
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                        alertController.addAction(confirmAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                })
            })
        }
        else{
            let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: NSLocalizedString("selectKind",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: nil)
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.selectedRange = nameArray![indexPath.row]
        self.selectedIndex = indexPath.row
        if self.footerView != nil {
            self.footerView?.confirmButton?.backgroundColor = UIColor(red: 32.0/255.0, green: 155.0/255.0, blue: 203.0/255.0, alpha: 1.0)
            self.footerView?.confirmButton?.enabled = true
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rangeList != nil {
            return (rangeList?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PublishQuestionRangeViewCell")
        if nameArray != nil {
            cell?.textLabel?.text = nameArray![indexPath.row]
        }
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
