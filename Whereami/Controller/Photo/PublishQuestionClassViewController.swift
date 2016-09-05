//
//  PublishQuestionClassViewController.swift
//  Whereami
//
//  Created by A on 16/4/12.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PublishQuestionClassViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var questionModel:QuestionModel? = nil
    var tableView:UITableView? = nil
    var classList:[GameKindModel]? = nil
    var nameArray:[String]? = nil
    var codeArray:[String]? = nil
    var selectedIndex:Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.classList = FileManager.sharedInstance.readGameKindListFromFile()
        if classList != nil {
            self.nameArray = GameKindModel.getNamesFromModels(classList!)
            self.codeArray = GameKindModel.getCodesFromModels(classList!)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("next",tableName:"Localizable", comment: ""), style: .Done, target: self, action: #selector(self.pushToNext))
        self.setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.registerClass(UITableViewCell.self , forCellReuseIdentifier: "PublishQuestionClassViewCell")
        self.view.addSubview(tableView!)
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func pushToNext(){
        if selectedIndex != nil {
            let viewController = PublishQuestionRangeViewController()
            viewController.questionModel = self.questionModel
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else{
            let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: NSLocalizedString("selectRange",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: nil)
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if classList != nil {
            return (classList?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.selectedRange = nameArray![indexPath.row]
        self.selectedIndex = indexPath.row
        self.questionModel?.classificationCode = codeArray![selectedIndex!]
        self.questionModel?.classificationName = nameArray![selectedIndex!]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PublishQuestionClassViewCell")
        if nameArray != nil {
            cell?.textLabel?.text = nameArray![indexPath.row]
        }
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
