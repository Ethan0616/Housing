//
//  FileManager.swift
//  Tachograph
//
//  Created by Ethan on 16/5/23.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

enum VideoModelStyle : Int {
    case none
    case photo
    case video
    case recordingVideo
}


struct VideoModel {
    
    var creationDate : Date
    var ModificationDate : Date
    var fileSize : Int
    var type : VideoModelStyle?
    var filePath : NSString?
    var videoImage : UIImage?
    
    static func Video(_ dict : NSDictionary) -> VideoModel?{
        
        let model : VideoModel = VideoModel(creationDate: dict[FileAttributeKey.creationDate] as! Date,ModificationDate: dict[FileAttributeKey.modificationDate] as! Date,fileSize:dict[FileAttributeKey.size] as! Int ,type:.none,filePath: nil , videoImage: nil)
        
        return model
    }
    
    
    func isVideo() ->Bool{
        return self.type == .video
    }
    
    func isRecordingVideo() -> Bool {
        return self.type == .recordingVideo
    }
    
    func isPhoto()-> Bool{
        return self.type == .photo
    }
    
    mutating func setImage(_ image : UIImage){
        self.videoImage = image
    }
    
    mutating func setFilePath(_ filePath : NSString){
        self.filePath = filePath
    }
    
    mutating func setType(_ type : VideoModelStyle){
        self.type = type
    }
}


private let documentMoviePath : String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/Mov")
private let documentPicturePath : String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/Pic")

extension FileManager {
    
    class func createFileUrl() -> URL? {
        if documentMoviePath.isEmpty {
            MSGLog(Message: "路径不存在！")
            return nil
        }
        // 判断文件夹是否存在，不存在创建
        if !Foundation.FileManager.default.fileExists(atPath: documentMoviePath) {
            do {
                try Foundation.FileManager.default.createDirectory(atPath: documentMoviePath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                
            }
            
        }
        
        var filePath : NSString = documentMoviePath as NSString
        // 文件名称 时间
        var nameStr : String = AppLog.returnTimeString(Format: "%Y%m%d%H%M%S")
        
        nameStr += ".mp4"
        
        filePath = filePath.appendingPathComponent(nameStr) as NSString
        
        MSGLog(Message: "保存路径为：\(filePath)")
        return URL(fileURLWithPath: filePath as String)
        
    }
    
    class func VideoModels() -> [VideoModel]? {
        
        do {
            
            let nameArr : NSArray = try Foundation.FileManager.default.contentsOfDirectory(atPath: documentMoviePath) as NSArray
            
            if nameArr.count > 0 {
                var items : [VideoModel] = []
                for nameString in  nameArr{
                    let filePath : String = "\(documentMoviePath)/\(nameString)"
                    do{
                        let dict : NSDictionary = try Foundation.FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary
                        
                        if dict.count > 0 {
                            let model : VideoModel? = VideoModel.Video(dict)
                            if var item = model {
                                let image : UIImage? = CaptureManager.getVideoImage(filePath)
                                if let aImage = image {
                                    item.setImage(aImage)
                                    item.setType(.video)
                                    item.setFilePath(filePath as NSString)
                                    items.insert(item, at: items.count)
                                }
                            }
                        }
                        
                    }catch{
                        MSGLog(Message: "catch：！！！ 路径取出信息有误")
                    }
                }
                return items
            }
            
        }catch{
            MSGLog(Message: "catch: !!! 文件名称提取失败")
        }
        
        return nil
    }
    
    // 遍历文件夹所占空间的大小
    class func folderSizeAtPath(_ folderPath : String) -> Float{
        if Foundation.FileManager.default.fileExists(atPath: folderPath) {
            return 0
        }
        
        let files = Foundation.FileManager.default.subpaths(atPath: folderPath)
        
        var folderSize : Float = 0
        for obj in files! {
            let pathStr : NSString = "\(documentMoviePath)/\(obj)" as NSString
            folderSize += Float(fileSizeAtPaht(pathStr))
        }
        return folderSize
        
    }
    
    // 遍历文件大小
    class func fileSizeAtPaht(_ filePath : NSString) -> Int {
        if !Foundation.FileManager.default.fileExists(atPath: filePath as String) {
            return 0
        }
        do{
            let dict = try Foundation.FileManager.default.attributesOfItem(atPath: filePath as String)
            return dict[FileAttributeKey.size] as! Int
        }catch{
            
        }
        return 0
    }
    
    // 手机剩余空间
    class func phoneHasFreeSpace()->NSInteger {
        var buf = statfs()
        var freespace : NSInteger = -1
        if statfs("/var",&buf) >= 0
        {
            freespace = (NSInteger)(buf.f_bsize.toUIntMax() * buf.f_bfree.toUIntMax())
            freespace = freespace / 1000 / 1000
            return freespace
            //            print("剩余录制空间为\(freespace/1024)G") // G
        }
        return 0
    }
    
    class func removeFile(_ outputFileUrl : URL){
        
        
    }
    
    class func copyFileToDocuments(_ fileUrl : URL){
        
    }
    
    class func copyFileToCameraRoll(_ fileUrl : URL){
        
    }
}


