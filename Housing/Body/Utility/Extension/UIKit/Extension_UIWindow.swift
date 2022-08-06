//
//  Extension_UIWindow.swift
//  Housing
//
//  Created by Ethan on 2022/8/6.
//  Copyright © 2022 Housing. All rights reserved.
//

import Foundation

internal extension UIWindow {
    static func isLandscape() -> Bool {
        if #available(iOS 13, *) {

            let windowScene = UIApplication.shared.connectedScenes
                .compactMap{$0 as? UIWindowScene}
                .filter{$0.activationState == .foregroundActive}
                .first
            if let window = windowScene {
                return window.interfaceOrientation.isLandscape
            }
            return false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
    
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            let keyWindow : UIWindow  = UIApplication.shared.connectedScenes
                .map{$0 as? UIWindowScene}
                .compactMap{$0}
                .first?.windows.first ?? UIWindow(frame: UIScreen.main.bounds)
//            return UIApplication.shared.windows.first { $0.isKeyWindow }
            return keyWindow
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    static func isBangsScreen() ->Bool {
        let keyWindow = UIWindow.key
        if #available(iOS 11.0, *) {
            return keyWindow!.safeAreaInsets.bottom > 0
        } else {
            // Fallback on earlier versions
        }
        return false
    }
    
    static var safeBottom : CGFloat {
        if #available(iOS 11.0, *) {
            return key?.safeAreaInsets.bottom ?? 0
        } else {
            // Fallback on earlier versions
        }
        return 0
    }
}
