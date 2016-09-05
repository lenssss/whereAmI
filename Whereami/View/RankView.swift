
//
//  RankView.swift
//  Whereami
//
//  Created by WuQifei on 16/2/18.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
import ReactiveCocoa

class RankView: UIView , UIScrollViewDelegate,RankBarViewDelegate{
    
    private var onceToken:dispatch_once_t = 0

    var cityRankView:RankFullItemsView? = nil
    var allRankView:RankFullItemsView? = nil
    var personalRankView:RankFullItemsView? = nil
    
    var rankBarView:RankBarView? = nil
    
    
    var scrollView:UIScrollView? = nil
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(KNotificationMainViewDidShow, object: nil).subscribeNext {(obj) -> Void in
            dispatch_once(&self.onceToken) { () -> Void in
                self.setupUI()
            }
        }
        
    }
    
    func tapedOnIndex(index:Int) {
        
        self.scrollView?.scrollRectToVisible(CGRect(x: self.frame.width * CGFloat(index), y: 0, width: self.frame.width, height: self.frame.height - 45), animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        self.cityRankView = RankFullItemsView()
        self.cityRankView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height-45)
        self.allRankView = RankFullItemsView()
        self.allRankView?.frame = CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height-45)
        self.personalRankView = RankFullItemsView()
        self.personalRankView?.frame = CGRect(x: self.frame.width * 2, y: 0, width: self.frame.width, height: self.frame.height-45)
        
        self.rankBarView = RankBarView()
        self.rankBarView?.delegate = self
        self.addSubview(self.rankBarView!)
        
        self.rankBarView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        self.rankBarView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.rankBarView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        self.rankBarView?.autoSetDimension(.Height, toSize: 45)
        
        scrollView = UIScrollView()
        self.addSubview(self.scrollView!)
        self.scrollView?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.rankBarView!)
        self.scrollView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        self.scrollView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.scrollView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        self.scrollView?.contentSize = CGSize(width: self.frame.width * 3, height: self.frame.height-45)
        
        self.scrollView?.addSubview(self.cityRankView!)
        self.scrollView?.addSubview(self.allRankView!)
        self.scrollView?.addSubview(self.personalRankView!)
        self.scrollView?.delegate = self 
        
        scrollView?.pagingEnabled = true
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.scrollView!.showsVerticalScrollIndicator = false
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.rankBarView!.horlinePostion(scrollView.contentOffset.x)
    }
}
