//
//  GameMoreStatusViewController.swift
//  Whereami
//
//  Created by A on 16/5/10.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import MJRefresh
//import MBProgressHUD
import SVProgressHUD

class GameMoreStatusViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HHPanningTableViewCellDelegate {
    
    typealias theCallback = () -> Void
    
    var status:String? = nil
    var tableView:UITableView? = nil
    var battleList:BattleListModel? = nil
    var BattleDetailList:[BattleDetailModel]? = nil
    var page:Int? = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.respondsToSelector(Selector("automaticallyAdjustsScrollViewInsets")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if self.respondsToSelector(Selector("edgesForExtendedLayout")) {
            self.edgesForExtendedLayout = .None
        }
        self.BattleDetailList = [BattleDetailModel]()
        self.setUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        SVProgressHUD.show()
        self.getBattleList({
            SVProgressHUD.dismiss()
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: true)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(self.downLoadNewData))
        
        let footer = MJRefreshAutoNormalFooter()
        footer.stateLabel.hidden = true
        footer.refreshingTitleHidden = true
        footer.setRefreshingTarget(self, refreshingAction: #selector(self.upLoadNewData))

        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .None
        self.tableView?.mj_header = header
        self.tableView?.mj_footer = footer
        self.view.addSubview(self.tableView!)
        
        self.tableView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        
        self.tableView?.registerClass(GameStatusTableViewCell.self, forCellReuseIdentifier: "GameStatusTableViewCell")
    }
    
    func downLoadNewData(){
        self.page = 1
        self.getBattleList ({
            self.BattleDetailList?.removeAll()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.BattleDetailList != nil {
            return (self.BattleDetailList?.count)!
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GameStatusTableViewCell", forIndexPath: indexPath) as! GameStatusTableViewCell
        let model = self.BattleDetailList![indexPath.row]
        cell.selectionStyle = .None
        UserManager.sharedInstance.getUserByIdWithBlock(model.launchId!, completition: { (user) in
            let avatar = user.headPortraitUrl != nil ? user.headPortraitUrl:""
            cell.avatar?.kf_setImageWithURL(NSURL(string:avatar!)!, placeholderImage: UIImage(named: "avator.png"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        })
        cell.levelBadge?.text = "\(Int(model.launchleve!))"
        cell.username?.text = model.launch
        cell.missionDescription?.text = model.battleTitle
        cell.timeDescription?.text = model.battleType
        cell.score?.text = model.scoreDetail
        
        cell.delegate = self
        cell.directionMask = HHPanningTableViewCellDirectionLeft
        cell.shadowViewEnabled = false
        
        if self.status == "myturn" || self.status == "valid"{
            cell.drawerView = self.rightSlideView(3,section:indexPath.section,row:indexPath.row)
        }else {
            cell.drawerView = self.rightSlideView(section:indexPath.section,row:indexPath.row)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.BattleDetailList![indexPath.row]
        let battleId = model.battleId
        
        if self.status == "myturn" {
            let alertController = UIAlertController(title: "", message: NSLocalizedString("enter",tableName:"Localizable", comment: ""), preferredStyle: .Alert)
            let confirmAction = UIAlertAction(title: NSLocalizedString("go",tableName:"Localizable", comment: ""), style: .Default, handler:{(UIAlertAction) -> Void in
                if model.battleType == "challengeFri" || model.battleType == "challengeRan" {
                    self.presentToPlayRoomVC(battleId!)
                }
                else{
                    self.presentToBattleDetailsVC(battleId!)
                }
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("later",tableName:"Localizable", comment: ""), style: .Cancel, handler: {(UIAlertAction) -> Void in
                self.getBattleList({ 
                    
                })
                self.tableView?.reloadData()
            })
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if self.status == "end" {
            let viewController = GameEndGameViewController()
            viewController.battleId = battleId
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func upLoadNewData(){
        if self.battleList != nil{
            if self.page! <= self.battleList?.allPage as! Int {
                self.getBattleList({
                    
                })
            }
            else{
                self.tableView?.mj_footer.endRefreshing()
            }
        }
        else{
            self.tableView?.mj_footer.endRefreshing()
        }
    }
    
    func getBattleList(block:theCallback){
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        dict["page"] = self.page
        dict["type"] = self.status
        
        SocketManager.sharedInstance.sendMsg("queryBattleList", data: dict, onProto: "queryBattleListed") { (code, objs) in
            if code == statusCode.Normal.rawValue{
                self.runInMainQueue({ 
                    block()
                })
                let battleArray = objs[0]["rets"] as! [AnyObject]
                let dic = battleArray[0]["datas"]
                self.battleList = BattleListModel.getModelFromDictionary(dic)
                let battleList = self.battleList!.result as? [BattleDetailModel]
                for item in battleList!{
                    self.BattleDetailList?.append(item)
                }
                self.page = self.page! + 1
                self.runInMainQueue({
                    self.tableView?.reloadData()
                    self.tableView?.mj_header.endRefreshing()
                    self.tableView?.mj_footer.endRefreshing()
                })
            }
        }
    }
    
    func presentToBattleDetailsVC(battleId:String){
        var dict = [String: AnyObject]()
        dict["battleId"] = battleId
        dict["accountId"] = UserModel.getCurrentUser()?.id
        SocketManager.sharedInstance.sendMsg("startBattle", data: dict, onProto: "startBattleed", callBack: { (code, objs) in
            if code == statusCode.Normal.rawValue {
                if objs[0]["problemId"] as! String != "" {
                    let matchDetailModel = MatchDetailModel.getModelFromDictionary(objs[0] as! [String : AnyObject])
                    self.runInMainQueue({
                        let battleDetailsVC = GameClassicBattleDetailsViewController()
                        battleDetailsVC.matchDetailModel = matchDetailModel
                        battleDetailsVC.hidesBottomBarWhenPushed = true
                        let nav = GameMainNavigationViewController(rootViewController: battleDetailsVC)
                        let window = UIApplication.sharedApplication().keyWindow?.rootViewController
                        window!.presentViewController(nav, animated: true, completion: nil)
                    })
                }
            }
        })
    }
    
    func presentToPlayRoomVC(battleId:String){
        var dict = [String: AnyObject]()
        dict["battleId"] = battleId
        dict["accountId"] = UserModel.getCurrentUser()?.id
        SocketManager.sharedInstance.sendMsg("startBattle", data: dict, onProto: "startBattleed", callBack: { (code, objs) in
            
            print(objs)
            if code == statusCode.Normal.rawValue {
                if objs[0]["problemId"] as! String != "" {
                    var dict = [String: AnyObject]()
                    dict["battleId"] = objs[0]["battleId"]
                    dict["questionId"] = objs[0]["problemId"]
                    
                    SocketManager.sharedInstance.sendMsg("queryProblemById", data: dict, onProto: "queryProblemByIded") { (code, objs) in
                        let battleModel = BattleModel.getModelFromDictionary(objs[0] as! NSDictionary)
                        self.runInMainQueue({
                            let playRoomVC = GameQuestionPlayRoomViewController()
                            playRoomVC.battleModel = battleModel
                            playRoomVC.hidesBottomBarWhenPushed = true
                            let nav = GameMainNavigationViewController(rootViewController: playRoomVC)
                            self.presentViewController(nav, animated: true, completion: nil)
                        })
                    }
                }
            }
        })
    }
    
    func rightSlideView(totalView:Int = 4,section:Int,row:Int) ->UIView {
        let view:UIView = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 100)
        view.backgroundColor = UIColor.clearColor()
        for i in 0..<totalView {
            let buttonWidth = UIScreen.mainScreen().bounds.width / CGFloat(totalView)
            let slideItemView:SlideItemView = SlideItemView(frame: CGRect(x: CGFloat(i) * buttonWidth, y: 0, width: buttonWidth, height: 100))
            slideItemView.row = row
            slideItemView.section = section
            let tapGesture = UITapGestureRecognizer()
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            
            slideItemView.addGestureRecognizer(tapGesture)
            
            view.addSubview(slideItemView)
            
            if i == 0 {
                slideItemView.viewDescription!.text = NSLocalizedString("Delete",tableName:"Localizable",comment: "")
                slideItemView.viewIcon!.image = UIImage(named:"new_game_scroll_giveup");
                tapGesture.addTarget(self, action: #selector(GameMainViewController.deleteGameStatusItem(_:)))
            } else if i == 1 {
                slideItemView.viewDescription!.text = NSLocalizedString("Chat",tableName:"Localizable",comment: "")
                slideItemView.viewIcon!.image = UIImage(named:"new_game_scroll_chat")
                tapGesture.addTarget(self, action: #selector(GameMainViewController.chatGameStatusItem(_:)))
            } else if i == 2 {
                slideItemView.viewDescription!.text = NSLocalizedString("Personal",tableName:"Localizable", comment: "")
                slideItemView.viewIcon!.image = UIImage(named:"new_game_scroll_personal")
                tapGesture.addTarget(self, action: #selector(GameMainViewController.personalGameStatusItem(_:)))
            } else if i == 3 {
                slideItemView.viewDescription!.text = NSLocalizedString("Again",tableName:"Localizable", comment: "")
                slideItemView.viewIcon!.image = UIImage(named:"new_game_scroll_again")
                tapGesture.addTarget(self, action: #selector(GameMainViewController.againGameStatusItem(_:)))
            }
        }
        return view
    }
    
    func deleteGameStatusItem(tapGesture:UITapGestureRecognizer) {
        let slideItemView:SlideItemView = tapGesture.view as! SlideItemView
        print("delete section: \(slideItemView.section) row: \(slideItemView.row)")
        let model = self.BattleDetailList![slideItemView.row]
        var dict = [String: AnyObject]()
        dict["battleId"] = model.battleId
        dict["accountId"] = UserModel.getCurrentUser()?.id
        SocketManager.sharedInstance.sendMsg("quitBattle", data: dict, onProto: "quitBattleed") { (code, objs) in
            if code == statusCode.Normal.rawValue {
                self.runInMainQueue({
                    self.BattleDetailList?.removeAtIndex(slideItemView.row)
                    self.tableView?.reloadData()
                })
            }
            else if code == 100 {
                self.runInMainQueue({
//                    self.getBattleList({
//                        
//                    })
//                    self.tableView?.reloadData()
                })
            }
        }
    }
    
    func chatGameStatusItem(tapGesture:UITapGestureRecognizer) {
        let slideItemView:SlideItemView = tapGesture.view as! SlideItemView
        print("chat section: \(slideItemView.section) row: \(slideItemView.row)")
    }
    
    func personalGameStatusItem(tapGesture:UITapGestureRecognizer) {
        let slideItemView:SlideItemView = tapGesture.view as! SlideItemView
        print("personal section: \(slideItemView.section) row: \(slideItemView.row)")
    }
    
    func againGameStatusItem(tapGesture:UITapGestureRecognizer) {
        let slideItemView:SlideItemView = tapGesture.view as! SlideItemView
        print("again section: \(slideItemView.section) row: \(slideItemView.row)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
