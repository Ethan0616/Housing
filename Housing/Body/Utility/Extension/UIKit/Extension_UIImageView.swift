//
//  Extension_UIImageView.swift
//  Housing
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 Housing. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


extension UIImageView{
    
    func ex_setImageWithURL(_ url: URL, placeholderImage: UIImage) {
        
    }
    
    func app_setImageWithURL(_ url: URL, placeholderImage: UIImage) {
        self.sd_setImage(with: url, placeholderImage: placeholderImage)
    }
}

