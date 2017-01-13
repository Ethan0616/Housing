//
//  MovieListController.swift
//  Tachograph
//
//  Created by Ethan on 16/7/11.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

class MovieListController: UIViewController {
    
    fileprivate var tableView : UITableView!
    var dataSource : [VideoModel]!
    
    
    override func loadView() {
        tableView  = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view = tableView

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "视频"
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    deinit {
        self.navigationController?.isNavigationBarHidden = true

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

extension MovieListController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "CellID"
        
        var cell : UITableViewCell? =  tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        
        cell?.imageView?.image = dataSource[indexPath.row].videoImage
        var textLabelStr : NSString = dataSource[indexPath.row].filePath!
        let strArr = textLabelStr.components(separatedBy: "/")
        textLabelStr = strArr[strArr.count - 1] as NSString
        cell?.textLabel?.text = textLabelStr as String
        cell?.detailTextLabel?.text = "文件的大小为：\(dataSource[indexPath.row].fileSize/1024)KB"
        
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let movie = MoviePlayerController()
        
        movie.fileUrl = dataSource[indexPath.row].filePath

        self.navigationController?.pushViewController(movie, animated: false)
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let urlStr = URL.init(fileURLWithPath: dataSource[indexPath.row].filePath as! String)
            
        FileManager.removeFile(urlStr)
        
        dataSource.remove(at: indexPath.row)
        tableView.reloadData()
    }

}


