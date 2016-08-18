//
//  MapViewController1.swift
//  Housing
//
//  Created by Ethan on 16/8/18.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (MapViewController1)
class MapViewController1: BaseViewController {

    private var mapView : MAMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        initMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initMapView(){
        mapView = MAMapView(frame: self.view.bounds)
//        mapView.delegate = self
        //        mapView.language = .En // 英文，没什么卵用
        mapView.showsUserLocation = true // 打开定位
        /*
         MAUserTrackingModeNone：仅在地图上显示，不跟随用户位置。
         MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
         MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。
         */
        mapView.setUserTrackingMode(.Follow, animated: true)
        mapView.setZoomLevel(15, animated: true)
        
        // 后台定位
        mapView.pausesLocationUpdatesAutomatically = false // 不自动暂停
        mapView.allowsBackgroundLocationUpdates = true // 是否自动定位
        
        // 实时路况
        mapView.showTraffic = true
        
        /*
         1）普通地图 MAMapTypeStandard；
         2）卫星地图 MAMapTypeSatellite；
         3）夜间地图 MAMapTypeStandardNight；
         */
        mapView.mapType = .Standard
        view.addSubview(mapView)

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



//public let pointReuseIndentifier = "pointReuseIndentifier"
//
//extension MapViewController1 : MAMapViewDelegate{
//    
//    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
//        if updatingLocation {
//            mapView.centerCoordinate = userLocation.coordinate
//        }
//    }
//    //    // 打点
//    //    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
//    //
//    //        if annotation.isKindOfClass(MAPointAnnotation)
//    //        {
//    //            var annotationView : MAAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier(pointReuseIndentifier)
//    //            if annotationView == nil {
//    //                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndentifier)
//    //                annotationView?.canShowCallout = true // 可以弹出气泡
//    //                annotationView?.draggable = true // 是否支持拖动
//    //                return annotationView
//    //            }
//    //        }
//    //        return nil
//    //    }
//}


