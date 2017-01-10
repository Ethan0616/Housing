//
//  Extension_NSArray.swift
//  Housing
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 Housing. All rights reserved.
//

import Foundation


extension Array{
    func asDescription(){
        guard self.count > 0 else {
            print("字符串为空\(#file)\(#line)")
            return
        }
        var mutableStr = "(\n"
        for str in self {
            mutableStr.append("\t\(str)\n")
        }
        mutableStr.append(")")
        print(mutableStr)
    }
    
}

extension NSArray{
    func asDescription(){
        guard self.count > 0 else {
            print("字符串为空\(#file)\(#line)")
            return
        }
        var mutableStr = "(\n"
        for str in self {
            mutableStr.append("\t\(str)\n")
        }
        mutableStr.append(")")
        print(mutableStr)
    }
}
