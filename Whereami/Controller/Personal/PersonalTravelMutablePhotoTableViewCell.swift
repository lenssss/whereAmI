//
//  PersonalTravelMutablePhotoTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/27.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import MBProgressHUD

class PersonalTravelMutablePhotoTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout  {
    
    typealias theCallback = () -> Void
    
    var avatar:UIImageView? = nil
    var name:UILabel? = nil
    var time:UILabel? = nil
    var location:UILabel? = nil
    var collectonView:UICollectionView? = nil
    var contentLabel:UILabel? = nil
    var comment:UILabel? = nil
    var likeLogo:UIButton? = nil
    var like:UIButton? = nil
    var photoIdArray:[String]? = nil
    var photoArray:[UIImage]? = nil
    var contentConstraint:NSLayoutConstraint? = nil
    var photoConstraint:NSLayoutConstraint? = nil
    var digAction:theCallback? = nil
    var digListAction:theCallback? = nil
    var commentAction:theCallback? = nil
    var shareAction:theCallback? = nil
    var creatorId:String? = nil
    
    let contentLabelW = UIScreen.mainScreen().bounds.width - 20
    
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
    
    func getPhoto(photoIdArray:[String]) {
//        self.photoArray = [UIImage]()
//        for _ in 0...self.photoIdArray!.count-1 {
//            self.photoArray?.append(UIImage(named: "placeholder.jpg")!)
//        }
//        for i in 0...self.photoIdArray!.count-1 {
//            UIImage.setImageWithPhotoId(self.photoIdArray![i], index: i, completion: { (image, index) in
//                self.runInMainQueue({
//                    self.photoArray![index!] = image!
//                    self.collectonView?.reloadData()
//                })
//            })
//        }
        self.collectonView?.reloadData()
    }
    
    func setupUI(){
        let grayView = UIView()
        grayView.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
        self.contentView.addSubview(grayView)
        
        let tapUser = UITapGestureRecognizer()
        tapUser.numberOfTapsRequired = 1
        tapUser.addTarget(self, action: #selector(self.tapUserClick(_:)))
        
        self.avatar = UIImageView()
        self.avatar?.image = UIImage(named: "avator.png")
        self.avatar?.layer.masksToBounds = true
        self.avatar?.layer.cornerRadius = 20
        self.avatar?.userInteractionEnabled = true
        self.avatar?.addGestureRecognizer(tapUser)
        self.contentView.addSubview(self.avatar!)
        
        self.name = UILabel()
//        self.name?.text = "lens"
        self.name?.font = UIFont.systemFontOfSize(15.0)
        self.name?.textAlignment = .Left
        self.name?.textColor = UIColor.lightGrayColor()
        self.name?.addGestureRecognizer(tapUser)
        self.contentView.addSubview(self.name!)
        
//        let locationLogo = UIImageView()
//        locationLogo.image = UIImage(named: "location")
//        self.contentView.addSubview(locationLogo)
        
        self.location = UILabel()
        self.location?.text = "China"
        self.location?.textAlignment = .Left
        self.location?.font = UIFont.systemFontOfSize(12.0)
        self.location?.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(self.location!)
        
        self.time = UILabel()
        self.time?.font = UIFont.systemFontOfSize(12.0)
        self.time?.textAlignment = .Right
        self.time?.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(self.time!)
        
        let flowLayout = UICollectionViewFlowLayout()
        self.collectonView = UICollectionView(frame: CGRectZero,collectionViewLayout: flowLayout)
        self.collectonView?.dataSource = self
        self.collectonView?.delegate = self
        self.collectonView?.scrollEnabled = false
        self.collectonView?.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(self.collectonView!)
        self.collectonView?.registerClass(PersonalPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PersonalPhotoCollectionViewCell")
        
        self.contentLabel = UILabel()
//        self.contentLabel!.text = "Vestibulum ante ipsum primis in faucibus orci luctus et ultrices"
        self.contentLabel?.textAlignment = .Left
        self.contentLabel?.numberOfLines = 0
        self.contentLabel?.lineBreakMode = .ByCharWrapping
        self.contentLabel?.textColor = UIColor.blackColor()
        self.contentView.addSubview(self.contentLabel!)
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line)
        
        let commentLogo = UIButton()
        commentLogo.setBackgroundImage(UIImage(named: "icon_comment"), forState: .Normal)
        commentLogo.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            self.commentAction!()
        }
        self.contentView.addSubview(commentLogo)
        
        self.comment = UILabel()
//        self.comment?.text = "0"
        self.comment?.textAlignment = .Center
        self.comment?.textColor = UIColor.blackColor()
        self.contentView.addSubview(self.comment!)
        
        self.likeLogo = UIButton()
//        self.likeLogo?.setBackgroundImage(UIImage(named: "icon_comment"), forState: .Normal)
        likeLogo!.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            self.digAction!()
        }
        self.contentView.addSubview(likeLogo!)
        
        self.like = UIButton()
        self.like?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.like!.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
            self.digListAction!()
        }
        self.contentView.addSubview(self.like!)
        
