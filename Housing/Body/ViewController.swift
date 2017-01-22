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
        
        
        
        /*
         cmaccelerometerdata : 
         类的实例代表一个加速度计的事件。它是一个测量的加速度沿三个空间轴在一个时刻。
         
         cmaltimeter : 
         使用cmaltimeter对象启动高度相关的数据到你的应用程序交付。高空事件反映的是当前高度的变化，而不是绝对高度。所以徒步旅行的应用程序可能会使用这个对象来跟踪用户的海拔增益的过程中加息。因为高度的事件可能不会对所有的设备是可用的，总是叫isrelativealtitudeavailable()方法之前使用这项服务。
         
         cmaltitudedata: 
         对象封装在相对高度变化的信息。您不直接创建此类的实例。当你想获得高度的变化，创造了cmaltimeter类和使用对象查询事件或开始交付的事件实例。高度计对象在适当的时候创建这个类的新实例，并将它们传递给指定的处理程序.
         
         cmattitude : 
         类的实例代表一个时间点测量设备的态度。”“态度”是指相对于给定的参照系而言身体的方向。
         
         cmdevicemotion:
         实例封装了态度、转速测量装置，和加速度。
         
         cmgyrodata:
         该cmgyrodata类的实例包含一个测量装置的旋转速度。
         
         cmlogitem:
         的cmlogitem类是一个核心的运动类的运动事件处理特定类型的基类。这个类的对象代表一段时间标记的数据，这些数据可以被记录到文件中.
         
         cmmagnetometerdata:
         该cmmagnetometerdata类封装测量磁场的装置的磁强计实例。
         
         cmmotionactivity:
         的cmmotionactivity类包含一个单一的运动更新事件数据。在设备支持的运动，你可以使用一个cmmotionactivitymanager对象要求更新时的运动变化的电流型。发生变化时，更新信息打包进一个cmmotionactivity对象和发送到您的应用程序。
         
         cmmotionactivitymanager:
         的cmmotionactivitymanager类提供了访问的设备存储的运动数据。运动数据反映用户是否行走，运行，在车辆中，或固定的时间段。导航应用程序可能会寻找当前类型的运动的变化，并提供不同的方向为每个。使用此类，可以在当前类型的运动变化时请求通知，也可以收集过去的运动更改数据.
         
         cmmotionmanager:
         一个cmmotionmanager对象是由iOS提供运动服务网关。这些服务提供了一个应用程序与加速度计数据，旋转速率数据，磁强计数据，和其他设备的运动数据，如态度。这些类型的数据源于设备的加速度计和（一些型号）的磁强计和陀螺仪。
         
         cmpedometer:
         使用cmpedometer对象获取行人的相关数据。你使用一个计步器步数和其他对象来检索信息的距离和楼层的上升或下降的数量。计步器对象管理一个缓存的历史数据，可以查询或者你可以请求实时更新的数据进行处理。
         
         cmpedometerdata:
         一个cmpedometerdata对象封装了关于距离的信息由用户徒步旅行。您不创建此类的实例。相反，你用cmpedometer对象从系统要求计步器数据。每个请求的数据封装到这个类的一个实例并交付给你注册的计步器对象的句柄。
         
         cmpedometerevent:
         cmrecordedaccelerometerdata:
         一个cmrecordedaccelerometerdata对象包含一个加速度计数据被记录。您不直接创建此类的实例。相反，你用cmsensorrecorder对象从系统中检索已记录的数据。
         
         cmsensordatalist:
         一个cmsensordatalist对象让你枚举系统所记录的对象的cmrecordedaccelerometerdata。您不直接创建此类的实例。相反，你得到了作为一个从cmsensorrecorder物体的加速度计数据查询的结果。
         
         cmsensorrecorder:
         一个cmsensorrecorder对象控制从设备的加速度计数据的收集和检索。使用传感器记录器启动加速度计数据的采集。稍后，使用传感器记录器获取记录的数据，以便您可以分析它。您可以使用记录的数据来评估特定类型的运动，并将结果应用到应用程序中.
         
         cmstepcounter:
         的cmstepcounter类提供了访问用户已采取步骤与设备的数量。步骤信息收集在设备与适当的内置硬件和存储，以便您可以运行查询，以确定用户的最近的pH值
         */
        
        
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

