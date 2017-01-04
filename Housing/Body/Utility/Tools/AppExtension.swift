//
//  AppExtension.swift
//  Tachograph
//
//  Created by Ethan on 16/5/4.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import Foundation
import UIKit


///// 扩展UIBarButtonItem
//extension UIBarButtonItem {
//    /// 针对导航条右边按钮的自定义item
//    convenience init(imageName: String, highlImageName: String, targer: AnyObject, action: Selector) {
//        let button: UIButton = UIButton(type: .custom)
//        button.setImage(UIImage(named: imageName), for: UIControlState())
//        button.setImage(UIImage(named: highlImageName), for: .highlighted)
//        button.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
//        button.addTarget(targer, action: action, for: .touchUpInside)
//        
//        self.init(customView: button)
//    }
//    
//    /// 针对导航条右边按钮有选中状态的自定义item
//    convenience init(imageName: String, highlImageName: String, selectedImage: String, targer: AnyObject, action: Selector) {
//        let button: UIButton = UIButton(type: .Custom)
//        button.setImage(UIImage(named: imageName), forState: .Normal)
//        button.setImage(UIImage(named: highlImageName), forState: .Highlighted)
//        button.frame = CGRectMake(0, 0, 50, 44)
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
//        button.setImage(UIImage(named: selectedImage), forState: .Selected)
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
//        button.addTarget(targer, action: action, forControlEvents: .TouchUpInside)
//        
//        self.init(customView: button)
//    }
//    
//    /// 针对导航条左边按钮的自定义item
//    convenience init(leftimageName: String, highlImageName: String, targer: AnyObject, action: Selector) {
//        let button: UIButton = UIButton(type: .Custom)
//        button.setImage(UIImage(named: leftimageName), forState: .Normal)
//        button.setImage(UIImage(named: highlImageName), forState: .Highlighted)
//        button.frame = CGRectMake(0, 0, 80, 44)
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
//        button.addTarget(targer, action: action, forControlEvents: .TouchUpInside)
//        
//        self.init(customView: button)
//    }
//    
//    
//    
//    /// 导航条纯文字按钮
//    convenience init(title: String, titleClocr: UIColor, targer: AnyObject ,action: Selector) {
//        
//        let button = UIButton(type: .Custom)
//        button.setTitle(title, forState: .Normal)
//        button.setTitleColor(titleClocr, forState: .Normal)
//        button.titleLabel?.font = UIFont.systemFontOfSize(14.0)
//        button.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
//        button.frame = CGRectMake(0, 0, 80, 44)
//        button.titleLabel?.textAlignment = NSTextAlignment.Right
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5)
//        button.addTarget(targer, action: action, forControlEvents: .TouchUpInside)
//        
//        self.init(customView: button)
//    }
//}
//
//
//




