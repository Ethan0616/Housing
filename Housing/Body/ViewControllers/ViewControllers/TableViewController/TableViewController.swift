//
//  TableViewController.swift
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (TableViewController)
class TableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initTitles()
        initClassNames()
        initTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func initTitles() {
        let ViewControllers : NSArray = ["模糊效果+动画",
                                         "侧边栏+SQL"]
        
        titles = [ViewControllers]
    }
    
    override func initClassNames() {
        let ViewControllers : NSArray = ["TableViewController1",
                                         "TableViewController2"]
        
        classNames = [ViewControllers]
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
