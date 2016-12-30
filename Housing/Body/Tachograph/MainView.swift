//
//  MainView.swift
//  Tachograph
//
//  Created by Ethan on 16/5/5.
//  Copyright © 2016年 Tachograph. All rights reserved.
//

import UIKit
import AVFoundation

private let margin : CGFloat = 8
private let mapviewWH : CGFloat = 90



@objc protocol TachographMainViewDelegate : NSObjectProtocol{
    
    @objc optional func MainViewOverlayTabbarClicked(_ index : Int,_ selected : Bool)
    
}

class MainView: UIView {

    weak var delegate : TachographMainViewDelegate?
    /**
     *  地图页面
     */
    fileprivate let mapView = MapView()
    
    /**
     *  摄像头显示区域
     */
    fileprivate let captureView = CaptureView()
    
    /**
     *  导航条
     */
    let tabbar : TabbarView = TabbarView()

    
    
    /**
     *  摄像头 地图切换的中间button  添加到基础视图，放置在顶部
     */
    fileprivate let rectButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        backgroundColor = UIColor.black
        mapView.frame = frame
        captureView.frame = frame
        rectButton.frame = CGRect(x: 0, y: 0, width: mapviewWH, height: mapviewWH)
        rectButton.layer.cornerRadius = 15
        rectButton.layer.masksToBounds = true
        rectButton.alpha = 0.4
        rectButton.addTarget(self, action: #selector(MainView.changeMapCaptureFrameValueAction(_:)), for: .touchUpInside)
        rectButton.isSelected = true // true map.frame == rectButton   |||| false captureView.frame == rectButton
        // 添加初始化的小视图位置
        if bounds.size.width > bounds.size.height {
            // 当横向 在右下角
            rectButton.frame = CGRect(x: bounds.size.width - rectButton.frame.size.width - margin,y: bounds.size.height - rectButton.frame.size.height - margin, width: rectButton.bounds.size.width, height: rectButton.bounds.size.height)
            
        }else{
            rectButton.frame = CGRect(x: bounds.size.width - rectButton.frame.size.width - margin, y: bounds.size.height - rectButton.frame.size.height - margin - tabbarH, width: rectButton.bounds.size.width, height: rectButton.bounds.size.height)
        }
        
        if rectButton.isSelected {
            addSubview(captureView)
            addSubview(mapView)
        }else{
            addSubview(mapView)
            addSubview(captureView)
        }
        changeMapCaptureFrameValueAction(rectButton)
        addSubview(tabbar)
        addSubview(rectButton)
        NotificationCenter.default.addObserver(self, selector: #selector(MainView.deviceOrientationDidChangeNotificationAction(_:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        // delegate tabbarButtonAction
        for obj in tabbar.buttonArr {
            if obj.isKind(of: UIButton.self) {
            obj.addTarget(self, action: #selector(MainView.buttonAction(_:)), for: .touchUpInside)
            }
        }
        
        // 配置相关 ，后续加上
//     MSGLog(Message: "是否显示小地图\(AppConfigure.sharedConfigure().showSmallMap)")
//        
//        let appconfig = AppConfigure.sharedConfigure()
//        appconfig.showSmallMap = false
//        appconfig.synchronize()
//        MSGLog(Message: "\(appconfig.showSmallMap)")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 横屏
        if bounds.size.width > bounds.size.height {
            tabbar.frame = CGRect(x: 0, y: 0, width: tabbarH, height: bounds.size.height)
        }else{
            tabbar.frame = CGRect(x: 0, y: bounds.size.height - tabbarH, width: bounds.size.width, height: tabbarH)
        }
        
        bringSubview(toFront: rectButton)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

extension MainView{
    
    @objc fileprivate func buttonAction(_ btn : UIButton) {

        btn.isSelected = !btn.isSelected
        delegate?.MainViewOverlayTabbarClicked?(btn.tag - 6122,btn.isSelected)
    }
    
    @objc fileprivate func changeMapCaptureFrameValueAction(_ btn : UIButton) {
        
        btn.isSelected = !btn.isSelected
        
        UIView.animate(withDuration: 0.3, animations: {
            
                if btn.isSelected{
                    self.mapView.frame = self.bounds
                    self.mapView.layer.cornerRadius = 0
                    self.mapView.layer.masksToBounds = false
                }else{
                    self.captureView.frame = self.bounds
                    self.captureView.layer.cornerRadius = 0
                    self.captureView.layer.masksToBounds = false
                }
            
            }, completion: { (over) in
                
                if btn.isSelected{
                    self.captureView.frame = btn.frame
                    self.captureView.layer.cornerRadius = 15
                    self.captureView.layer.masksToBounds = true
                    self.sendSubview(toBack: self.mapView)
                }else{
                    self.mapView.frame = btn.frame
                    self.mapView.layer.cornerRadius = 15
                    self.mapView.layer.masksToBounds = true
                    self.sendSubview(toBack: self.captureView)
                }
                
        }) 
    }
    
    @objc fileprivate func deviceOrientationDidChangeNotificationAction(_ noti : Notification){
    
        let orientation : UIDeviceOrientation = UIDevice.current.orientation
        // 竖屏
        if !UIDeviceOrientationIsLandscape(orientation) {
//            print("width:\(bounds.size.width)  height:\(bounds.size.height)")
            // bounds:568.0  height:320.0
            
            rectButton.frame = CGRect(x: bounds.size.height - rectButton.frame.size.height - margin, y: bounds.size.width - rectButton.frame.size.width - margin - tabbarH, width: rectButton.bounds.size.height, height: rectButton.bounds.size.width)
            
            if rectButton.isSelected{
                // 小视图 为摄像头
                self.mapView.frame = CGRect(x: 0, y: 0, width: bounds.size.height, height: bounds.size.width)
                self.mapView.layer.cornerRadius = 0
                self.mapView.layer.masksToBounds = false
                self.sendSubview(toBack: self.mapView)
                self.captureView.frame = rectButton.frame
                self.captureView.layer.cornerRadius = 15
                self.captureView.layer.masksToBounds = true
            }else{
                // 小视图 为地图
                self.captureView.frame = CGRect(x: 0, y: 0, width: bounds.size.height, height: bounds.size.width)
                self.captureView.layer.cornerRadius = 0
                self.captureView.layer.masksToBounds = false
                self.sendSubview(toBack: self.captureView)
                self.mapView.frame = rectButton.frame
                self.mapView.layer.cornerRadius = 15
                self.mapView.layer.masksToBounds = true
            }
            
        }else{
//            print("bounds:\(bounds.size.width)  height:\(bounds.size.height)")
            // width:320.0  height:568.0
            var width : CGFloat = 0
            var height : CGFloat = 0
            if bounds.size.width < bounds.size.height {
                width = bounds.size.width
                height = bounds.size.height
            }else{
                width = bounds.size.height
                height = bounds.size.width
            }
            
            // 当横向 在右下角
            rectButton.frame = CGRect(x: height - rectButton.frame.size.height - margin,y: width - rectButton.frame.size.width - margin, width: rectButton.bounds.size.height, height: rectButton.bounds.size.width)
            
            if rectButton.isSelected{
                // 小视图 为摄像头
                self.mapView.frame = CGRect(x: 0, y: 0, width: height, height: width)
                self.mapView.layer.cornerRadius = 0
                self.mapView.layer.masksToBounds = false
                self.sendSubview(toBack: self.mapView)
                self.captureView.frame = rectButton.frame
                self.captureView.layer.cornerRadius = 15
                self.captureView.layer.masksToBounds = true
            }else{
                // 小视图 为地图
                self.captureView.frame = CGRect(x: 0, y: 0, width: height, height: width)
                self.captureView.layer.cornerRadius = 0
                self.captureView.layer.masksToBounds = false
                self.sendSubview(toBack: self.captureView)
                self.mapView.frame = rectButton.frame
                self.mapView.layer.cornerRadius = 15
                self.mapView.layer.masksToBounds = true

            }
        }
    }
}
