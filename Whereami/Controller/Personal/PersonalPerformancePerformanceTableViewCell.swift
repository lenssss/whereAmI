//
//  PersonalPerformancePerformanceTableViewCell.swift
//  Whereami
//
//  Created by A on 16/4/26.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit

class PersonalPerformancePerformanceTableViewCell: UITableViewCell {

    var wonNum:UILabel? = nil
    var lostNum:UILabel? = nil
    var resignedNum:UILabel? = nil
    
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
    
    func setupUI() {
        let grayView = UIView()
        grayView.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
        self.contentView.addSubview(grayView)
        
        let line1 = UIView()
        line1.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line1)
        
        let line2 = UIView()
        line2.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line2)
        
        let line3 = UIView()
        line3.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line3)
        
        let performanceLabel = UILabel()
        performanceLabel.text = NSLocalizedString("Performance",tableName:"Localizable", comment: "")
        performanceLabel.textAlignment = .Left
        performanceLabel.textColor = UIColor.blackColor()
        self.contentView.addSubview(performanceLabel)
        
        self.wonNum = UILabel()
        wonNum!.font = UIFont.boldSystemFontOfSize(34.0)
        wonNum!.textColor = UIColor(red: 137/255.0, green: 223/255.0, blue: 126/255.0, alpha: 1)
        wonNum!.textAlignment = .Center
        self.contentView.addSubview(wonNum!)
        
        let wonLabel = UILabel()
        wonLabel.textAlignment = .Center
        wonLabel.text = NSLocalizedString("won",tableName:"Localizable", comment: "")
        self.contentView.addSubview(wonLabel)
        
        self.lostNum = UILabel()
        lostNum!.font = UIFont.boldSystemFontOfSize(34.0)
        lostNum!.textColor = UIColor(red: 253/255.0, green: 121/255.0, blue: 126/255.0, alpha: 1)
        lostNum!.textAlignment = .Center
        self.contentView.addSubview(lostNum!)
        
        let lostLabel = UILabel()
        lostLabel.textAlignment = .Center
        lostLabel.text = NSLocalizedString("lost",tableName:"Localizable", comment: "")
        self.contentView.addSubview(lostLabel)
        
        self.resignedNum  = UILabel()
        resignedNum!.font = UIFont.boldSystemFontOfSize(34.0)
        resignedNum!.textColor = UIColor.orangeColor()
        resignedNum!.textAlignment = .Center
        self.contentView.addSubview(resignedNum!)
        
        let resignedLabel = UILabel()
        resignedLabel.textAlignment = .Center
        resignedLabel.text = NSLocalizedString("resigned",tableName:"Localizable", comment: "")
        self.contentView.addSubview(resignedLabel)
        
        let line4 = UIView()
        line4.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line4)
        
        let line5 = UIView()
        line5.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(line5)
        
        grayView.autoPinEdgeToSuperviewEdge(.Top)
        grayView.autoPinEdgeToSuperviewEdge(.Left)
        grayView.autoPinEdgeToSuperviewEdge(.Right)
        grayView.autoSetDimension(.Height, toSize: 20)
        
        line1.autoPinEdge(.Top, toEdge: .Bottom, ofView: grayView)
        line1.autoPinEdgeToSuperviewEdge(.Left)
        line1.autoPinEdgeToSuperviewEdge(.Right)
        line1.autoSetDimension(.Height, toSize: 1)
        
        performanceLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: line1)
        performanceLabel.autoPinEdgeToSuperviewEdge(.Left)
        performanceLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: line2)
        performanceLabel.autoSetDimensionsToSize(CGSize(width: 100,height: 50))
        
        line2.autoPinEdgeToSuperviewEdge(.Left)
        line2.autoPinEdgeToSuperviewEdge(.Right)
        line2.autoSetDimension(.Height, toSize: 1)
        line2.autoPinEdge(.Bottom, toEdge: .Top, ofView: wonNum!, withOffset: -15)
        
        let labelArray = [wonNum!,wonLabel,lostNum!,lostLabel,resignedNum!,resignedLabel] as NSArray
        labelArray.autoMatchViewsDimension(.Height)
        labelArray.autoMatchViewsDimension(.Width)
        
        wonNum!.autoPinEdgeToSuperviewEdge(.Left)
        wonNum!.autoPinEdge(.Bottom, toEdge: .Top, ofView: wonLabel)
        wonNum!.autoPinEdge(.Right, toEdge: .Left, ofView: lostNum!)
        
        wonLabel.autoPinEdgeToSuperviewEdge(.Left)
        wonLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: line3, withOffset: -15)
        wonLabel.autoPinEdge(.Right, toEdge: .Left, ofView: lostLabel)
        
        lostNum!.autoPinEdge(.Top, toEdge: .Top, ofView: wonNum!)
        lostNum!.autoPinEdge(.Right, toEdge: .Left, ofView: resignedNum!)
        lostNum!.autoPinEdge(.Bottom, toEdge: .Top, ofView: lostLabel)
        
        lostLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: line3, withOffset: -15)
        lostLabel.autoPinEdge(.Right, toEdge: .Left, ofView: resignedLabel)
        
        resignedNum!.autoPinEdge(.Top, toEdge: .Top, ofView: wonNum!)
        resignedNum!.autoPinEdgeToSuperviewEdge(.Right)
        resignedNum!.autoPinEdge(.Bottom, toEdge: .Top, ofView: resignedLabel)
        
        resignedLabel.autoPinEdge(.Bottom, toEdge: .Top, ofView: line3, withOffset: -15)
        resignedLabel.autoPinEdgeToSuperviewEdge(.Right)
        
        line3.autoPinEdgeToSuperviewEdge(.Left)
        line3.autoPinEdgeToSuperviewEdge(.Right)
        line3.autoPinEdgeToSuperviewEdge(.Bottom)
        line3.autoSetDimension(.Height, toSize: 1)
        
        line4.autoPinEdge(.Top, toEdge: .Top, ofView: wonNum!)
        line4.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: wonLabel)
        line4.autoPinEdge(.Left, toEdge: .Right, ofView: wonNum!)
        line4.autoSetDimension(.Width, toSize: 1)
        
        line5.autoPinEdge(.Top, toEdge: .Top, ofView: lostNum!)
        line5.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: lostLabel)
        line5.autoPinEdge(.Left, toEdge: .Right, ofView: lostNum!)
        line5.autoSetDimension(.Width, toSize: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
