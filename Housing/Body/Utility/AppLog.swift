//
//  AppLog.swift
//  iosNewNavi
//
//  Created by Ethan on 16/5/11.
//  Copyright © 2016年 Mapbar Inc. All rights reserved.
//

import UIKit
import CoreLocation
import Reachability

/**********************************************************
 
 /-- V0.0.1 --/
 
 使用方式：
 
 /*
    /// Objective-C 需要导入头文件  
                           -->  #import "OnlineNavigation-Swift.h"
 
    自定义内容Message参数，其他照抄
    建议拖入代码块中

    [AppLog MSGLogWithMessage:@"<#需要你填写的地方#>" functionName:[NSString stringWithCString:__func__ encoding:NSUTF8StringEncoding] fileNameWithPath:@__FILE__ lineNumber:__LINE__];

    /// Swift
 
    MSGLog(Message: "<#需要你填写的地方#>")
 */

 添加位置~：
 启动过程，重构和添加日志；重要的业务处理，UI交互需要添加；界面的切换，Controller的生命周期；大体的规则，函数进入和出去的时候。

 
**********************************************************/


#if DEBUG
    // debug 版本保存日志
    private let writeFileWithOutPut  : Bool = true
    
    // 控制台输出
    private let openLog : Bool = true
#else
    
    private let writeFileWithOutPut  : Bool = false
    private let openLog : Bool = true
    
#endif
private var filePath : String = ""
private let FILE_MAX_SIZE : CLong = (1024 * 1024 * 100)
private let infoDict : NSDictionary = Bundle.main.infoDictionary! as NSDictionary

func MSGLog(Message message: String,
                    functionName:  String = #function, fileNameWithPath: String = #file, lineNumber: Int = #line ) {
    
    let output : String = "\(AppLog.getTime()): \(message) [\(functionName) in \(fileNameWithPath), line \(lineNumber)] ,\(AppLog.AppLocationIsOn()),\(AppLog.AppConnect())"
    
    AppLog.write(Log: output)
}

class AppLog: NSObject {
    
    class func MSGLog(Message message: String,
                        functionName:  String = #function, fileNameWithPath: String = #file, lineNumber: Int = #line ) {
        
        let output : String = "\(getTime()): \(message) [\(functionName) in \(fileNameWithPath), line \(lineNumber)],\(AppLocationIsOn()),\(AppConnect())"
        
        AppLog.write(Log: output)
    }
    // 指定文件大小，创建文件夹以及文件
    // 初始化日志
    @discardableResult
    fileprivate class func createFilePath() -> Bool{
        
        if filePath.isEmpty {
            
            let times : String = returnTimeString(Format: "%Y%m%d%H%M%S")

            
            let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            filePath =  documentPath + "/Logs"
            
            // 判断文件夹是否存在，不存在创建
            if !FileManager.default.fileExists(atPath: filePath) {
                // 禁用  mkdir(String.fromCString(filePath)!, 0777)
                do {
                    
                    try Foundation.FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
                }
                catch {
                    
                }
                
            }
            // 路径 + 文件名
            filePath += "/App_log_\(String.init(times)).txt"
            
            printLog(Log: filePath as NSString)
            
            // 初始化状态
            let FileText : String = "应用名称: \(AppDisplayName()) | [应用版本号：\(AppVersion())] \n设备名称：\(AppSystemName())\nUUID:\(AppUUID())\n设备版本号：\(AppSystemVersion())\n设备型号：\(AppModel()) [\(AppLocalizedModel())] , 电量：\(AppBatteryLevel())% - \nLocation:\(AppLocationIsOn()) , 网络状态：\(AppConnect())"

            write(Log: FileText)
            
            return true
        }
        
        return false
    }

    // 日志写入
    @discardableResult
    fileprivate class func write(Log  log : String) -> Bool{
        
        if !writeFileWithOutPut { return false }
        if log.isEmpty {
            printLog(Log: "写入数据不可为空")
            return false
        }
        
        if !filePath.isEmpty && !log.isEmpty {
         
            let length : CLong = get_file_size(FileName: filePath.cString(using: String.Encoding.utf8)!)
            // 文件超过最大限制，重新创建一份
            if length > FILE_MAX_SIZE{
                filePath = ""
                if createFilePath() {
                    printLog(Log: "日志已满，重新创建成功 \( #file ):\(#line)" as NSString)
                }else{
                    printLog(Log: "文件创建失败 \( #file ):\(#line)" as NSString)
                }
            }
                
            // 初始化日志
            let fp : UnsafeMutablePointer<FILE>? = fopen(filePath, "at+")
            
            if fp == nil {
                printLog(Log: "File cannot be opened!")
                return false
            }
            
            if fp != nil {
                
                var end : Character = "\n"
                let cLog = log.cString(using: String.Encoding.utf8)!
                let logMaxSize = log.lengthOfBytes(using: String.Encoding.utf8) + 1
                fwrite(cLog, logMaxSize, 1, fp)
                
                fwrite(&end, 1, 1, fp)
                fwrite(&end, 1, 1, fp)
                
                fclose(fp)
                
                // 输出保存内容
                printLog(Log: log as NSString)
                
                return true
            }else{
                
                let newStr : String =  log + "\n"
                
                let  data : Data = newStr.data(using: String.Encoding.utf8)!
                
                printLog(Log: "这样保存有问题，请查看代码")
                
                return ((try? data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])) != nil)
            }
                
            
        }else{
            /**
             *  没有文件名称
             */
            createFilePath()
            AppLog.write(Log: log)
        }
        
        return false
    }

}

