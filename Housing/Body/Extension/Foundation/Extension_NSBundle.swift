//
//  Extension_NSBundle.swift
//  Housing
//
//  Created by Ethan on 16/8/15.
//  Copyright © 2016年 Housing. All rights reserved.
//

import Foundation

extension Bundle{
    private static let bundleName = "Resource"
    
    static func userBundle() -> String{
        return Bundle.main.path(forResource: bundleName, ofType: "Bundle")!
    }
    
    static func pathForResource(_ name : String , Dir dir : String? = nil) -> String{
        
        guard let dirStr = dir else {
            return Bundle.userBundle().appending("/\(name).png")
        }
        
        return Bundle.userBundle().appending("/\(dirStr)/\(name).png")
    }
}
