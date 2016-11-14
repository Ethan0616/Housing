//
//  Extension_UIBarButtonItem.swift
//  Housing
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 Housing. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem{
    
    /// 针对导航条右边按钮的自定义item
    convenience init(imageName: String, highlImageName: String, targer: AnyObject, action: Selector) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.setImage(UIImage(named: highlImageName), for: .highlighted)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.addTarget(targer, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
    
    /// 针对导航条右边按钮有选中状态的自定义item
    convenience init(imageName: String, highlImageName: String, selectedImage: String, targer: AnyObject, action: Selector) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.setImage(UIImage(named: highlImageName), for: .highlighted)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10)
        button.setImage(UIImage(named: selectedImage), for: .selected)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.addTarget(targer, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
    
    /// 针对导航条左边按钮的自定义item
    convenience init(leftimageName: String, highlImageName: String, targer: AnyObject, action: Selector) {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: leftimageName), for: UIControlState())
        button.setImage(UIImage(named: highlImageName), for: .highlighted)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.addTarget(targer, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
    
    
    
    /// 导航条纯文字按钮
    convenience init(title: String, titleClocr: UIColor, targer: AnyObject ,action: Selector) {
        
        let button = UIButton(type: .custom)
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleClocr, for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        button.titleLabel?.textAlignment = NSTextAlignment.right
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5)
        button.addTarget(targer, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
    
    
}