// MARK: tools
extension AppLog{
    
    /**
     *  有选择输出Log信息
     */
    fileprivate class func printLog(Log log : NSString){
        if openLog {
            
            print("--------------------------------------------\nAPPLICATION LOG:\n\(log)\n--------------------------------------------\n")
        }
    }
    
    fileprivate class func get_file_size(FileName filename : [CChar]) -> CLong {
        
        var length : CLong = 0
        
        let fp  = fopen(String(cString: filename),"rb")
        
        if  fp != nil {
            fseek(fp, 0, SEEK_END)
            length = ftell(fp)
            
            fclose(fp)
            
            return length
        }else{
            return 0
        }
    }
    
    /**
     *  传入时间格式，传入nil为默认格式："%04d-%02d-%02d %02d:%02d:%02d"
     */
    class func returnTimeString(Format format:String?) -> String{
        
        var formatStr : String = "%04d-%02d-%02d  %02d:%02d:%02d"
        
        if let str = format, !str.isEmpty {
            formatStr = str
        }
        
        var buffer : [CChar] = Array(repeating: 0, count: 32)
        memset(&buffer, 0, MemoryLayout.size(ofValue: buffer))
        
        var rawtime : time_t  = time_t()
        time(&rawtime)
        let timeinfo : UnsafeMutablePointer<tm> = localtime(&rawtime)
        var info : tm = timeinfo.pointee
        
        if formatStr != "%04d-%02d-%02d  %02d:%02d:%02d" {
            strftime(&buffer, buffer.count , formatStr, &info)
        }else{
            buffer = String(format: formatStr,info.tm_year + 1900,info.tm_mon + 1,info.tm_mday,info.tm_mday,info.tm_hour,info.tm_min,info.tm_sec).cString(using: String.Encoding.utf8)!
        }
        
        return String(cString: buffer)
    }
    
    /**
     *  精确到毫秒
     */
    fileprivate class func getTime() -> String{
        
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd 'at' HH:mm:ss.SS" //  "yyy-MM-dd 'at' HH:mm:ss.SSS"
        let str = timeFormatter.string(from: date) as String
        
        return str
    }
    
    
    /**
     *  应用名称
     */
    fileprivate class func AppDisplayName() -> String {
        return "\(infoDict.valueForKey("CFBundleDisplayName", DefaultValue: "没有CFBundleDisplayName"))"
    }
    
    /**
     *  应用版本号
     */
    fileprivate class func AppVersion() -> String {
        return "\(infoDict.valueForKey("CFBundleVersion", DefaultValue: "没有CFBundleVersion!"))"
    }
    
    /**
     *  设备版本号
     */
    fileprivate class func AppSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /**
     *  设备名称
     */
    fileprivate class func AppSystemName() -> String {
        return UIDevice.current.systemName
    }
    
    
    /**
     * 设备唯一标识 UUID
     */
    fileprivate class func AppUUID() -> String {
        return "\(UIDevice.current.identifierForVendor!)"
    }
    
    /**
     * 设备型号
     */
    fileprivate class func AppModel() -> String {
        return UIDevice.current.model
    }
    
    /**
     * 设备区域化型号 A1533 等，能区分港版、国行、电信、联通等
     */
    fileprivate class func AppLocalizedModel() -> String {
        return UIDevice.current.localizedModel
    }
    
    /**
     *  设备电量
     */
    fileprivate class func AppBatteryLevel() -> String {
        return "\(UIDevice.current.batteryLevel * Float(100))"
    }
    
    /**
     *  定位是否开启
     */
    fileprivate class func AppLocationIsOn() -> String {
        
            if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                return "定位已开启"
            }else{
                return "定位未开启"
            }
    }
    
    /**
     *  当前网络状态
     */
    fileprivate class func AppConnect() -> String {
        let reachability = Reachability.forInternetConnection()
        //判断连接类型
        if reachability?.currentReachabilityStatus() == .ReachableViaWiFi
        {
            return  "WiFi"
        }else if reachability?.currentReachabilityStatus() == .ReachableViaWWAN {
            return  "移动网络"
        }else {
            return  "没有网络连接"
        }
    }
    
    
}

