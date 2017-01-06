//
//  MusicListViewController.swift
//  Tachograph
//
//  Created by  mapbar_ios on 16/7/12.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

let rootUrl = "http://tingapi.ting.baidu.com/v1/restserver/ting"
class MusicListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    var playlistItems:[TaSong] = []
    let tableView = UITableView()
    let reuse = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requireSongsAndReload()
        setupTableView()
        requireSongsAndReload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    //MARK:Custom Methods
    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let hs = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableview]-0-|", options: .alignmentMask, metrics: nil, views: ["tableview":tableView])
        let vs = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableview]-0-|", options: .alignmentMask, metrics: nil, views: ["tableview":tableView])
        view.addConstraints(hs)
        view.addConstraints(vs)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func requireSongsAndReload() {

        let str = rootUrl + "?format=json&callback=&from=webapp_music&method=baidu.ting.billboard.billList&type=1&size=10&offset=0"
        let task = URLSession.shared.dataTask(with: URL(string: str)!, completionHandler: { (data, response, error) in
            if error != nil {
                let alert = UIAlertController(title: "提示", message: error?.localizedDescription, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }else{
                
                do {
                    let songListDic = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String:AnyObject]
                    
                    if songListDic["error_code"] as? Int == 22000 {
                        
                        guard let songList = songListDic["song_list"] as? [[String:AnyObject]] else {
                            
                            return
                        }
                        if self.playlistItems.count > 0 {
                            
                            self.playlistItems.removeAll()
                        }
                        
                        
                        for (_,songDic) in songList.enumerated(){
                            let song = TaSong()
                            song.name = songDic["title"] as! String
                            song.picBigUrlStr = songDic["pic_big"] as? String
                            song.picSmallUrlStr = songDic["pic_small"] as? String
                            song.singer = songDic["artist_name"] as? String
                            song.songId = songDic["song_id"] as! String
                            self.playlistItems.append(song)
                            
                        }
                        
                        self.perform(#selector(self.reloadTableView), on: Thread.main, with: nil, waitUntilDone: true)
                    }
                    
                }catch{
                    let alert = UIAlertController(title: "提示", message: "解析文件时发生错误", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
                    
                
            }
        }) 
        task.resume()
    }
    
    @objc func reloadTableView(){
        tableView.reloadData()
    }
    //MARK:TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuse)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: reuse)
        }
        let song = playlistItems[indexPath.row]
        cell?.textLabel?.text = song.name
        cell?.detailTextLabel?.text = song.singer
        cell?.selectionStyle = .gray
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = MusicPlayViewController()
        controller.songId = playlistItems[indexPath.row].songId
        present(controller, animated: true, completion: nil)
    
        
        
    }
    //MARK:TA
    func playerCurrentIndexDidChange(_ index:Int){
        print("唱到\(index)");
        tableView.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .top)
        
    }

}
