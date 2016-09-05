//
//  ScrollBannersTableViewCell.swift
//  Whereami
//
//  Created by WuQifei on 16/2/18.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
//import SDWebImage
import ReactiveCocoa
import Kingfisher

public protocol BannerViewDelegate:NSObjectProtocol {
    func bannerViewDidClicked(index:Int)
}

class ScrollBannersTableViewCell: UITableViewCell,UIScrollViewDelegate {
    
    private var onceToken:dispatch_once_t = 0
    
    var delegate:BannerViewDelegate? = nil
    var imageURLs:[NSURL]? = nil
    var count:Int = 0
    var timerInterval:Int = 0
    var currentPageIndicatorTintColor:UIColor? = nil
    var pageIndicatorTintColor:UIColor? = nil
    var placeholderImage:String? = nil
    
    private var timer:NSTimer? = nil
    private var pageControl:UIPageControl? = nil
    private var bannerView:UIScrollView? = nil
    
    func viewInit(
        delegate:BannerViewDelegate,
        imageURLs:[NSURL],
        placeholderImage:String,
        timeInterval:Int,
        currentPageIndicatorTintColor:UIColor,
        pageIndicatorTintColor:UIColor) {
            
            self.delegate = delegate
            self.imageURLs = imageURLs
            self.count = imageURLs.count
            self.timerInterval = timeInterval
            self.currentPageIndicatorTintColor = currentPageIndicatorTintColor
            self.pageIndicatorTintColor = pageIndicatorTintColor
            self.placeholderImage = placeholderImage
            self.setupMainView()
            
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupMainView() {
        let scrollW = self.frame.size.width
        let scrollH = self.frame.size.height
        
        self.bannerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: scrollW, height: scrollH))
        for i in 0..<(self.count+2) {
            var tag = 0
            
            if i == 0 {
                tag = self.count
            } else if i == (self.count + 1) {
                tag = 1
            } else {
                tag = i
            }
            
            
            let imageView = UIImageView()
            imageView.tag = tag
            imageView.kf_setImageWithURL(self.imageURLs![tag - 1], placeholderImage: UIImage(named: self.placeholderImage!), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
            imageView.clipsToBounds = true
            imageView.userInteractionEnabled = true
            imageView.contentMode = UIViewContentMode.ScaleToFill
            imageView.frame = CGRect(x: scrollW * CGFloat(i), y: 0, width: scrollW, height: scrollH)
            self.bannerView?.addSubview(imageView)
            let tap = UITapGestureRecognizer(target: self, action: #selector(ScrollBannersTableViewCell.imageViewTaped(_:)))
            imageView.addGestureRecognizer(tap)
        }
        
        self.bannerView?.delegate = self
        self.bannerView?.scrollsToTop = false
        self.bannerView?.pagingEnabled = true
        self.bannerView?.showsHorizontalScrollIndicator = false
        self.bannerView?.contentOffset = CGPoint(x: scrollW, y: 0)
        self.bannerView?.contentSize = CGSize(width: CGFloat(self.count + 2) * scrollW, height: 0)
        
        self.contentView.addSubview(self.bannerView!)
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(KNotificationMainViewDidShow, object: nil).subscribeNext { (obj) -> Void in
            
            dispatch_once(&self.onceToken) { () -> Void in
                self.addTimer()
            }
        }
        
        self.pageControl = UIPageControl(frame: CGRect(x: 9, y: scrollH-10.0 - 10.0, width: scrollW, height: 10.0))
        self.pageControl?.numberOfPages = self.count
        self.pageControl?.userInteractionEnabled = false
        self.pageControl?.currentPageIndicatorTintColor  = self.currentPageIndicatorTintColor
        self.pageControl?.pageIndicatorTintColor = self.pageIndicatorTintColor
        
        self.contentView .addSubview(self.pageControl!)
        
    }
    
    func imageViewTaped(tap:UITapGestureRecognizer) {
        if ((self.delegate?.respondsToSelector(#selector(ScrollBannersTableViewCell.bannerViewDidClicked(_:)))) != nil) {
            self.delegate?.bannerViewDidClicked(tap.view!.tag-1)
        }
    }
    
    func bannerViewDidClicked(scrollView:UIScrollView){
        
    }
    
    func addTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(Double(self.timerInterval), target: self, selector: #selector(ScrollBannersTableViewCell.nextImage), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func removeTimer() {
        if (self.timer != nil) {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func nextImage() {
        let currentPage = self.pageControl?.currentPage
        self.bannerView?.setContentOffset(CGPoint(x: CGFloat(currentPage! + 2) * self.bannerView!.frame.size.width,y: 0), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollW = self.bannerView!.frame.size.width
        let currentPage = self.bannerView!.contentOffset.x / scrollW
        
        if(Int(currentPage) == self.count + 1)  {
            self.pageControl?.currentPage = 0
        }else if Int(currentPage) == 0 {
            self.pageControl?.currentPage = self.count
        }else {
            self.pageControl?.currentPage = Int(currentPage) - 1
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let scrollW = self.bannerView!.frame.width
        let currentPage = self.bannerView!.contentOffset.x / scrollW
        
        if Int(currentPage) == self.count + 1 {
            self.pageControl!.currentPage = 0
            self.bannerView!.setContentOffset(CGPoint(x: scrollW, y: 0), animated: false)
        }else if Int(currentPage)==0 {
            self.pageControl!.currentPage = self.count
            self.bannerView!.setContentOffset(CGPoint(x: CGFloat(self.count) * scrollW, y: 0), animated: false)
        }else {
            self.pageControl!.currentPage = Int(currentPage)  - 1;
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self .removeTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: KNotificationMainViewDidShow, object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
