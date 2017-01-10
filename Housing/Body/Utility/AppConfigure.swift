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

// MARK:  Layout
let MAWidth     : CGFloat = UIScreen.main.bounds.width
let MAHeight    : CGFloat = UIScreen.main.bounds.height
let MABounds    : CGRect  = UIScreen.main.bounds


struct AppCommon {
    
    // MARK: 字体
    // 小字体
    static let fontSmall            = UIFont.systemFont(ofSize: 12.0)
    // 加粗小字体
    static let fontSmallBold        = UIFont.boldSystemFont(ofSize: 12.0)
    // 默认字体
    static let fontNormal           = UIFont.boldSystemFont(ofSize: 14.0)
    // 默认加粗字体
    static let fontNormalBold       = UIFont.boldSystemFont(ofSize: 14.0)
    // 大字体
    static let fontLarge            = UIFont.systemFont(ofSize: 16.0)
    // 加粗大字体
    static let fontLargeBold        = UIFont.boldSystemFont(ofSize: 16.0)
    // 最大
    static let fontExtraLarge       = UIFont.boldSystemFont(ofSize: 18.0)
    
    // MARK: 颜色
    // 导航条颜色
    static let colorNavigationBar   = UIColor.RGBA(r: 218, g: 26, b: 35, a: 1)
    // ViewController默认背景颜色
    static let colorBackground      = UIColor.RGBA(r: 245, g: 245, b: 245, a: 1)
    // 随机色
    static let colorTest            = UIColor.colorArc4random()
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
