//
//  GameReportViewController.swift
//  Whereami
//
//  Created by 陈鹏宇 on 16/9/1.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import SVProgressHUD

class GameReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView? = nil
    var problems:[String]? = nil
    var selectIndex:Int? = 0
    var problemId:String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Report"
        
        problems = ["Spelling or grammar","Wrong answer","Wrong category","Wrong region","Question is not clear","Repeated question","Spam","Other"]
        
        self.setUI()

        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "OK", style: .Done, target: self, action: #selector(self.report))
        
        tableView = UITableView()
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "problemCell")
        
        tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (problems?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("problemCell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.text = problems![indexPath.row]
        cell.textLabel?.textColor = UIColor.blackColor()
        if indexPath.row == selectIndex {
            cell.textLabel?.textColor = UIColor ( red: 0.1371, green: 0.5556, blue: 0.2859, alpha: 1.0 )
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectIndex = indexPath.row
        tableView.reloadData()
    }
    
    func report(){
        guard problemId != nil else {
            SVProgressHUD.setDefaultStyle(.Dark)
            SVProgressHUD.showErrorWithStatus("report error")
            return
        }
        
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["tips"] = problems![selectIndex!]
        dict["problemId"] = problemId
        SocketManager.sharedInstance.sendMsg("tipoffs", data: dict, onProto: "tipoffsed", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue {
                self.runInMainQueue({
                    SVProgressHUD.showSuccessWithStatus("report success")
                })
            }
        })
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
