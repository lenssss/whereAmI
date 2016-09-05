//
//  PersonalCollectionTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/26.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalCollectionTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView? = nil
    var photoIdArray:[String]? = nil
    var photoArray:[UIImage]? = nil
    
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
        self.backgroundColor = UIColor.lightGrayColor()
        
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.contentView.bounds,collectionViewLayout: flowLayout)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.scrollEnabled = false
        self.collectionView?.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(self.collectionView!)
        
        self.collectionView?.registerClass(PersonalPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PersonalPhotoCollectionViewCell")
        
        self.collectionView?.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.photoArray?.count != nil {
//            return (self.photoArray?.count)!
//        }
//        return 0
        if self.photoIdArray != nil{
            return (self.photoIdArray?.count)!
        }
        return 0
//        return 30
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonalPhotoCollectionViewCell", forIndexPath: indexPath) as! PersonalPhotoCollectionViewCell
//        cell.photoView?.image = UIImage(named: "temp_back")
//        cell.photoView?.image = self.photoArray![indexPath.row]
        let photoId = photoIdArray![indexPath.item]
        let imageUrl = photoId
        cell.photoView?.kf_setImageWithURL(NSURL(string: imageUrl)!, placeholderImage: UIImage(named: "placeholder.jpg"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.collectionView?.bounds.width)!/3
        let size = CGSize(width: width,height: width)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName("touchOnCollectionViewCell", object: indexPath.row,userInfo: ["photoes":self.photoIdArray!])
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
