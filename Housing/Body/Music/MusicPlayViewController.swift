//
//  MusicPlayViewController.swift
//  Tachograph
//
//  Created by  mapbar_ios on 16/7/12.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import FreeStreamer
import Alamofire

class MusicPlayViewController: UIViewController{
    
    var playBtn = UIButton()
    var progressView:UIProgressView?
    var songId:String = ""
    var playing = false
    lazy var audioSteam = FSAudioStream()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSteam.strictContentTypeChecking = false
        getSongInfo()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Custom Methods
    func setupUI() {
    
        view.backgroundColor = UIColor.black
        
        let backBtn = UIButton()
        backBtn.setImage(UIImage.init(asName: "down", directory: "resource"), for: UIControlState())
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        let backLeadingCon = NSLayoutConstraint(item: backBtn, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
        let backTopCon = NSLayoutConstraint(item: backBtn, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 8)
        let backWidthCon = NSLayoutConstraint(item: backBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let backHeightCon = NSLayoutConstraint(item: backBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40)
        view.addConstraints([backTopCon,backLeadingCon,backWidthCon,backHeightCon])
        
        let progress = UIProgressView(progressViewStyle: .default)
        progressView = progress
        progress.translatesAutoresizingMaskIntoConstraints = false
        let proTopCon = NSLayoutConstraint(item: progress, attribute: .top, relatedBy: .equal, toItem: backBtn, attribute: .bottom, multiplier: 1, constant: 20)
        let proLeadingCon = NSLayoutConstraint(item: progress, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20)
        let proCenterXCon = NSLayoutConstraint(item: progress, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addSubview(progress)
        view.addConstraints([proTopCon,proLeadingCon,proCenterXCon])
        
        let bgImageView = UIImageView(image: UIImage(asName: "演员", directory: "Music", type: "jpg"))
        bgImageView.alpha = 0.6
        bgImageView.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        let bgImageTopCon = NSLayoutConstraint(item: bgImageView, attribute: .top, relatedBy: .equal, toItem: progress, attribute: .bottom, multiplier: 1, constant: 10)
        let bgImageWidthCon  = NSLayoutConstraint(item: bgImageView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bgImageView.image!.size.width)
        let bgImageHeightCon = NSLayoutConstraint(item: bgImageView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: bgImageView.image!.size.height)
        view.addConstraints([bgImageTopCon,bgImageWidthCon,bgImageHeightCon])
        
        
        let preBtn = UIButton()
        preBtn.setTitle("上一首", for: UIControlState())
        preBtn.setTitleColor(UIColor.lightGray, for: UIControlState())
        preBtn.layer.masksToBounds = true
        preBtn.layer.cornerRadius = 5
        preBtn.backgroundColor = UIColor.blue
        preBtn.addTarget(self, action: #selector(playPre), for: .touchUpInside)
        preBtn.translatesAutoresizingMaskIntoConstraints = false
        let widthCon = NSLayoutConstraint(item: preBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let heightCon = NSLayoutConstraint(item: preBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let centerXCon = NSLayoutConstraint(item: preBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 0.5, constant: 0)
        let bottomCon = NSLayoutConstraint(item: preBtn, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -30)
        view.addSubview(preBtn)
        view.addConstraints([widthCon,heightCon,centerXCon,bottomCon])
        
        playBtn.setTitle("播放", for: UIControlState())
        playBtn.setTitleColor(UIColor.red, for: UIControlState())
        playBtn.layer.masksToBounds = true
        playBtn.layer.cornerRadius = 5
        playBtn.backgroundColor = UIColor.blue
        playBtn.addTarget(self, action: #selector(play), for: .touchUpInside)
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        let playWidthCon = NSLayoutConstraint(item: playBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let playHeightCon = NSLayoutConstraint(item: playBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let playCenterXCon = NSLayoutConstraint(item: playBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let playBottomCon = NSLayoutConstraint(item: playBtn, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -30)
        view.addSubview(playBtn)
        view.addConstraints([playWidthCon,playHeightCon,playCenterXCon,playBottomCon])
        
        let nextBtn = UIButton()
        nextBtn.setTitle("下一首", for: UIControlState())
        nextBtn.setTitleColor(UIColor.lightGray, for: UIControlState())
        nextBtn.layer.masksToBounds = true
        nextBtn.layer.cornerRadius = 5
        nextBtn.backgroundColor = UIColor.blue
        nextBtn.addTarget(self, action: #selector(playNext), for: .touchUpInside)
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        let nextWidthCon = NSLayoutConstraint(item: nextBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let nextHeightCon = NSLayoutConstraint(item: nextBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let nextCenterXCon = NSLayoutConstraint(item: nextBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.5, constant: 0)
        let nextBottomCon = NSLayoutConstraint(item: nextBtn, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -30)
        view.addSubview(nextBtn)
        view.addConstraints([nextWidthCon,nextHeightCon,nextCenterXCon,nextBottomCon])
        
        
        
        
    }
    
    func getSongInfo(){
        
        Alamofire.request( rootUrl, parameters: ["format": "json","callback":"","from":"webapp_music","method":"baidu.ting.song.play","songid":self.songId]).validate()
            .responseJSON { response in

                
                guard var responseStr = String(data: response.data!, encoding: String.Encoding.utf8) else {
                    return
                }
                if responseStr.hasSuffix(";"){
                    
//                    responseStr = responseStr.substringToIndex(responseStr.endIndex.advancedBy(-1))
                    responseStr = responseStr.substring(to: responseStr.index(before: responseStr.endIndex))
                }
                do {
                    print("\(responseStr)")
                    guard let songInfoDic = try (JSONSerialization.jsonObject(with: responseStr.data(using: String.Encoding.utf8)!, options: .allowFragments) as! [[String:AnyObject]]).first else {
                        return
                    }
                    if songInfoDic["error_code"] as? Int == 22000 {
                        
                        guard let bitrateDic = songInfoDic["bitrate"] as? [String:AnyObject] else {
                            
                            return
                        }
                        self.audioSteam.url = NSURL(string: bitrateDic["file_link"] as! String)
                        self.perform(#selector(self.play), on: Thread.main, with: nil, waitUntilDone: true)
                    }


                    
                }catch{
                    let alert = UIAlertController(title: "解析网络音频文件时发生错误", message: "\(error)", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }

        }
        
        
    }
    //MARK:Touch Methods
    @objc func playPre() {
        
    }
    
    @objc func play() {
        playerDidSelectPlayBtn()
        audioSteam.play()
    }
    
    @objc func playNext() {
        
    }
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    func playerDidSelectPlayBtn() {
        if playing {
            playBtn.setTitle("暂停", for: UIControlState())
        }else{
            playBtn.setTitle("播放", for: UIControlState())
        }
        playing = !playing
    }
}
