//
//  Extension_UIImage.swift
//  Housing
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 Housing. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

// UIImage的扩展
extension UIImage {
    /// 按尺寸裁剪图片大小
    class func imageClipToNewImage(_ image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /// 将传入的图片裁剪成带边缘的原型图片
    class func imageWithClipImage(_ image: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWH = image.size.width
        //        let border = borderWidth
        let ovalWH = imageWH + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: ovalWH, height: ovalWH), false, 0)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ovalWH, height: ovalWH))
        borderColor.set()
        path.fill()
        
        let clipPath = UIBezierPath(ovalIn: CGRect(x: borderWidth, y: borderWidth, width: imageWH, height: imageWH))
        clipPath.addClip()
        image.draw(at: CGPoint(x: borderWidth, y: borderWidth))
        
        let clipImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return clipImage!
    }
}

// UIImage的扩展
extension UIImage {
    
    // 返回灰色图片
    public func grayscaled() -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let (width, height) = (Int(size.width), Int(size.height))
        
        // 构建上下文：每个像素一个字节，无alpha
        guard let context = CGContext(data: nil, width: width,
                                      height: height, bitsPerComponent: 8,
                                      bytesPerRow: width, space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.none.rawValue)
            else { return nil }
        
        // 绘制上下文
        let destination = CGRect(origin: .zero, size: size)
        context.draw(cgImage, in: destination)
        
        // 返回灰度图片
        guard let imageRef = context.makeImage() 
            else { return nil }
        return UIImage(cgImage: imageRef)
    }
    
    public func ScreenImage() -> UIImage? {
        
        let bounds = CGRect(origin: .zero, size: size)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let (width,height) = (Int(size.width),Int(size.height))
        
        // 创建 CG ARGB 上下文
        guard let context = CGContext(data: nil, width: width,
                                      height: height, bitsPerComponent: 8,
                                      bytesPerRow: width * 4, space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
            else {return nil}
        
        // 为 UIKit 准备 CG 上下文
        UIGraphicsPushContext(context); defer { UIGraphicsPopContext() }
        
        // 使用 UIKit 调用绘制上下文
        UIColor.blue.set(); UIRectFill(bounds)
        let oval = UIBezierPath(ovalIn: bounds)
        UIColor.red.set(); oval.fill()
        
        // 从上下文中提取图像
        guard let imageRef = context.makeImage() else { return nil }
        return UIImage(cgImage: imageRef)
    }
    
    static func imageWithColor(_ color : UIColor) -> UIImage{
        
        let rect : CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    

    
    /// 将传入的图片裁剪成圆形图片
    func imageClipOvalImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx?.addEllipse(in: rect)
        
        ctx?.clip()
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// 将传入的图片，生成对应的模糊效果
    func boxblurImageWithBlur(_ blur : Double) -> UIImage{
        let imageData : Data = UIImageJPEGRepresentation(self, 1)!
        let destImage : UIImage = UIImage(data:imageData)!
        var blur = blur
        if blur < 0 || blur > 1 {
            blur = 0.5
        }
        var boxSize : Int = Int(blur * 40.0)
        boxSize = boxSize - (boxSize % 2) + 1
        
        let img : CGImage = destImage.cgImage!
        var inBuffer , outBuffer , outBuffer2 : vImage_Buffer
        var pixelBuffer , pixelBuffer2 :  UnsafeMutableRawPointer
        
        let imgHeight  = UInt(img.height)
        let imgWidth  = UInt(img.width)
        let rowBytes  = img.bytesPerRow
        
        
        //create vImage_Buffer with data from CGImageRef
        
        let inProvider : CGDataProvider = img.dataProvider!
        let inBitmapData : CFData = inProvider.data!
        
        inBuffer = vImage_Buffer(data:UnsafeMutablePointer(mutating: CFDataGetBytePtr(inBitmapData)), height: imgHeight, width: imgWidth, rowBytes: rowBytes)
        
        
        //create vImage_Buffer for output

        pixelBuffer = malloc(img.bytesPerRow * img.height)
        
        outBuffer = vImage_Buffer(data: pixelBuffer, height: imgHeight, width: imgWidth, rowBytes: rowBytes)
        
        // Create a third buffer for intermediate processing
        pixelBuffer2 = malloc(img.bytesPerRow * img.height)
        
        outBuffer2 = vImage_Buffer(data: pixelBuffer2, height: imgHeight, width: imgWidth, rowBytes: rowBytes)
        
        vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend));

        vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend));

        vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend));

        
        
        let  colorSpace  = CGColorSpaceCreateDeviceRGB()
        // data: UnsafeMutablePointer<Void>, _ width: Int, _ height: Int, _ bitsPerComponent: Int, _ bytesPerRow: Int, _ space: CGColorSpace?, _ bitmapInfo: UInt32
        let skipLast : UInt32 = CGImageAlphaInfo.noneSkipLast.rawValue
        let  ctx  = CGContext(data: outBuffer.data,
                                                 width: Int(outBuffer.width),
                                                 height: Int(outBuffer.height),
                                                 bitsPerComponent: 8,
                                                 bytesPerRow: outBuffer.rowBytes,
                                                 space: colorSpace,
                                                 bitmapInfo: skipLast)
        let imageRef = ctx?.makeImage()
        let returnImage = UIImage(cgImage: imageRef!)
        
        //clean up
        free(pixelBuffer);
        free(pixelBuffer2);
        
        return returnImage
    }
    
}
