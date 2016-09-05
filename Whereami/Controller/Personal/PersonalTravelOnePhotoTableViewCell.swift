//
//  PersonalTravelOnePhotoTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/27.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalTravelOnePhotoTableViewCell: UITableViewCell {
    
    typealias theCallback = () -> Void

    var avatar:UIImageView? = nil
    var name:UILabel? = nil
    var time:UILabel? = nil
    var location:UILabel? = nil
    var photoView:UIImageView? = nil
    var contentLabel:UILabel? = nil
    var comment:UILabel? = nil
    var likeLogo:UIButton? = nil
    var like:UIButton? = nil
    var photoId:String? = nil
    var feed:TravelModel? = nil
    var contentConstraint:NSLayoutConstraint? = nil
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
    
    func getPhoto(){
//        UIImage.setImageWithPhotoId(self.photoId!, index: nil, completion: { (image, index) in
//            self.runInMainQueue({
//                if image != nil {
//                    self.photoView?.image = image
//                }
//                else{
//                    self.photoView?.image = UIImage(named: "placeholder.jpg")
//                }
//            })
//        })        let imageUrl = self.photoId?.string2UrlString()
        let imageUrl = self.photoId
        self.photoView?.kf_setImageWithURL(NSURL(string: imageUrl!)!, placeholderImage: UIImage(named: "placeholder.jpg"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)

    }
    
    func setupUI(){
        let grayView = UIView()
        grayView.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
        self.contentView.addSubview(grayView)
        
        let tapUser = UITapGestureRecognizer()
        tapUser.numberOfTapsRequired = 1
        tapUser.addTarget(self, action: #selector(self.tapUserClick(_:)))
        
        self.avatar = UIImageView()
        self.avatar?.layer.masksToBounds = true
        self.avatar?.layer.cornerRadius = 20
        self.avatar?.userInteractionEnabled = true
        self.avatar?.addGestureRecognizer(tapUser)
        self.contentView.addSubview(self.avatar!)
        
        self.name = UILabel()
        self.name?.font = UIFont.systemFontOfSize(15.0)
        self.name?.textAlignment = .Left
        self.name?.textColor = UIColor.lightGrayColor()
        self.name?.addGestureRecognizer(tapUser)
        self.contentView.addSubview(self.name!)
        
//        let locationLogo = UIImageView()
//        locationLogo.image = UIImage(named: "location")
//        self.contentView.addSubview(locationLogo)
        
        self.location = UILabel()
        self.location?.textAlignment = .Left
        self.location?.font = UIFont.systemFontOfSize(12.0)
        self.location?.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(self.location!)
        
        self.time = UILabel()
        self.time?.font = UIFont.systemFontOfSize(12.0)
        self.time?.textAlignment = .Right
        self.time?.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(self.time!)
        
        let tapPhoto = UITapGestureRecognizer(target: self, action: #selector(self.tapPhotoClick(_:)))
        tapPhoto.numberOfTapsRequired = 1
        
        self.photoView = UIImageView()
        self.photoView?.userInteractionEnabled = true
        self.photoView?.contentMode = .ScaleAspectFill
        self.photoView?.layer.masksToBounds = true
//        self.photoView?.image = UIImage(named: "personal_back")
        self.photoView?.addGestureRecognizer(tapPhoto)
        self.contentView.addSubview(self.photoView!)
        
        self.contentLabel = UILabel()
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
        self.name?.autoSetDimension(.Width, toSize: 150)
        self.name?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.location!)
        
//        locationLogo.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.name!)
//        locationLogo.autoMatchDimension(.Width, toDimension: .Height, ofView: locationLogo)
//        locationLogo.autoPinEdge(.Right, toEdge: .Left, ofView: self.location!)
//        locationLogo.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!)
        
//        self.location?.autoPinEdge(.Top, toEdge: .Top, ofView: self.name!)
        self.location?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.name!)
        self.location?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!)
        self.location?.autoSetDimension(.Width, toSize: 150)
        
        self.time?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        self.time?.autoPinEdge(.Top, toEdge: .Top, ofView: self.name!)
        self.time?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.name!)
        self.time?.autoSetDimension(.Width, toSize: 150)
        
        self.photoView?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.avatar!,withOffset: 10)
        self.photoView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        self.photoView?.autoSetDimensionsToSize(CGSize(width: 200,height: 200))
        
        self.contentLabel?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.photoView!,withOffset: 10)
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
    
    func tapPhotoClick(tap:UITapGestureRecognizer){
        NSNotificationCenter.defaultCenter().postNotificationName("touchOnOnePhotoViewCell", object: self.photoId)
    }
    
    func tapUserClick(tap:UITapGestureRecognizer){
        NSNotificationCenter.defaultCenter().postNotificationName("touchUser", object: self.creatorId)
    }
    
    class func heightForCell(content:String) -> CGFloat {
        let contentLabelW = UIScreen.mainScreen().bounds.width - 20
        let contentLabelH = (content as NSString).boundingRectWithSize(CGSize(width: contentLabelW,height: CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14.0)], context: nil).height + 10
        let height = 350 + ceil(contentLabelH)
        return height
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
