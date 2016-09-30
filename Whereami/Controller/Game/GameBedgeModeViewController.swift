//
//  GameBedgeModeViewController.swift
//  Whereami
//
//  Created by A on 16/6/1.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class GameBedgeModeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        
        let getMyBtn = UIButton()
        getMyBtn.setTitle("获取徽章", forState: .Normal)
        getMyBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getMyBtn.backgroundColor = UIColor.yellowColor()
        getMyBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            let viewController = GameSelectBedgeViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        self.view.addSubview(getMyBtn)
        
        let getOtherBtn = UIButton()
        getOtherBtn.setTitle("赢取对方徽章", forState: .Normal)
        getOtherBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        getOtherBtn.backgroundColor = UIColor.yellowColor()
        getOtherBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            
        }
        self.view.addSubview(getOtherBtn)
        
        getMyBtn.autoPinEdgeToSuperviewEdge(.Left,withInset: 20)
        getMyBtn.autoPinEdgeToSuperviewEdge(.Bottom,withInset: 150)
        getMyBtn.autoSetDimensionsToSize(CGSize(width: 100,height: 40))
        
        getOtherBtn.autoPinEdgeToSuperviewEdge(.Right,withInset: 20)
        getOtherBtn.autoPinEdgeToSuperviewEdge(.Bottom,withInset: 150)
        getOtherBtn.autoSetDimensionsToSize(CGSize(width: 100,height: 40))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
