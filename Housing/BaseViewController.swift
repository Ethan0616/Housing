//
//  BaseViewController.swift
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit
@objc (BaseViewController)
class BaseViewController: UIViewController {

    var ViewControllerTitle = "ViewController"
    
    var sectionTitles : NSArray = ["ViewControllers","CustomView","APIView","CoreAnimation","GCD","=== title ==="]
    
    var titles : NSArray!
    var classNames : NSArray!
    var tableView : UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.yellowColor()
        title = ViewControllerTitle
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension BaseViewController{
    func initTitles(){
        
        let ViewControllers : NSArray = ["UITableViewController",
                                         "UINavigationController",
                                         "UITabBarController",
                                         "UICollectionViewController",
                                         "CustomTabBarController"]
        let CustomViews : NSArray = ["键盘"]
        let APIViews : NSArray = ["ViewControllers1",
                                  "ViewControllers2",
                                  "ViewControllers3",
                                  "ViewControllers4",
                                  "ViewControllers5"]
        let CoreAnimations : NSArray = ["ViewControllers1",
                                        "ViewControllers2",
                                        "ViewControllers3",
                                        "ViewControllers4",
                                        "ViewControllers5"]
        let GCD : NSArray = ["ViewControllers1",
                             "ViewControllers2",
                             "ViewControllers3",
                             "ViewControllers4",
                             "ViewControllers5"]
        
        titles = [ViewControllers,CustomViews,APIViews,CoreAnimations,GCD]
        
    }
    
    func initClassNames(){
        
        let ViewControllers : NSArray = ["TableViewController",
                                         "NavigationController",
                                         "TabBarController",
                                         "CollectionViewController",
                                         "CustomTabBarController"]
        let CustomViews : NSArray = ["CustomViewController"]
        let APIViews : NSArray = ["ViewControllers1",
                                  "ViewControllers2",
                                  "ViewControllers3",
                                  "ViewControllers4",
                                  "ViewControllers5"]
        let CoreAnimations : NSArray = ["ViewControllers1",
                                        "ViewControllers2",
                                        "ViewControllers3",
                                        "ViewControllers4",
                                        "ViewControllers5"]
        let GCD : NSArray = ["ViewControllers1",
                             "ViewControllers2",
                             "ViewControllers3",
                             "ViewControllers4",
                             "ViewControllers5"]
        
        classNames = [ViewControllers,CustomViews,APIViews,CoreAnimations,GCD]
    }
    
    
    func initTableView(){
        tableView = UITableView(frame: view.bounds,style: .Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.lightGrayColor()
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 25, 0)
        view.addSubview(tableView)
    }
}


extension BaseViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles[section].count ?? 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitles.objectAtIndex(section) as? String

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ViewControllerIdentifier = "ViewControllerIdentifier"
        
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(ViewControllerIdentifier)
        guard let tableViewCell : UITableViewCell = cell  else{
            cell = UITableViewCell(style: .Subtitle,reuseIdentifier: ViewControllerIdentifier)
            cell!.accessoryType = .DisclosureIndicator
            
            cell!.textLabel?.text = titles.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? String
            cell!.detailTextLabel?.text = classNames.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? String
            
            return cell!
        }
        tableViewCell.textLabel?.text = titles.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? String
        tableViewCell.detailTextLabel?.text = classNames.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? String
        
        return tableViewCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let className : String  = (classNames.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? String)!
        let type   = NSClassFromString(className) as? BaseViewController.Type
        
        if let subViewController =  type {
            let controller = subViewController.init()
            controller.title = titles.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? String
            if let titleName = controller.title {
                controller.ViewControllerTitle = titleName
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}