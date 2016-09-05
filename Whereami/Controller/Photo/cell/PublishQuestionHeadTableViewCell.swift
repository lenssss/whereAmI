//
//  PublishQuestionHeadTableViewCell.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/17.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout

class PublishQuestionHeadTableViewCell: UITableViewCell,UITextViewDelegate {
    
    var selectedImageView:UIImageView?
    var textView:MessageTextView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        self.selectedImageView = UIImageView()
        self.selectedImageView?.contentMode = .ScaleAspectFill
        self.selectedImageView?.layer.masksToBounds = true
        self.selectedImageView?.layer.cornerRadius = 10.0
        self.contentView.addSubview(selectedImageView!)
        
        self.textView = MessageTextView()
        self.textView?.placeHolder = "Write your question..."
//        self.textView?.layer.borderWidth = 1.0
//        self.textView?.layer.borderColor = UIColor.lightGrayColor().CGColor
//        self.textView?.layer.cornerRadius = 5.0
        self.contentView.addSubview(self.textView!)
        
        self.selectedImageView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 30)
        self.selectedImageView?.autoPinEdgeToSuperviewEdge(.Left, withInset: 16)
        self.selectedImageView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 30)
        self.selectedImageView?.autoSetDimensionsToSize(CGSize(width: 100,height: 100))
        
        self.textView?.autoPinEdge(.Left, toEdge: .Right, ofView: self.selectedImageView!,withOffset: 10)
        self.textView?.autoPinEdgeToSuperviewEdge(.Top, withInset: 16)
        self.textView?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 16)
        self.textView?.autoPinEdgeToSuperviewEdge(.Right, withInset: 16)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textViewDidChange(textView: UITextView) {
        if (textView == self.textView) {
            if (textView.text.length > 250) {
                self.textView!.text = textView.text.substring(0, length: 250)
            }
        }
    }
}
