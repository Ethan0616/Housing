//
//  FileHelper.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-22.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import Foundation


class FileHelper: NSObject {
    
    static let RecordDirectoryName = "myRecords"
   
    class func baseDirForRecords() -> String? {
        
        let allpaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        

        var document = allpaths[0]
        
        document += "/\(RecordDirectoryName)"
        
        var isDir: ObjCBool = false
        
        let pathSuccess = NSFileManager.defaultManager().fileExistsAtPath(document, isDirectory: &isDir)
        
        if !pathSuccess || !isDir {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(document, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("创建文件夹失败")
                return nil
            }
        }
        
        return document
    }
    
    class func recordFileList() -> [AnyObject]? {
        
        let document: String? = baseDirForRecords()
        
        do{
            let result =  try NSFileManager.defaultManager().contentsOfDirectoryAtPath(document!)
            return result
        }catch{ }
        
        return nil
    }
    
    class func recordPathWithName(name: String!) -> String? {
        
        let document = baseDirForRecords()
        
        if let doc = document {
            return "\(doc)/\(name)"
        }
        
        return nil
    }
    
    class func routesArray() -> [Route]! {
        
        let list: [AnyObject]? = recordFileList()
        
        if (list != nil) {
            
            var routeList: [Route] = []
            
            for file in list as! [String] {
                
                print("file: \(file)")
                
                let path = recordPathWithName(file)
                let route = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as? Route
                
                if route != nil {
                    routeList.append(route!)
                }
            }
            
            return routeList
        }
        
        return []
    }
    
    class func deleteFile(file: String!) -> Bool! {
        
        let path = recordPathWithName(file)
        
        do{
            try NSFileManager.defaultManager().removeItemAtPath(path!)
            return true
        }catch{
            return false
        }
    }
}
