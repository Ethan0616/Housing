//
//  BaseViewController.swift
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit
@objc (BaseViewController)
class BaseViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{

    var ViewControllerTitle = "ViewController"
    
    var sectionTitles : NSArray = ["ViewControllers","MapView","other"]
    
    var titles : NSArray!
    var classNames : NSArray!
    var tableView : UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        edgesForExtendedLayout = UIRectEdge()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
//        title = ViewControllerTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setToolbarHidden(true, animated: animated)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil);

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
    
        func initTitles(){
            
            let ViewControllers : NSArray = ["UITableViewController",
                                             "UICollectionViewController"]
            let CustomViews : NSArray = ["MapViewController"]
    //        let APIViews : NSArray = ["ViewControllers1",
    //                                  "ViewControllers2",
    //                                  "ViewControllers3",
    //                                  "ViewControllers4",
    //                                  "ViewControllers5"]
    //        let CoreAnimations : NSArray = ["ViewControllers1",
    //                                        "ViewControllers2",
    //                                        "ViewControllers3",
    //                                        "ViewControllers4",
    //                                        "ViewControllers5"]
    //        let GCD : NSArray = ["ViewControllers1",
    //                             "ViewControllers2",
    //                             "ViewControllers3",
    //                             "ViewControllers4",
    //                             "ViewControllers5"]
            
            titles = [ViewControllers,CustomViews]
            
        }
        
        func initClassNames(){
            
            let ViewControllers : NSArray = ["TableViewController",
                                             "CollectionViewController"]
            let CustomViews : NSArray = ["MapViewController"]
    //        let APIViews : NSArray = ["ViewControllers1",
    //                                  "ViewControllers2",
    //                                  "ViewControllers3",
    //                                  "ViewControllers4",
    //                                  "ViewControllers5"]
    //        let CoreAnimations : NSArray = ["ViewControllers1",
    //                                        "ViewControllers2",
    //                                        "ViewControllers3",
    //                                        "ViewControllers4",
    //                                        "ViewControllers5"]
    //        let GCD : NSArray = ["ViewControllers1",
    //                             "ViewControllers2",
    //                             "ViewControllers3",
    //                             "ViewControllers4",
    //                             "ViewControllers5"]
            
            classNames = [ViewControllers,CustomViews]
        }
        
        
        func initTableView(){
            tableView = UITableView(frame: view.bounds,style: .grouped)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor.white
            tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 25, right: 0)
            view.addSubview(tableView)
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (self.titles[section] as AnyObject).count ?? 1
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return titles.count
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 15.0
        }
        
        
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
            return sectionTitles.object(at: section) as? String

        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let ViewControllerIdentifier = "ViewControllerIdentifier"
            
            var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ViewControllerIdentifier)
            guard let tableViewCell : UITableViewCell = cell  else{
                cell = UITableViewCell(style: .subtitle,reuseIdentifier: ViewControllerIdentifier)
                cell!.accessoryType = .disclosureIndicator
                
                cell!.textLabel?.text = (titles.object(at: indexPath.section) as AnyObject).object(at: indexPath.row) as? String
                cell!.detailTextLabel?.text = (classNames.object(at: indexPath.section) as AnyObject).object(at: indexPath.row) as? String
                
                return cell!
            }
            tableViewCell.textLabel?.text = (titles.object(at: indexPath.section) as AnyObject).object(at: indexPath.row) as? String
            tableViewCell.detailTextLabel?.text = (classNames.object(at: indexPath.section) as AnyObject).object(at: indexPath.row) as? String
            
            return tableViewCell
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let className : String  = ((classNames.object(at: indexPath.section) as AnyObject).object(at: indexPath.row) as? String)!
            let type   = NSClassFromString(className) as? BaseViewController.Type
            
            if let subViewController =  type {
                let controller = subViewController.init()
                controller.title = (titles.object(at: indexPath.section) as AnyObject).object(at: indexPath.row) as? String
                if let titleName = controller.title {
                    controller.ViewControllerTitle = titleName
                }
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }

}

