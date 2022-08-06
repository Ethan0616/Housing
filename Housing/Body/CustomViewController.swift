//
//  CustomViewController.swift
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (CustomViewController)
class CustomViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initTitles()
        initClassNames()
        initTableView()
        title = "工具效果合集"
    }
/*
 let ViewControllers : NSArray = ["瀑布流"]
 
 titles = [ViewControllers]
}

override func initClassNames() {
 let ViewControllers : NSArray = ["CollectionView1"]

 */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func initTitles() {
        let ViewControllers : NSArray = ["模糊效果+动画",
                                         "侧边栏+SQL",
                                         "瀑布流",
                                         "地区选择"]
        let mapControllers : NSArray = ["地图相关"]
        let applications : NSArray = ["行车记录仪"]
        
        titles = [ViewControllers,mapControllers,applications]
    }
    
    override func initClassNames() {
        let ViewControllers : NSArray = ["TableViewController1",
                                         "TableViewController2",
                                         "CollectionView1",
                                         "RegionSelectionController"]
        let mapControllers : NSArray = ["MapViewController"]
        let applications : NSArray = ["TachographMainViewController"]
        classNames = [ViewControllers,mapControllers,applications]
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
