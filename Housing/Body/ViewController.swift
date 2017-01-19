//
//  ViewController.swift
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit
import CoreMotion
/**
 
 **/


class ViewController: BaseViewController {

    // 相对高度
    var altimeter : CMAltimeter?
    // 计步器
    var pedometer : CMPedometer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 获取用户高度
        
//        // 是否允许
//        guard CMAltimeter.isRelativeAltitudeAvailable() else {
//            AppLog.MSGLog(Message: "不允许用户获得相对高度")
//            return
//        }
//        
//        altimeter = CMAltimeter()
//        altimeter?.startRelativeAltitudeUpdates(to: OperationQueue(), withHandler: { (altitudeData, error) in
//            // 高度数据
//            print("\(altitudeData.debugDescription) \(altitudeData.customMirror.children.count)")
//            
//        })
        
        // 获取计步器数据
        guard CMPedometer.isStepCountingAvailable() else {
            AppLog.MSGLog(Message: "不允许获取用户的计步器数据")
            return
        }
        
        pedometer = CMPedometer()
        pedometer?.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            
            print("\(pedometerData?.numberOfSteps)")
            
        })
        
        
        
        
//        initTitles()
//        initClassNames()
//        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    deinit {
        self.navigationController?.isNavigationBarHidden = true
        altimeter?.stopRelativeAltitudeUpdates() // 停止获取高度
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

