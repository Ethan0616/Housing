//
//  Extension_UIColor.swift
//  Housing
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 Housing. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    class func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    class func colorArc4random() -> UIColor{
        
        let r = CGFloat(arc4random()%255)
        let g = CGFloat(arc4random()%255)
        let b = CGFloat(arc4random()%255)
        
        return UIColor.RGBA(r: r, g: g, b: b, a: 1)
    }
    

    class func colorWith(_ red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        let color = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
        return color
    }
    
    //  **********
    class func RGBA (_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    class func UIColorFromRGBString(_ colorString: String?) -> UIColor? {
        
        // 检查字符串是否为空和位数是否正确
        if colorString == nil || colorString!.utf16.count != 6 {
            
            return nil
        }
        
        // 将字符串转换成rgb
        var red = 0
        var green = 0
        var blue = 0
        
        for i in 0...2 {
            
            let range = colorString!.index(colorString!.startIndex, offsetBy: i*2) ..< colorString!.index(colorString!.startIndex, offsetBy: i*2+2)
            
            let colorSegment = colorString!.substring(with: range)
            
            let colorNumber = strtol(colorSegment, nil, 16)
            
            switch i {
            case 0:
                red = colorNumber
            case 1:
                green = colorNumber
            case 2:
                blue = colorNumber
            default:
                break
            }
        }
        
        return RGBA(CGFloat(red), g: CGFloat(green), b: CGFloat(blue), a: 1.0)
    }
    
    class func RGBStringFromUIColor(_ color: UIColor) -> String? {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        if color.getRed(&red, green: &green, blue: &blue, alpha: nil) {
            
            let redInt = Int(floor(red * 255.0))
            let greenInt = Int(floor(green * 255.0))
            let blueInt = Int(floor(blue * 255.0))
            
            return String(format:"%02x%02x%02x", redInt, greenInt, blueInt)
        }
        else {
            
            return nil
        }
    }
    
}
