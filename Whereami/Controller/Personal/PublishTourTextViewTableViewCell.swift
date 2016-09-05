//
//  PublishTourTextViewTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/28.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PublishTourTextViewTableViewCell: UITableViewCell {

    var textView:UITextView? = nil
    
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
        self.textView = MessageTextView()
        self.textView?.layer.borderWidth = 1.0
        self.textView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.textView?.layer.cornerRadius = 5.0
//        self.textView?.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(self.textView!)
        
        self.textView!.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(5, 16, 5, 16))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