//        let shareLogo = UIButton()
//        shareLogo.setBackgroundImage(UIImage(named: "icon_share"), forState: .Normal)
//        shareLogo.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (button) in
//            self.shareAction!()
//        }
//        self.contentView.addSubview(shareLogo)
        
        grayView.autoPinEdgeToSuperviewEdge(.Top)
        grayView.autoPinEdgeToSuperviewEdge(.Left)
        grayView.autoPinEdgeToSuperviewEdge(.Right)
        grayView.autoSetDimension(.Height, toSize:20)
        
        self.avatar?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        self.avatar?.autoPinEdge(.Top, toEdge: .Bottom, ofView: grayView, withOffset: 15)
        self.avatar?.autoSetDimensionsToSize(CGSize(width: 40,height: 40))
        
        self.name?.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar!)
        self.name?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!,withOffset: 10)
        self.name?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.location!)
        self.name?.autoSetDimensionsToSize(CGSize(width: 150,height: 20))
//        self.name?.autoSetDimension(.Width, toSize: 150)
//        self.name?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.location!)
        
//        locationLogo.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.name!)
//        locationLogo.autoMatchDimension(.Width, toDimension: .Height, ofView: locationLogo)
//        locationLogo.autoPinEdge(.Right, toEdge: .Left, ofView: self.location!)
//        locationLogo.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!)
        
//        self.location?.autoPinEdge(.Top, toEdge: .Top, ofView: self.name!)
        self.location?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.name!)
        self.location?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!)
        self.location?.autoSetDimensionsToSize(CGSize(width: 150,height: 20))
//        self.location?.autoSetDimension(.Width, toSize: 150)
        
        self.time?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        self.time?.autoPinEdge(.Top, toEdge: .Top, ofView: self.name!)
        self.time?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.name!)
        self.time?.autoSetDimension(.Width, toSize: 150)
        
        self.collectonView?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.avatar!,withOffset: 10)
        self.collectonView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        self.collectonView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        self.photoConstraint = self.collectonView?.autoSetDimension(.Height, toSize: 0)
        
        self.contentLabel?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.collectonView!,withOffset: 10)
        self.contentLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        self.contentLabel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        self.contentConstraint = self.contentLabel?.autoSetDimension(.Height, toSize: 0)
        
        line.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.contentLabel!,withOffset: 10)
        line.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        line.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        line.autoSetDimension(.Height, toSize: 0.5)
        
        commentLogo.autoPinEdge(.Top, toEdge: .Bottom, ofView: line,withOffset: 10)
        commentLogo.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        commentLogo.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        commentLogo.autoSetDimensionsToSize(CGSize(width: 20,height: 20))
        
        self.comment?.autoPinEdge(.Left, toEdge: .Right, ofView: commentLogo,withOffset: 10)
        self.comment?.autoPinEdge(.Top, toEdge: .Top, ofView: commentLogo)
        self.comment?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: commentLogo)
        self.comment?.autoSetDimension(.Width, toSize: 30)
        
        likeLogo?.autoPinEdge(.Top, toEdge: .Top, ofView: commentLogo)
        likeLogo?.autoPinEdge(.Left, toEdge: .Right, ofView: self.comment!,withOffset: 40)
        likeLogo?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: commentLogo)
        likeLogo?.autoSetDimensionsToSize(CGSize(width: 20,height: 20))
        
        self.like?.autoPinEdge(.Left, toEdge: .Right, ofView: likeLogo!,withOffset: 10)
        self.like?.autoPinEdge(.Top, toEdge: .Top, ofView: commentLogo)
        self.like?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: commentLogo)
        self.like?.autoSetDimension(.Width, toSize: 30)
        
//        shareLogo.autoPinEdge(.Top, toEdge: .Top, ofView: commentLogo)
//        shareLogo.autoPinEdge(.Left, toEdge: .Right, ofView: self.like!,withOffset: 40)
//        shareLogo.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: commentLogo)
//        shareLogo.autoSetDimensionsToSize(CGSize(width: 20,height: 20))
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.photoIdArray != nil{
            return (self.photoIdArray?.count)!
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonalPhotoCollectionViewCell", forIndexPath: indexPath) as! PersonalPhotoCollectionViewCell
        let photoId = photoIdArray![indexPath.item]
        let imageUrl = photoId
        cell.photoView?.kf_setImageWithURL(NSURL(string: imageUrl)!, placeholderImage: UIImage(named: "placeholder.jpg"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
//        cell.photoView?.setImageWithId(photoId)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = ((self.collectonView?.bounds.width)!)/3
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
    
    func tapUserClick(tap:UITapGestureRecognizer){
        NSNotificationCenter.defaultCenter().postNotificationName("touchUser", object: self.creatorId)
    }
    
    class func heightForCell(content:String, total:CGFloat) -> CGFloat {
        let contentLabelW = UIScreen.mainScreen().bounds.width - 20
        let contentLabelH = (content as NSString).boundingRectWithSize(CGSize(width: contentLabelW,height: CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14.0)], context: nil).height+10
        let num = ceil(total/3.0)
        let PhotoH = contentLabelW/3.0
        let height = 145+ceil(contentLabelH)+ceil(num*PhotoH)
        return height
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
