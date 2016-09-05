//
//  PublishQuestionViewController.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/17.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PublishQuestionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tableView:UITableView?
    var keyboardHidden:Bool?
    var selectedImage:UIImage?
    var contentCell:PublishQuestionContentTableViewCell?
    var headCell:PublishQuestionHeadTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.keyboardHidden = true
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil).subscribeNext { (notification) -> Void in
            self.keyboardWillShow(notification)
        }
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).subscribeNext { (notification) -> Void in
            self.keyboardWillHide(notification)
        }
    }
    
    func setUI(){
        self.title = NSLocalizedString("uploadQuestion",tableName:"Localizable", comment: "")
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("done",tableName:"Localizable", comment: ""), style: .Done, target: self, action: #selector(PublishQuestionViewController.doneMyQuestion))
        //self.navigationItem.rightBarButtonItem!.enabled = false
        let backBtn = TheBackBarButton.initWithAction({
            self.back2Root()
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView?.backgroundColor = UIColor.blackColor()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        self.tableView?.registerClass(PublishQuestionHeadTableViewCell.self, forCellReuseIdentifier: "PublishQuestionHeadTableViewCell")
        self.tableView?.registerClass(PublishQuestionContentTableViewCell.self, forCellReuseIdentifier: "PublishQuestionContentTableViewCell")
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PublishQuestionShareTableViewCell")
    }
    
    func back2Root(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneMyQuestion(){
        let questionMoel = QuestionModel()
        questionMoel.creator = UserModel.getCurrentUser()?.id
        questionMoel.questionPhoto = UIImageJPEGRepresentation(self.selectedImage!, 1.0)
        questionMoel.content = self.headCell?.textView?.text
        questionMoel.trueAnswer = self.contentCell?.trueAnswerTextField.text
        questionMoel.falseAnswer1 = self.contentCell?.wrongAnswerTextField1.text
        questionMoel.falseAnswer2 = self.contentCell?.wrongAnswerTextField2.text
        questionMoel.falseAnswer3 = self.contentCell?.wrongAnswerTextField3.text

        if questionMoel.content != "" && questionMoel.trueAnswer != "" && questionMoel.falseAnswer1 != "" && questionMoel.falseAnswer2 != "" && questionMoel.falseAnswer3 != ""{
            let alertController = UIAlertController()
            let publishAction = UIAlertAction(title: NSLocalizedString("uploadToPool",tableName:"Localizable", comment: ""), style: .Default) { (action) -> Void in
                let publishVC = PublishEditGameViewController()
                publishVC.questionModel = questionMoel
                self.navigationController?.pushViewController(publishVC, animated: true)
            }
            let shareAction = UIAlertAction(title: NSLocalizedString("uploadToFriends",tableName:"Localizable", comment: ""), style: .Default) { (action) -> Void in
                let publish2FriendVC = Publish2FriendViewController()
                publish2FriendVC.questionModel = questionMoel
                self.navigationController?.pushViewController(publish2FriendVC, animated: true)
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("cancel",tableName:"Localizable", comment: ""), style: .Cancel, handler: nil)
            alertController.addAction(publishAction)
            alertController.addAction(shareAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: NSLocalizedString("warning",tableName:"Localizable", comment: ""), message: NSLocalizedString("fill",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("ok",tableName:"Localizable", comment: ""), style: .Default, handler: nil)
            alertController.addAction(confirmAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }
    
// MARK: UIKeyboard Notification
    func keyboardWillShow(notification:AnyObject){
        let rect = (notification as! NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let y = rect.origin.y - 64
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        let subviews = self.contentCell?.contentView.subviews
        for sub in subviews! {
            if sub.isKindOfClass(UITextField.self) {
                let textField = sub as! UITextField
                if textField.isFirstResponder(){
                    let rect = textField.convertRect(textField.frame, toView: self.tableView)
                    if (rect.origin.y + rect.size.height + 15) > y {
                        self.tableView?.contentOffset = CGPoint(x: 0,y: -(y-(rect.origin.y + rect.size.height + 15))-64)
                    }
                }
            }
        }
        UIView.commitAnimations()
    }
    
    func keyboardWillHide(notification:AnyObject){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        self.tableView!.contentOffset = CGPoint(x: 0,y: 0)
        UIView.commitAnimations()
    }
    
// MARK: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 13
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        }
        else if indexPath.section == 1 {
            return 196
        }
        else{
            return 42
        }
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PublishQuestionHeadTableViewCell", forIndexPath: indexPath) as! PublishQuestionHeadTableViewCell
            cell.selectedImageView?.image = self.selectedImage
            cell.selectionStyle = .None
            self.headCell = cell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("PublishQuestionContentTableViewCell", forIndexPath: indexPath) as! PublishQuestionContentTableViewCell
            cell.selectionStyle = .None
            self.contentCell = cell
            return cell
        }
//        else{
//            let cell = tableView.dequeueReusableCellWithIdentifier("PublishQuestionShareTableViewCell", forIndexPath: indexPath)
//            cell.textLabel?.text = NSLocalizedString("share",tableName:"Localizable", comment: "")
//            cell.textLabel?.font = UIFont.systemFontOfSize(10)
//            cell.selectionStyle = .None
//            return cell
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
