//
//  Extension_String.swift
//  Housing
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 Housing. All rights reserved.
//

import Foundation
import CoreLocation

extension String  {
    
    static func getDocument() ->String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    static func appendingDocumentDirectory(_ fileName : String) -> String{
        return "\(String.getDocument())/\(fileName)"
    }
    
    static func getPathForDocuments(_ name : String ,Dir dir : String) -> String{
        
        let dirPath = String.appendingDocumentDirectory("\(dir)")
        
        if !String.isFileExists(dirPath) {
            do {
                try FileManager.default.createDirectory(atPath : dirPath , withIntermediateDirectories: true )
            }catch{
                print("\(dirPath)文件创建失败！\(#line)\(#file)")
            }
        }
        
        return String.appendingDocumentDirectory("\(dir)/\(name)")
    }
    
    @discardableResult
    static func deleteWithFilePath(_ filePath : String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: filePath)
        }catch{
            return false
        }
        return true
    }
    
    static func isFileExists(_ filePath : String) -> Bool{
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    
    /// 判断是否是邮箱
    func validateEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    /// 判断是否是手机号
    func validateMobile() -> Bool {
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    /// 将字符串转换成经纬度
    func stringToCLLocationCoordinate2D(_ separator: String) -> CLLocationCoordinate2D? {
        let arr = self.components(separatedBy: separator)
        if arr.count != 2 {
            return nil
        }
        
        let latitude: Double = NSString(string: arr[1]).doubleValue
        let longitude: Double = NSString(string: arr[0]).doubleValue
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    /// 注意：要使用本分类，需要在 bridge.h 中添加以下头文件导入
    /// #import <CommonCrypto/CommonCrypto.h>
    /// 返回字符串的 MD5 散列结果
    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        // deallocate(capacity:) is  unavailable:Swift currently only supports freeing entire heap blocks,use deallocate() instead
        result.deallocate()
//        result.deallocate(capacity: digestLen)
        
        return hash.copy() as? String
    }
}

