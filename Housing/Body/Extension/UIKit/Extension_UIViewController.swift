//
//  Extension_UIViewController.swift
//  Housing
//
//  Created by Ethan on 2017/1/4.
//  Copyright © 2017年 Housing. All rights reserved.
//

import Foundation


public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}


extension UIViewController {
//    open override class func initialize() {
//        
//        // make sure this isn't a subclass
//        if self !== UIViewController.self {
//            return
//        }
//        
//        DispatchQueue.once(token: "swizzledMethod\(description)", block:{
//
//            
//            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
//            let swizzledSelector = Selector(("nsh_viewWillAppear:"))
//            
//            let originalMethod = class_getInstanceMethod(self, originalSelector)
//            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//            
//            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//            
//            if didAddMethod {
//                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//            } else {
//                method_exchangeImplementations(originalMethod, swizzledMethod);
//            }
//
//        
//
//        })
//    }
//    
//    // MARK: - Method Swizzling
//    
//    func nsh_viewWillAppear(animated: Bool) {
//        
//        nsh_viewWillAppear(animated: animated)
//        
//        if description.isEmpty {
//            print("viewWillAppear: \(self)")
//
//        }else{
//            print("viewWillAppear: \(description)")
//        }
//    }
}

