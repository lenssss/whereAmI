//
//  RankBarView.swift
//  Whereami
//
//  Created by WuQifei on 16/2/18.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import UIKit
import PureLayout
public protocol RankBarViewDelegate :NSObjectProtocol {
    func tapedOnIndex(index:Int)
}

class RankBarView: UIView {

    private var horLineView:UIView? = nil
    
    private var cityLabel:UILabel? = nil
    private var allLabel:UILabel? = nil
    private var personalLabel:UILabel? = nil
    private var horLineleftConstraints:NSLayoutConstraint? = nil
    var delegate:RankBarViewDelegate? = nil
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    
    func horlinePostion(offset:CGFloat) {
        let baseWidth = UIScreen.mainScreen().bounds.width
        let offsetTimes = Int(offset/baseWidth)
        self .horLineMoved(offsetTimes)
        
    }
    
    func horLineMoved(offsetTime:Int) {
        let baseWidth = UIScreen.mainScreen().bounds.width
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.horLineleftConstraints!.constant = 10 + CGFloat(offsetTime) * baseWidth/3.0
        })
    }
    
    func setupUI() {
        self.backgroundColor = UIColor(red: 71/255.0, green: 95/255.0, blue: 161/255.0, alpha: 1.0)
        
        self.cityLabel = UILabel()
        self.allLabel = UILabel()
        self.personalLabel = UILabel()
        
        self.cityLabel?.textAlignment = .Center
        self.cityLabel?.text = NSLocalizedString("cityRank",tableName:"Localizable", comment: "WORLD RANK")
        self.cityLabel?.font = UIFont.systemFontOfSize(13.0)
        self.cityLabel?.textColor = UIColor.whiteColor()
        
        self.allLabel?.textAlignment = .Center
        self.allLabel?.text = NSLocalizedString("allRank",tableName:"Localizable", comment: "WORLD RANK")
        self.allLabel?.font = UIFont.systemFontOfSize(13.0)
        self.allLabel?.textColor = UIColor.whiteColor()
        
        self.personalLabel?.textAlignment = .Center
        self.personalLabel?.text = NSLocalizedString("personalRank",tableName:"Localizable", comment: "WORLD RANK")
        self.personalLabel?.font = UIFont.systemFontOfSize(13.0)
        self.personalLabel?.textColor = UIColor.whiteColor()
        
        self.horLineView = UIView()
        self.horLineView?.backgroundColor = UIColor.redColor()
        
        self.addSubview(self.cityLabel!)
        self.addSubview(self.allLabel!)
        self.addSubview(self.personalLabel!)
        self.addSubview(self.horLineView!)
        
        let verLineView1 = UIView()
        verLineView1.backgroundColor = UIColor.whiteColor()
        let verLineView2 = UIView()
        verLineView2.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(verLineView1)
        self.addSubview(verLineView2)
        
        
        self.cityLabel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.cityLabel?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        self.cityLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        
        self.allLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        self.allLabel?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        
        self.personalLabel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        self.personalLabel?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
        self.personalLabel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        
        self.cityLabel?.autoMatchDimension(.Width, toDimension: .Width, ofView: self.allLabel!)
        self.cityLabel?.autoMatchDimension(.Width, toDimension: .Width, ofView: self.personalLabel!)
        
        verLineView1.autoSetDimension(.Width, toSize: 0.5)
        verLineView1.autoPinEdgeToSuperviewEdge(.Top, withInset: 3)
        verLineView1.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 3)
        
        verLineView2.autoSetDimension(.Width, toSize: 0.5)
        verLineView2.autoPinEdgeToSuperviewEdge(.Top, withInset: 3)
        verLineView2.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 3)
        
        self.cityLabel?.autoPinEdge(.Right, toEdge: .Left, ofView: verLineView1)
        
        self.allLabel?.autoPinEdge(.Left, toEdge: .Right, ofView: verLineView1)
        self.allLabel?.autoPinEdge(.Right, toEdge: .Left, ofView: verLineView2)
        
        self.personalLabel?.autoPinEdge(.Left, toEdge: .Right, ofView: verLineView2)
        
        horLineView!.autoSetDimension(.Height, toSize: 2)
        horLineView!.autoSetDimension(.Width, toSize: UIScreen.mainScreen().bounds.width/3.0-20)
        horLineleftConstraints = horLineView!.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        horLineView!.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 4)
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: #selector(RankBarView.tappedOnItem(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func tappedOnItem(tap:UITapGestureRecognizer) {
        if self.delegate == nil {
            return
        }
        let itemWidth = UIScreen.mainScreen().bounds.width/3.0
        let point = tap.locationInView(self)
        if point.x < itemWidth {
            self.delegate?.tapedOnIndex(0)
            self.horLineMoved(0)
        } else if point.x < itemWidth*2.0 {
            self.delegate?.tapedOnIndex(1)
            self.horLineMoved(1)
        } else {
            self.delegate?.tapedOnIndex(2)
            self.horLineMoved(2)
        }
        
    }
}
