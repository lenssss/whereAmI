//
//  GameSelectBedgeViewController.swift
//  Whereami
//
//  Created by A on 16/6/1.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class GameSelectBedgeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var titleLabel:UILabel? = nil
    var collectionView:UICollectionView? = nil
    var playBtn:UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConfig()
        
        self.setUI()
    }
    
    func setUI(){
        titleLabel = UILabel()
        titleLabel?.text = "choose the character you want"
        titleLabel?.textAlignment = .Center
        titleLabel?.textColor = UIColor.whiteColor()
        self.view.addSubview(titleLabel!)
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRectZero,collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        self.view.addSubview(collectionView!)
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        playBtn = UIButton()
        playBtn?.backgroundColor = UIColor.greenColor()
        playBtn?.setTitle("Play", forState: .Normal)
        playBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.view.addSubview(playBtn!)
        
        titleLabel?.autoPinEdgeToSuperviewEdge(.Top)
        titleLabel?.autoPinEdgeToSuperviewEdge(.Left,withInset: 16)
        titleLabel?.autoPinEdgeToSuperviewEdge(.Right,withInset: 16)
        titleLabel?.autoSetDimension(.Height, toSize: 70)
        
        collectionView?.autoPinEdgeToSuperviewEdge(.Left,withInset: 10)
        collectionView?.autoPinEdgeToSuperviewEdge(.Right,withInset: 10)
        collectionView?.autoAlignAxisToSuperviewAxis(.Horizontal)
        collectionView?.autoSetDimension(.Height, toSize: 250)
        
        playBtn?.autoPinEdgeToSuperviewEdge(.Bottom,withInset: 15)
        playBtn?.autoPinEdgeToSuperviewEdge(.Left,withInset: 20)
        playBtn?.autoPinEdgeToSuperviewEdge(.Right,withInset: 20)
        playBtn?.autoSetDimension(.Height, toSize: 40)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.greenColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (collectionView.bounds.width-30)/3
        let size = CGSize(width: width,height: 115)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
