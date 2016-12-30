//
//  Extension_UIView.swift
//  Housing
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 Housing. All rights reserved.
//

import Foundation
import UIKit

extension UIView{

    /// X值
    public var x: CGFloat {
        return self.frame.origin.x
    }
    /// Y值
    public var y: CGFloat {
        return self.frame.origin.y
    }
    /// 宽度
    public var width: CGFloat {
        return self.frame.size.width
    }
    ///高度
    public var height: CGFloat {
        return self.frame.size.height
    }
    public var size: CGSize {
        return self.frame.size
    }
    public var point: CGPoint {
        return self.frame.origin
    }
}
