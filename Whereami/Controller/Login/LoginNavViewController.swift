//
//  LoginNavViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/15.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class LoginNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationBar.backgroundColor = UIColor.getNavigationBarColor()
//        self.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor(red: 56.0/255.0, green: 151/255.0, blue: 207/255.0, alpha: 1.0)), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColor.getNavigationBarColor()
        self.navigationBar.translucent = true
        self.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(15.0),NSForegroundColorAttributeName:UIColor.whiteColor()]
        
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
