//
//  ViewController.swift
//  wheelViewTest
//
//  Created by ChenPengyu on 16/3/8.
//  Copyright © 2016年 ChenPengYu. All rights reserved.
//

import UIKit
import PureLayout
import pop

class GameClassicWheelViewController: UIViewController {
    
    typealias theCallback = () -> Void
    
    var startValue:Float? = nil
    var endValue:Float? = nil
    var continent:String? = nil
    var rotateWheel:UIImageView? = nil
    var startButton:UIButton? = nil
    var startAction:theCallback? = nil
    var completion:theCallback? = nil
    
    var ScreenW:CGFloat = 0.0
    var ScreenH:CGFloat = 0.0
    
    let dataWithDegree = [ "宗教" : [["min":0,"max":60]] ,
                            "地标" : [["min":60,"max":120]],
                            "民俗" : [["min":120,"max":180]],
                            "主题":[["min":180,"max":240]],
                            "风景":[["min":240,"max":300]],
                            "细节":[["min":300,"max":360]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        
//        self.continent = "Europe"
        self.startValue = 0
        
        let rotationGesture = RotationGestureRecognizer()
        rotationGesture.addTarget(self, action: #selector(self.rotating(_:)))
        self.rotateWheel?.addGestureRecognizer(rotationGesture)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setUI(){
        ScreenW = self.view.bounds.size.width
        ScreenH = self.view.bounds.size.height
        
        self.rotateWheel = UIImageView()
        self.rotateWheel?.image = UIImage(named: "s_wheel")
        self.rotateWheel?.userInteractionEnabled = true
        self.rotateWheel?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(rotateWheel!)
        
        self.startButton = UIButton()
        self.startButton?.setBackgroundImage(UIImage(named: "pointer"), forState: .Normal)
        self.startButton?.setTitle(NSLocalizedString("play",tableName: "Localizable", comment: ""), forState: .Normal)
        self.startButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.startButton?.translatesAutoresizingMaskIntoConstraints=false
        self.view.addSubview(startButton!)
        
        self.rotateWheel?.autoPinEdgeToSuperviewEdge(.Left, withInset: 0)
        self.rotateWheel?.autoPinEdgeToSuperviewEdge(.Right, withInset: 0)
        self.rotateWheel?.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
        self.rotateWheel?.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
//        self.rotateWheel?.autoCenterInSuperview()
        self.rotateWheel?.autoSetDimension(.Height, toSize: ScreenW)
        
        self.startButton?.autoCenterInSuperview()
        self.startButton?.autoSetDimensionsToSize(CGSize(width: 80,height: 90))
        
        self.startButton?.addTarget(self, action: #selector(self.startRotate), forControlEvents:UIControlEvents.TouchUpInside)
    }
    
    func rotating(gesture:RotationGestureRecognizer){
        
        if(gesture.state == UIGestureRecognizerState.Ended){
            self.startRotate()
        }
        else{
           self.addRotate(gesture.rotation!)
        }
    }
    
    func addRotate(rotate:CGFloat){
        if rotate<0 {
            return
        }
        self.endValue=Float(self.fetchResult())
        let rotating = self.rotateWheel?.layer.valueForKeyPath("transform.rotation.z")?.floatValue
        let totalRotate = rotating! + Float(rotate)
        self.rotateWheel?.transform = CGAffineTransformRotate(self.view.transform, CGFloat(totalRotate))
        self.startValue = Float(Double(totalRotate)/M_PI * Double(180))
        if self.startValue > self.endValue {
            self.startValue = Float(Double(self.startValue!) - Double((360*12) / 180.0) * M_PI)
        }
    }
    
    func startRotate(){
        self.startAction!()
        self.view.userInteractionEnabled = false
        let wheelRotationAnimation = POPBasicAnimation(propertyNamed: "rotation")
        self.endValue=Float(self.fetchResult())
        wheelRotationAnimation.delegate = self
        wheelRotationAnimation.fromValue = self.startValue
        wheelRotationAnimation.toValue = self.endValue
        wheelRotationAnimation.duration = 3.0
        wheelRotationAnimation.autoreverses = false
        wheelRotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        wheelRotationAnimation.removedOnCompletion = true
        wheelRotationAnimation.completionBlock = {(POPAnimation,Bool) -> Void in
            self.startButton?.layer.removeAnimationForKey("pointerRotationAnimation")
            self.completion!()
        }
        self.rotateWheel?.layer.pop_addAnimation(wheelRotationAnimation, forKey: "wheealRotationAnimation")
        
//        let pointerRotationAnimation = POPSpringAnimation(propertyNamed: "rotation")
//        pointerRotationAnimation.delegate = self
//        pointerRotationAnimation.repeatCount = Int.max
//        pointerRotationAnimation.fromValue = -M_PI_4/18
//        pointerRotationAnimation.toValue = M_PI_4/18
//        pointerRotationAnimation.springSpeed = 20
//        pointerRotationAnimation.springBounciness = 10
//        pointerRotationAnimation.dynamicsTension = 5
//        pointerRotationAnimation.dynamicsMass = 1
//        pointerRotationAnimation.dynamicsFriction = 0
//        pointerRotationAnimation.autoreverses = true
//        pointerRotationAnimation.removedOnCompletion = false
//        wheelRotationAnimation.completionBlock = {(POPAnimation,Bool) -> Void in
//            self.callBack!()
//        }
//        startButton?.layer.pop_addAnimation(pointerRotationAnimation, forKey: "pointerRotationAnimation")
        
        let pointerRotationAnimation = CAKeyframeAnimation.init(keyPath: "transform.rotation.z")
        pointerRotationAnimation.values = [0,-M_PI_4/9,M_PI_4/9,0]
        pointerRotationAnimation.keyTimes = [0,0.25,0.75,1]
        pointerRotationAnimation.repeatCount = MAXFLOAT
        pointerRotationAnimation.duration = 0.02
        pointerRotationAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        pointerRotationAnimation.removedOnCompletion = false
        pointerRotationAnimation.autoreverses = true
        startButton?.layer.addAnimation(pointerRotationAnimation, forKey: "pointerRotationAnimation")
    }
    
    func fetchResult() -> Double {
        var result = ""
        if((self.continent) != nil){
            result = self.continent!
        }
        
        let resultDegreeArray = dataWithDegree[result]
        var randomCount = 0
        
        if(resultDegreeArray?.count>1){
            randomCount = random() % 2
        }
        
        let content = resultDegreeArray![randomCount]
        let min = Int(content["min"]!)
        let max = Int(content["max"]!)
        
        //srand(UInt32(time(1)))
        let randomDegree = Int(arc4random()%UInt32(max - min)) + min //    Int(rand())%(max - min)+min
        let angle = randomDegree + 360*12
        let x = Double(Float(angle)/Float(180))*M_PI
        return x
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

