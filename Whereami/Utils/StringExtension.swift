//
//  StringExtension.swift
//  Whereami
//
//  Created by WuQifei on 16/2/16.
//  Copyright © 2016年 WuQifei. All rights reserved.
//

import Foundation

public extension String {
    
    func isEmail() -> Bool {
        if isEmpty() {
            return false
        }
        
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9]+",
            options: [.CaseInsensitive])
        let result = regex.firstMatchInString(self, options:[], range: NSMakeRange(0, utf16.count));
        
        return  result != nil
    }
    
    func between(left:String,_ right:String) ->String? {
        guard
            let leftRange = rangeOfString(left),rightRange = rangeOfString(right,options: .BackwardsSearch)
            where left != right && leftRange.endIndex != rightRange.startIndex
            else {return nil}
        return self[leftRange.endIndex...rightRange.startIndex.predecessor()]
    }
    
    func camelize() -> String {
        let source = clean(" ", allOf: "-", "_")
        if source.characters.contains(" ") {
            let first = source.substringToIndex(source.startIndex.advancedBy(1))
            let cammel = NSString(format: "%@", (source as NSString).capitalizedString.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)) as String
            let rest = String(cammel.characters.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercaseString.substringToIndex(source.startIndex.advancedBy(1))
            let rest = String(source.characters.dropFirst())
            return "\(first)\(rest)"
        }
    }
    
    func capitalize() -> String {
        return capitalizedString
    }
    
    func contains(substring: String) -> Bool {
        return rangeOfString(substring) != nil
    }
    
    func chompLeft(prefix: String) -> String {
        if let prefixRange = rangeOfString(prefix) {
            if prefixRange.endIndex >= endIndex {
                return self[startIndex..<prefixRange.startIndex]
            } else {
                return self[prefixRange.endIndex..<endIndex]
            }
        }
        return self
    }
    
    func chompRight(suffix: String) -> String {
        if let suffixRange = rangeOfString(suffix, options: .BackwardsSearch) {
            if suffixRange.endIndex >= endIndex {
                return self[startIndex..<suffixRange.startIndex]
            } else {
                return self[suffixRange.endIndex..<endIndex]
            }
        }
        return self
    }
    
    func collapseWhitespace() -> String {
        let components = componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter { !$0.isEmpty }
        return components.joinWithSeparator(" ")
    }
    
    func clean(with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.stringByReplacingOccurrencesOfString(target, withString: with)
        }
        return string
    }
    
    func count(substring: String) -> Int {
        return componentsSeparatedByString(substring).count-1
    }
    
    func endsWith(suffix: String) -> Bool {
        return hasSuffix(suffix)
    }
    
    func ensureLeft(prefix: String) -> String {
        if startsWith(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    func ensureRight(suffix: String) -> String {
        if endsWith(suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    func indexOf(substring: String) -> Int? {
        if let range = rangeOfString(substring) {
            return startIndex.distanceTo(range.startIndex)
        }
        return nil
    }
    
    func isAlpha() -> Bool {
        for chr in characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func isAlphaNumeric() -> Bool {
        let alphaNumeric = NSCharacterSet.alphanumericCharacterSet()
        return componentsSeparatedByCharactersInSet(alphaNumeric).joinWithSeparator("").length == 0
    }
    
    func isEmpty() -> Bool {
        let nonWhitespaceSet = NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet
        return componentsSeparatedByCharactersInSet(nonWhitespaceSet).joinWithSeparator("").length != 0
    }
    
    func isNumeric() -> Bool {
        if let _ = NSNumberFormatter().numberFromString(self) {
            return true
        }
        return false
    }
    
    func join<S : SequenceType>(elements: S) -> String {
        return elements.map{String($0)}.joinWithSeparator(self)
    }
    
    func lines() -> [String] {
        return characters.split{$0 == "\n"}.map(String.init)
    }
    
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    func pad(n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self, string.times(n)])
    }
    
    func padLeft(n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self])
    }
    
    func padRight(n: Int, _ string: String = " ") -> String {
        return "".join([self, string.times(n)])
    }
    
    func split(separator:Character) ->[String] {
        return characters.split(isSeparator: { (currentCharacter) -> Bool in
            return separator == currentCharacter
        }).map({ (currentStr) -> String in
            return "\(currentStr)"
        })
    }
    
    func startsWith(prefix:String) ->Bool {
        return hasPrefix(prefix)
    }
    
    /**
     去除标点符号
     
     - returns: 返回去除标点之后的结果
     */
    func stripPunctuation()->String {
        return componentsSeparatedByCharactersInSet(NSCharacterSet.punctuationCharacterSet()).joinWithSeparator("").componentsSeparatedByString(" ").filter({ (currentStr) -> Bool in
            return currentStr != ""
        }).joinWithSeparator(" ")
    }
    
    func times(n:Int) -> String {
        return (0..<n).reduce("") {
            (initStr,index) -> String in
            return self + initStr
        }
    }
    
    func toFloat() -> Float? {
        if let number = NSNumberFormatter().numberFromString(self) {
            return number.floatValue
        }
        return nil
    }
    
    func toInt() -> Int? {
        if let number = NSNumberFormatter().numberFromString(self) {
            return number.integerValue
        }
        return nil
    }
    
    func toDouble(locale: NSLocale = NSLocale.systemLocale()) -> Double? {
        let nf = NSNumberFormatter()
        nf.locale = locale
        if let number = nf.numberFromString(self) {
            return number.doubleValue
        }
        return nil
    }
    
    func toBool() -> Bool? {
        let trimmedStr = self.trimmed().lowercaseString
        if trimmedStr == "true" || trimmedStr == "false" {
            return (trimmedStr as NSString).boolValue
        }
        return nil
    }
    
    func toDateTime(format:String = "yyyy-MM-dd HH:mm:ss")->NSDate? {
        return toDate(format)
    }
    
    func toDate(format:String = "yyyy-MM-dd")->NSDate? {
        let dataFormatter = NSDateFormatter()
        dataFormatter.dateFormat = format
        return dataFormatter.dateFromString(self)
    }
    
    func trimmed() ->String {
        return trimmedLeft().trimmedRight()
    }
    
    func trimmedLeft()->String {
        if let range = rangeOfCharacterFromSet(NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet) {
            return self[range.startIndex..<endIndex]
        }
        return self
    }
    
    func trimmedRight()->String {
        if let range = rangeOfCharacterFromSet(NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet) {
            return self[startIndex..<range.endIndex]
        }
        return self
    }
    
    
    subscript(r:Range<Int>) ->String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex)
            return self[startIndex..<endIndex]
        }
    }
    
    func substring(startIndex:Int, length:Int) ->String {
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(startIndex + length)
        return self[start..<end]
    }
    
    subscript(i:Int) ->Character {
        get {
            let index = self.startIndex.advancedBy(i);
            return self[index]
        }
    }
    
    func toUrl() -> NSURL {
        print(self)
        var urlString:String? = nil
        let version = UIDevice.currentDevice().systemVersion.componentsSeparatedByString(".")
        if version[0].toFloat() >= 7.0 {
            let customAllowedSet =  NSCharacterSet(charactersInString:"`#%^{}\"[]|\\<> ").invertedSet
            urlString = self.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        }
        else{
            urlString = self.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            print(urlString)
        }
        return NSURL(string: urlString!)!
    }
}