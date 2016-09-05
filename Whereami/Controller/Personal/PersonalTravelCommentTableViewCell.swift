//
//  PersonalTravelCommentTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/29.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalTravelCommentTableViewCell: UITableViewCell {
    
    var avatar:UIImageView? = nil
    var name:UILabel? = nil
    var time:UILabel? = nil
    var content:UILabel? = nil
    var contentConstraint:NSLayoutConstraint? = nil
    
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
        self.avatar = UIImageView()
        self.avatar?.image = UIImage(named: "avator.png")
        self.avatar?.layer.masksToBounds = true
        self.avatar?.layer.cornerRadius = 25
        self.contentView.addSubview(self.avatar!)
        
        self.name = UILabel()
        self.name?.font = UIFont.systemFontOfSize(15.0)
        self.name?.textAlignment = .Left
        self.name?.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(self.name!)
        
        self.time = UILabel()
        self.time?.font = UIFont.systemFontOfSize(12.0)
        self.time?.textAlignment = .Left
        self.time?.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(self.time!)
        
        self.content = UILabel()
        self.content?.textAlignment = .Left
        self.content?.numberOfLines = 0
        self.content?.lineBreakMode = .ByCharWrapping
        self.content?.textColor = UIColor.blackColor()
        self.contentView.addSubview(self.content!)
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line1)
        
        let line2 = UIView()
        line2.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line2)
        
        self.avatar?.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        self.avatar?.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        self.avatar?.autoSetDimensionsToSize(CGSize(width: 50,height: 50))
        
        self.name?.autoPinEdge(.Top, toEdge: .Top, ofView: self.avatar!)
        self.name?.autoPinEdge(.Left, toEdge: .Right, ofView: self.avatar!,withOffset: 10)
        self.name?.autoPinEdge(.Bottom, toEdge: .Top, ofView: self.time!)
        self.name?.autoSetDimension(.Width, toSize: 150)
        self.name?.autoMatchDimension(.Height, toDimension: .Height, ofView: self.time!)
        
        self.time?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.name!)
        self.time?.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: self.avatar!)
        self.time?.autoSetDimension(.Width, toSize: 300)
        
        self.content?.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.time!)
        self.content?.autoPinEdge(.Leading, toEdge: .Leading, ofView: self.name!)
        self.content?.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        self.content?.autoPinEdgeToSuperviewEdge(.Bottom,withInset: 10)
        self.contentConstraint = self.content?.autoSetDimension(.Height, toSize: 0)

        line1.autoPinEdgeToSuperviewEdge(.Top)
        line1.autoPinEdgeToSuperviewEdge(.Left,withInset: 10)
        line1.autoPinEdgeToSuperviewEdge(.Right,withInset: 10)
        line1.autoSetDimension(.Height, toSize: 0.5)
        
        line2.autoPinEdgeToSuperviewEdge(.Bottom)
        line2.autoPinEdgeToSuperviewEdge(.Left,withInset: 10)
        line2.autoPinEdgeToSuperviewEdge(.Right,withInset: 10)
        line2.autoSetDimension(.Height, toSize: 0.5)
    }
    
    class func heightForCell(content:String) -> CGFloat {
        let contentLabelW = UIScreen.mainScreen().bounds.width - 20
        let contentLabelH = (content as NSString).boundingRectWithSize(CGSize(width: contentLabelW,height: CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14.0)], context: nil).height + 10
        let height = 70 + ceil(contentLabelH)
        return height
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
