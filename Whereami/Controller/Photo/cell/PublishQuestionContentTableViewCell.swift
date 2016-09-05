//
//  PublishQuestionContentTableViewCell.swift
//  Whereami
//
//  Created by ChenPengyu on 16/3/17.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PublishQuestionContentTableViewCell: UITableViewCell,UITextFieldDelegate {

    var trueAnswerTextField = UITextField()
    var wrongAnswerTextField1 = UITextField()
    var wrongAnswerTextField2 = UITextField()
    var wrongAnswerTextField3 = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
        trueAnswerTextField.addTarget(self, action: #selector(self.editChange(_:)), forControlEvents: .EditingChanged)
        wrongAnswerTextField1.addTarget(self, action: #selector(self.editChange(_:)), forControlEvents: .EditingChanged)
        wrongAnswerTextField2.addTarget(self, action: #selector(self.editChange(_:)), forControlEvents: .EditingChanged)
        wrongAnswerTextField3.addTarget(self, action: #selector(self.editChange(_:)), forControlEvents: .EditingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
//        self.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.backgroundColor = UIColor.blackColor()
        
        trueAnswerTextField.layer.cornerRadius = 5.0
        wrongAnswerTextField1.layer.cornerRadius = 5.0
        wrongAnswerTextField2.layer.cornerRadius = 5.0
        wrongAnswerTextField3.layer.cornerRadius = 5.0
        
        trueAnswerTextField.placeholder = NSLocalizedString("trueAnswer",tableName:"Localizable", comment: "")
        wrongAnswerTextField1.placeholder = NSLocalizedString("wrongAnswer1",tableName:"Localizable", comment: "")
        wrongAnswerTextField2.placeholder = NSLocalizedString("wrongAnswer2",tableName:"Localizable", comment: "")
        wrongAnswerTextField3.placeholder = NSLocalizedString("wrongAnswer3",tableName:"Localizable", comment: "")

        trueAnswerTextField.backgroundColor = UIColor.greenColor()
        wrongAnswerTextField1.backgroundColor = UIColor.whiteColor()
        wrongAnswerTextField2.backgroundColor = UIColor.whiteColor()
        wrongAnswerTextField3.backgroundColor = UIColor.whiteColor()
        
        self.contentView.addSubview(trueAnswerTextField)
        self.contentView.addSubview(wrongAnswerTextField1)
        self.contentView.addSubview(wrongAnswerTextField2)
        self.contentView.addSubview(wrongAnswerTextField3)

        trueAnswerTextField.delegate = self
        wrongAnswerTextField1.delegate = self
        wrongAnswerTextField2.delegate = self
        wrongAnswerTextField3.delegate = self
        
        trueAnswerTextField.autoPinEdgeToSuperviewEdge(.Top, withInset: 4)
        trueAnswerTextField.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        trueAnswerTextField.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        wrongAnswerTextField1.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.trueAnswerTextField, withOffset: 4)
        wrongAnswerTextField1.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        wrongAnswerTextField1.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        wrongAnswerTextField2.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.wrongAnswerTextField1, withOffset: 4)
        wrongAnswerTextField2.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        wrongAnswerTextField2.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        wrongAnswerTextField3.autoPinEdge(.Top, toEdge: .Bottom, ofView: self.wrongAnswerTextField2, withOffset: 4)
        wrongAnswerTextField3.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        wrongAnswerTextField3.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        wrongAnswerTextField3.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 4)
        
        trueAnswerTextField.autoMatchDimension(.Height, toDimension: .Height, ofView: trueAnswerTextField)
        wrongAnswerTextField1.autoMatchDimension(.Height, toDimension: .Height, ofView: trueAnswerTextField)
        wrongAnswerTextField2.autoMatchDimension(.Height, toDimension: .Height, ofView: trueAnswerTextField)
        wrongAnswerTextField3.autoMatchDimension(.Height, toDimension: .Height, ofView: trueAnswerTextField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func editChange(textField:UITextField){
        if (textField.text!.length > 40) {
            textField.text = textField.text!.substring(0, length: 40)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
