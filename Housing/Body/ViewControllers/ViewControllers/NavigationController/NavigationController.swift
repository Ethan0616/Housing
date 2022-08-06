//
//  NavigationController.swift
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (NavigationController)
class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appearance = UIBarButtonItem.appearance()
        appearance.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -100, vertical: 0), for: .default)
        self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor = UIColor.init(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 0.8)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.init(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)]
        self.navigationBar.tintColor = UIColor.init(red: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0)
//        self.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
        
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
//        dismisssHUD()
        return super.popViewController(animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
