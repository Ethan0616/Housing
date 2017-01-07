//
//  AppDelegate.swift
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit
import Reachability


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var AppNav : UINavigationController!
    var reach: Reachability?

    fileprivate let MapViewAPIKey = "2594c2a3219fc215949df291c231a6cb"
    fileprivate let tachographMapViewAPIKey = "5d8d6da33a87ef2a7af423ec8f6f76b0" // tachograph


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        AMapServices.shared().apiKey = MapViewAPIKey
        codeForTachograph()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate{
    fileprivate func codeForTachograph(){
        AMapServices.shared().apiKey = tachographMapViewAPIKey
        
        isReachable()
        
        window = UIWindow(frame: Screen)
        
        window?.backgroundColor = UIColor.orange
        
        window?.rootViewController = showLeadpage()
        
        window?.makeKeyAndVisible()
    }
    
    // 当网络发生变化
    fileprivate func isReachable() -> Void{
        
//        self.reach = Reachability.forInternetConnection()
//        
//        // Set the blocks
//        self.reach?.reachableBlock = {
//            ( reach: Reachability!) -> Void in
//            // keep in mind this is called on a background thread
//            // and if you are updating the UI it needs to happen
//            // on the main thread, like this:
//            DispatchQueue.main.async {
//                MSGLog(Message: "REACHABLE!")
//            }
//            
//        }
//        
//        self.reach?.unreachableBlock = {
//            ( reach: Reachability!) -> Void in
//            MSGLog(Message: "UNREACHABLE!")
//        }
//        
//        self.reach!.startNotifier()
        
    }
    
    //MARK: - 引导页设置
    fileprivate func showLeadpage() -> UIViewController {
        let versionStr = "CFBundleShortVersionString"
        let cureentVersion = Bundle.main.infoDictionary![versionStr] as! String
        let oldVersion = (UserDefaults.standard.object(forKey: versionStr) as? String) ?? ""
        
        if cureentVersion.compare(oldVersion) == ComparisonResult.orderedDescending {
            UserDefaults.standard.set(cureentVersion, forKey: versionStr)
            UserDefaults.standard.synchronize()
            let AppNav  = UINavigationController.init(rootViewController: ViewController())
            AppNav.setNavigationBarHidden(true, animated: false)
            
            
            return AppNav
        }
        let AppNav  = UINavigationController.init(rootViewController: TachographMainViewController())
        AppNav.setNavigationBarHidden(true, animated: false)
        return AppNav
    }
}
