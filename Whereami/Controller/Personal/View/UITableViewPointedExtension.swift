//
//  UITableViewPointedExtension.swift
//  Whereami
//
//  Created by A on 16/5/18.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, withEvent: event)
        if result is UITableView {
            let view = result!.superview
            for item in (view?.subviews)! {

                if item is PersonalHeaderView {

                    if item is PersonalOtherHeaderView {
                        let headerView = item as! PersonalOtherHeaderView
                        let covertPointInSuperView = self.convertPoint(point, toView: view)
                        if headerView.pointInside(covertPointInSuperView, withEvent: event) {
                            let covertPoint = headerView.convertPoint(covertPointInSuperView, fromView: view)
                            if headerView.headerImageView!.frame.contains(covertPoint) {
                                return headerView.headerImageView!
                            }else if headerView.followingLabel!.frame.contains(covertPoint){
                                return headerView.followingLabel!
                            }else if headerView.followerLabel!.frame.contains(covertPoint){
                                return headerView.followerLabel!
                            }else if headerView.following!.frame.contains(covertPoint){
                                return headerView.following!
                            }else if headerView.follower!.frame.contains(covertPoint){
                                return headerView.follower!
                            }else if headerView.playButton!.frame.contains(covertPoint){
                                return headerView.playButton!
                            }else if headerView.chatButton!.frame.contains(covertPoint){
                                return headerView.chatButton!
                            }
                            return headerView
                        }
                    }
                    
                    let headerView = item as! PersonalHeaderView
                    let covertPointInSuperView = self.convertPoint(point, toView: view)
                    if headerView.pointInside(covertPointInSuperView, withEvent: event) {
                        let covertPoint = headerView.convertPoint(covertPointInSuperView, fromView: view)
                        if headerView.headerImageView!.frame.contains(covertPoint) {
                            return headerView.headerImageView!
                        }else if headerView.followingLabel!.frame.contains(covertPoint){
                            return headerView.followingLabel!
                        }else if headerView.followerLabel!.frame.contains(covertPoint){
                            return headerView.followerLabel!
                        }else if headerView.following!.frame.contains(covertPoint){
                            return headerView.following!
                        }else if headerView.follower!.frame.contains(covertPoint){
                            return headerView.follower!
                        }else if headerView.editButton!.frame.contains(covertPoint){
                            return headerView.editButton!
                        }
                        return headerView.backImageView!
                    }
                    
                }
            }
        }
        return result
    }
}