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
        
        let allpaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        

        var document = allpaths[0]
        
        document += "/\(RecordDirectoryName)"
        
        var isDir: ObjCBool = false
        
        let pathSuccess = FileManager.default.fileExists(atPath: document, isDirectory: &isDir)
        
        if !pathSuccess {
            do {
                try FileManager.default.createDirectory(atPath: document, withIntermediateDirectories: true, attributes: nil)
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
            let result =  try FileManager.default.contentsOfDirectory(atPath: document!)
            return result as [AnyObject]?
        }catch{ }
        
        return nil
    }
    
    class func recordPathWithName(_ name: String!) -> String? {
        
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
                let route = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as? Route
                
                if route != nil {
                    routeList.append(route!)
                }
            }
            
            return routeList
        }
        
        return []
    }
    
    @discardableResult
    class func deleteFile(_ file: String!) -> Bool! {
        
        let path = recordPathWithName(file)
        
        do{
            try FileManager.default.removeItem(atPath: path!)
            return true
        }catch{
            return false
        }
    }
}
