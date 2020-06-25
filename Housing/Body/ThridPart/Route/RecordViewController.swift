//
//  RecordViewController.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView?
    var routes: [Route]
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        
        routes = FileManager.routesArray()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.gray
        initTableView()
    }
    
    func initTableView() {
        
        tableView = UITableView(frame: view.bounds)
        tableView!.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        tableView!.delegate = self
        tableView!.dataSource = self
        
        view.addSubview(tableView!)
    }
    
    /// Helpers
    
    func deleteRoute(_ index: Int) {
        
        if !routes.isEmpty {
            
            let route: Route = routes[index]
            FileManager.deleteFile(route.title())
            
            routes.remove(at: index)
        }
    }
        
    /// UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return routes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "routeCellIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)         
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if !routes.isEmpty {
            
            let route: Route = routes[indexPath.row]
            
            cell!.textLabel!.text = route.title()
            cell!.detailTextLabel!.text = route.detail()
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle != UITableViewCell.EditingStyle.delete {
            return
        }
        
        deleteRoute(indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
    }
    
    /// UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !routes.isEmpty {
            
            let route: Route = routes[indexPath.row]
            let displayController = DisplayViewController(nibName: nil, bundle: nil)
            displayController.title = "Display"
            displayController.route = route
            
            navigationController!.pushViewController(displayController, animated: true)
        }
  
    }
}
