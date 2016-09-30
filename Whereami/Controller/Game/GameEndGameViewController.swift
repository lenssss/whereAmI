//
//  GameEndGameViewController.swift
//  Whereami
//
//  Created by A on 16/4/8.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class GameEndGameViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var icon:UIImageView? = nil
    var tableView:UITableView? = nil
    var restartButton:UIButton? = nil
    
    var battleId:String? = nil //战斗id
    var battleEndModel:BattleEndModel? = nil //战斗结束模型
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfig()
        self.setUI()
        self.getBattleEndModel()
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        self.view.backgroundColor = UIColor.getGameColor()
        
        self.icon = UIImageView()
        self.icon?.backgroundColor = UIColor.whiteColor()
        self.icon?.layer.masksToBounds = true
        self.icon?.layer.cornerRadius = 40.0
        self.view.addSubview(self.icon!)
        
        self.tableView = UITableView()
        self.tableView?.separatorStyle = .None
        self.tableView?.backgroundColor = UIColor.clearColor()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        
        /*
        self.restartButton = UIButton()
        self.restartButton?.setTitle(NSLocalizedString("playAgain",tableName: "Localizable", comment: ""), forState: .Normal)
        self.restartButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.restartButton?.backgroundColor = UIColor.whiteColor()
        self.restartButton?.layer.cornerRadius = 10.0
        self.view.addSubview(self.restartButton!)
 */
        
        self.icon?.autoPinEdgeToSuperviewEdge(.Top, withInset: 50)
        self.icon?.autoAlignAxisToSuperviewAxis(.Vertical)
        self.icon?.autoSetDimensionsToSize(CGSize(width: 80,height: 80))
        
        self.tableView?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.icon!, withOffset: 30)
        self.tableView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.tableView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
//        self.tableView?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.restartButton!, withOffset: -20)
        self.tableView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: -80)
        
        /*
        self.restartButton?.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        self.restartButton?.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
        self.restartButton?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 20)
        self.restartButton?.autoSetDimension(.Height, toSize: 40)
 */
        
        self.tableView?.registerClass(GameEndGameTableViewCell.self, forCellReuseIdentifier: "GameEndGameTableViewCell")
    }
    
    func getBattleEndModel(){
        var dic = [String:AnyObject]()
        dic["battleId"] = self.battleId
        
        SocketManager.sharedInstance.sendMsg("getBattleDetails", data: dic, onProto: "getBattleDetailsed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                self.battleEndModel = BattleEndModel.getModelFromObject(objs)
                self.runInMainQueue({
                    self.title = self.battleEndModel?.type
                    self.tableView?.reloadData()
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if battleEndModel?.accounts != nil{
            return (battleEndModel?.accounts?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = battleEndModel?.accounts![indexPath.row] as! BattleEndDetailModel
        let cell = tableView.dequeueReusableCellWithIdentifier("GameEndGameTableViewCell", forIndexPath: indexPath) as! GameEndGameTableViewCell
        let user = CoreDataManager.sharedInstance.fetchUserById(model.accountId!)
        let avatarUrl = user?.headPortraitUrl != nil ? user?.headPortraitUrl:""
        cell.avatar?.kf_setImageWithURL(NSURL(string:avatarUrl!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        cell.chatName?.text = model.nickname
        cell.point?.text =  "\(model.score! as Int)"
        cell.time?.text = model.costtime
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = UIColor.whiteColor()
        
        let player = UILabel()
        player.text = NSLocalizedString("score",tableName: "Localizable", comment: "")
        headView.addSubview(player)
        
        let point = UILabel()
        point.text = NSLocalizedString("right",tableName: "Localizable", comment: "")
        point.textAlignment = .Center
        headView.addSubview(point)
        
        let time = UILabel()
        time.text = NSLocalizedString("time",tableName: "Localizable", comment: "")
        time.textAlignment = .Center
        headView.addSubview(time)
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGrayColor()
        headView.addSubview(lineView)
        
        player.autoPinEdgeToSuperviewEdge(.Left, withInset: 16.0)
        player.autoPinEdgeToSuperviewEdge(.Top)
        player.autoPinEdgeToSuperviewEdge(.Bottom)
        player.autoSetDimension(.Width, toSize: 100)
        
        point.autoPinEdgeToSuperviewEdge(.Top)
        point.autoPinEdgeToSuperviewEdge(.Bottom)
        point.autoPinEdge(.Right, toEdge: .Left, ofView: time)
        point.autoSetDimension(.Width, toSize: 40)
        
        time.autoPinEdgeToSuperviewEdge(.Right)
        time.autoPinEdgeToSuperviewEdge(.Top)
        time.autoPinEdgeToSuperviewEdge(.Bottom)
        time.autoSetDimension(.Width, toSize: 80)
        
        lineView.autoSetDimension(.Height, toSize: 0.7);
        lineView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0.5)
        lineView.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        lineView.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        return headView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

