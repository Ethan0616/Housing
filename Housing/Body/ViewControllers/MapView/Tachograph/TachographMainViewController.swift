//
//  MainViewController.swift
//  Tachograph
//
//  Created by Ethan on 16/5/4.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit

@objc (TachographMainViewController)
class TachographMainViewController: BaseViewController {
    
    fileprivate var mainView : MainView!

    override func loadView() {
        mainView = MainView(frame : Screen)
        view = mainView
        mainView.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
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

extension TachographMainViewController : TachographMainViewDelegate {
    
    func MainViewOverlayTabbarClicked(_ index: Int, _ selected: Bool) {
        MSGLog(Message: "Tabbar -> MainViewController: 第index:\(index)个图标,是否为选中状态:selected :\(selected)")
        
        switch index {
            case 0:
                let vc = MainViewController() // 地图打点
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = OfflineDetailViewController() // 离线地图
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:  // 视频集合
                let arr = FileManager.VideoModels()
                
                if let datasource = arr{
                    let vc  = MovieListController()
                    vc.dataSource = datasource
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    MSGLog(Message: "nothing");
                }
            case 3:  // 代码集合
                let viewController = ViewController()
                navigationController?.pushViewController(viewController, animated: true)
            case 4:  // 摄像头切换
                // 当录制的时候，切换摄像头，录制停止，自动保存。
                CaptureManager.sharedInstance().swapFrontAndBackCameras()
            
            case 5:  // 录制
                if selected {
                    CaptureManager.sharedInstance().starRecording()
                }else{
                    CaptureManager.sharedInstance().stopRecording()
                    
            }
        default:
            let viewController = ViewController()
            navigationController?.pushViewController(viewController, animated: true)

        }
    }
    
}
