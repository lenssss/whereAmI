//
//  PublishTourPhotoCollectionTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
//import TZImagePickerController

class PublishTourPhotoCollectionTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var collectionView:UICollectionView? = nil
    var photoArray:[AnyObject]? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI(){
        self.backgroundColor = UIColor.clearColor()
        
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.contentView.bounds,collectionViewLayout: flowLayout)
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.scrollEnabled = false
        self.contentView.addSubview(self.collectionView!)
        
        self.collectionView?.registerClass(PersonalPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PersonalPhotoCollectionViewCell")
        
        self.collectionView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    func updateCollections(){
        self.collectionView?.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = self.photoArray else {
            
            return 0
        }
        
        if(photos.count == 9 ) {
            return 9
        }
        else {
            return photos.count+1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonalPhotoCollectionViewCell", forIndexPath: indexPath) as! PersonalPhotoCollectionViewCell
        if indexPath.row == self.photoArray?.count {
            cell.photoView?.image = UIImage(named: "plus")
        }
        else{
//            if self.photoArray![indexPath.row].isKindOfClass(UIImage) {
//                let image = self.photoArray![indexPath.row] as! UIImage
//                cell.photoView?.image = image
//            }
//            else{
//                TZImageManager().getPhotoWithAsset(self.photoArray![indexPath.row], completion: { (image, dic, bool) in
//                    cell.photoView?.image = image
//                })
//            }
            cell.photoView?.image = self.photoArray![indexPath.row] as? UIImage
        }
//        cell.photoView?.image = self.photoArray![indexPath.row] as? UIImage
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 16, 8, 16)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenW = UIScreen.mainScreen().bounds.width
        let photoWidth = (screenW-16*2-8*3)/4
        let size = CGSize(width: photoWidth,height: photoWidth)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.photoArray?.count {
            NSNotificationCenter.defaultCenter().postNotificationName("didTouchAddButton", object: collectionView)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
