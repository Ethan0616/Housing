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
    
    static func imageWithColor(color : UIColor) -> UIImage{
        
        let rect : CGRect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context , color.CGColor)
        CGContextFillRect(context , rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 按尺寸裁剪图片大小
    class func imageClipToNewImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 将传入的图片裁剪成带边缘的原型图片
    class func imageWithClipImage(image: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWH = image.size.width
        //        let border = borderWidth
        let ovalWH = imageWH + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), false, 0)
        let path = UIBezierPath(ovalInRect: CGRectMake(0, 0, ovalWH, ovalWH))
        borderColor.set()
        path.fill()
        
        let clipPath = UIBezierPath(ovalInRect: CGRectMake(borderWidth, borderWidth, imageWH, imageWH))
        clipPath.addClip()
        image.drawAtPoint(CGPointMake(borderWidth, borderWidth))
        
        let clipImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return clipImage
    }
    
    /// 将传入的图片裁剪成圆形图片
    func imageClipOvalImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextAddEllipseInRect(ctx, rect)
        
        CGContextClip(ctx)
        self.drawInRect(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 将传入的图片，生成对应的模糊效果
    func boxblurImageWithBlur(blur : CGFloat) -> UIImage{
        let imageData : NSData = UIImageJPEGRepresentation(self, 1)!
        let destImage : UIImage = UIImage(data:imageData)!
        var blur = blur
        if blur < 0 || blur > 1 {
            blur = 0.5
        }
        var boxSize : Int = Int(blur * 40.0)
        boxSize = boxSize - (boxSize % 2) + 1
        
        let img : CGImageRef = destImage.CGImage!
        var inBuffer , outBuffer , outBuffer2 : vImage_Buffer
        var pixelBuffer , pixelBuffer2 :  UnsafeMutablePointer<Void>
        var error : vImage_Error?
        
        let imgHeight  = UInt(CGImageGetHeight(img))
        let imgWidth  = UInt(CGImageGetWidth(img))
        let rowBytes  = CGImageGetBytesPerRow(img)
        
        
        //create vImage_Buffer with data from CGImageRef
        
        let inProvider : CGDataProviderRef = CGImageGetDataProvider(img)!
        let inBitmapData : CFDataRef = CGDataProviderCopyData(inProvider)!
        
        inBuffer = vImage_Buffer(data:UnsafeMutablePointer(CFDataGetBytePtr(inBitmapData)), height: imgHeight, width: imgWidth, rowBytes: rowBytes)
        
        
        //create vImage_Buffer for output

        pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img))
        
        outBuffer = vImage_Buffer(data: pixelBuffer, height: imgHeight, width: imgWidth, rowBytes: rowBytes)
        
        // Create a third buffer for intermediate processing
        pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img))
        
        outBuffer2 = vImage_Buffer(data: pixelBuffer2, height: imgHeight, width: imgWidth, rowBytes: rowBytes)
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend));


        if let err = error {
            print("error from convolution \(err)")
        }
        error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend));

        if let err = error {
            print("error from convolution \(err)")
        }
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend));

        if let err = error {
            print("error from convolution \(err)")
        }
        
        
        let  colorSpace  = CGColorSpaceCreateDeviceRGB()!
        // data: UnsafeMutablePointer<Void>, _ width: Int, _ height: Int, _ bitsPerComponent: Int, _ bytesPerRow: Int, _ space: CGColorSpace?, _ bitmapInfo: UInt32
        let skipLast : UInt32 = CGImageAlphaInfo.NoneSkipLast.rawValue
        let  ctx  = CGBitmapContextCreate(outBuffer.data,
                                                 Int(outBuffer.width),
                                                 Int(outBuffer.height),
                                                 8,
                                                 outBuffer.rowBytes,
                                                 colorSpace,
                                                 skipLast)
        let imageRef = CGBitmapContextCreateImage(ctx)
        let returnImage = UIImage(CGImage: imageRef!)
        
        //clean up
        free(pixelBuffer);
        free(pixelBuffer2);
        
        return returnImage
    }
    
}
