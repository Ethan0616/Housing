//
//  AppConfigure.swift
//  Tachograph
//
//  Created by Ethan on 16/5/5.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

public let NavigationH: CGFloat = 64
public let tabbarH : CGFloat = 52
public let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
public let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
public let ScreenBounds: CGRect = UIScreen.main.bounds
public let Screen : CGRect = UIScreen.main.bounds
struct AppCommon {
    
    
    
}


class AppConfigure: NSObject {

    /**
     *  存储对象
     */
    var configures : NSMutableDictionary!
    
    
    // URLPATH
    // /Documents/appconfig/app.cfg
    fileprivate let urlPath : String = GHConst.getPathForDocuments("app.cfg", inDir: "appconfig")
    
    
    fileprivate static let sharedInstance : AppConfigure = {

        return AppConfigure()
        
    }()
    
    class func sharedConfigure() -> AppConfigure{
        
        return sharedInstance
        
    }
    
    
    // 存储列表
    // 是否显示小地图
    var showSmallMap : Bool = true
    
    
    
    
    fileprivate override init(){
        MSGLog(Message: urlPath)

        let dicts : NSMutableDictionary? = NSMutableDictionary(contentsOfFile: urlPath as String)
        
        if let configures = dicts {
            self.configures = configures
        }else{
            configures = NSMutableDictionary(capacity: 40)
        }
        super.init()
        load()
    }
    
    // 取
    fileprivate func load(){
        
        if configures.count > 0 {
            showSmallMap = configures.object(forKey: "showSmallMap") as! Bool
        }else{
            // 若没初值，在这里重新赋值
        }
        
    }

    
    // 同步
    func synchronize(){
        configures.setObject(showSmallMap, forKey: "showSmallMap" as NSCopying)
    }
    

    
    // 清空
    func cleanAllObjects(){
        GHConst.delete(withFilePath: urlPath)
    }
    
}
