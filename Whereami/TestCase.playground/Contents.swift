//: Playground - noun: a place where people can play

/// 所有的语法及函数测试，都在这里实现

import UIKit

var str = "Hello"

func timeStr(str:String, n:Int) {
//    func combinator(currentStr:String, current:Int)->String {
//        print("currentIndex: \(current), currentStr: \(currentStr) \n")
//        return currentStr + str;
//    }
//    let ret:String = (0..<n).reduce("",combine: combinator)
    
    let ret:String = (0..<n).reduce("") { (initStr, index) -> String in
        print("init str \(initStr), index :\(index)")
        return  initStr + str + "\(index)";
    }
    print("ret string : \(ret)");
}

timeStr(str, n: 3)






