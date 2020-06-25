//
//  CollectionViewController.swift
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (CollectionViewController)
class CollectionViewController: BaseViewController {
   
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
        let ViewControllers : NSArray = ["瀑布流"]
        
        titles = [ViewControllers]
    }
    
    override func initClassNames() {
        let ViewControllers : NSArray = ["CollectionView1"]
        
        classNames = [ViewControllers]
    }
}
