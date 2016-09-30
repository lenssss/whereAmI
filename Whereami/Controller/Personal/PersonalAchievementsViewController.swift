//
//  PersonalAchievementsViewController.swift
//  Whereami
//
//  Created by A on 16/6/1.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import SVProgressHUD

class PersonalAchievementsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var collectionView:UICollectionView? = nil
    var AchievementList:[AccAchievement]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        
        self.title = NSLocalizedString("achievement",tableName:"Localizable", comment: "")
        
        self.setUI()
        self.getAccAchievement()
    }
    
    func getAccAchievement(){
        var dict = [String: AnyObject]()
        dict["accountId"] = UserModel.getCurrentUser()?.id
        
        SVProgressHUD.show()
        SocketManager.sharedInstance.sendMsg("queryAccAchievement", data: dict, onProto: "queryAccAchievemented") { (code, objs) in
            self.runInMainQueue({ 
                SVProgressHUD.dismiss()
            })
            if code == statusCode.Normal.rawValue{
                guard let arr = objs[0]["list"] as? [AnyObject] else{
                    return
                }
                let list = AccAchievements.getModelFromArray(arr)
                self.AchievementList = [AccAchievement]()
                for item in list! {
                    let achievements = item as AccAchievements
                    for achievement in achievements.list! {
                        self.AchievementList?.append(achievement)
                    }
                }
                self.runInMainQueue({ 
                    self.collectionView?.reloadData()
                })
            }
        }
    }
    
    func setUI(){
        let backBtn = TheBackBarButton.initWithAction({
            let viewControllers = self.navigationController?.viewControllers
            let index = (viewControllers?.count)! - 2
            let viewController = viewControllers![index]
            self.navigationController?.popToViewController(viewController, animated: false)
        })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRectZero,collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        self.view.addSubview(collectionView!)
        collectionView?.registerClass(PersonalAchievementsCollectionViewCell.self, forCellWithReuseIdentifier: "PersonalAchievementsCollectionViewCell")
        
        collectionView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (AchievementList != nil) else {
            return 0
        }
        return (AchievementList?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonalAchievementsCollectionViewCell", forIndexPath: indexPath) as! PersonalAchievementsCollectionViewCell
//        cell.itemName!.text = "\(indexPath.row)"
        let achievement = AchievementList![indexPath.row]
        let iconString = achievement.icons
        cell.itemName?.text = achievement.name
        cell.itemLogo?.image = UIImage.string2Image(iconString!)
        let reachFlag = achievement.reachFlag
        
        guard reachFlag != 1 else{
            cell.progressLabel?.text = "完成"
            return cell
        }
        
        let reachProgress = achievement.reachProgress
        guard reachProgress != nil && reachProgress?.count != 0 else{
            let numberProgress = "\(achievement.numProgress!)" + "/" + "\(achievement.reachNumber!)"
            cell.progressLabel?.text = numberProgress
            return cell
        }
        
        //待修改
//        var progressText = " "
        var num = 0
        for item in reachProgress! {
            let arr = item.split("@")
//            var isDel = "未完成"
            if arr[2] == "1" {
//                isDel = "已完成"
                num += 1
            }
//            let text = arr[1] + "(" + isDel + ")"
//            progressText += " " + text
        }
        let progressText = "\(num)" + "/" + "\((reachProgress?.count)! as Int)"
        cell.progressLabel?.text = progressText
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = ((collectionView.bounds.width))/4
        let size = CGSize(width: width,height: 130)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
