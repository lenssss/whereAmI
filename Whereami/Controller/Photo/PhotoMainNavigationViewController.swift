//
//  PhotoMainNavigationViewController.swift
//  Whereami
//
//  Created by WuQifei on 16/2/17.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PhotoMainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.backgroundColor = UIColor.blackColor()
        self.navigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.blackColor()), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage.imageWithColor(UIColor.clearColor())
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColor.whiteColor()
//        self.navigationBar.translucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.customFontWithStyle("Bold", size:18.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()]
        // Do any additional setup after loading the view.
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
