//
//  Extension_NSDictionary.swift
//  Housing
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 Housing. All rights reserved.
//

import Foundation

extension NSDictionary{
    
    func valueForKey(_ key : NSString,DefaultValue defaultValue : NSString) -> NSString{
        
        guard !key.isEqual(to: "") else {
            return defaultValue
        }
        
        let result = self.value(forKey: key as String)
        
        guard !(result is NSString) else {
            return result.debugDescription as NSString
        }
        
        return result as! NSString
    }
    
    func asDescription(){
        guard self.count > 0 else {
            print("字符串为空\(#file)\(#line)")
            return
        }
        var mutableStr = "(\n"
        for (key,value) in self {
            mutableStr.append("\tkey : \(key) , value : \(value)\n")
        }
        mutableStr.append(")")
        print(mutableStr)
    }
}

extension Dictionary{
    func asDescription(){
        guard self.count > 0 else {
            print("字符串为空\(#file)\(#line)")
            return
        }
        var mutableStr = "(\n"
        for (key,value) in self {
            mutableStr.append("\tkey : \(key) , value : \(value)\n")
        }
        mutableStr.append(")")
        print(mutableStr)
    }
}

