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

    fileprivate var mapView : MAMapView!
    fileprivate var search: AMapSearchAPI?

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = true
        initMapView()
        search = AMapSearchAPI()
        search?.delegate = self
        initToolBar()
        initGestureRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initMapView(){
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        //        mapView.language = .En // 英文，没什么卵用
        mapView.showsUserLocation = true // 打开定位
        /*
         MAUserTrackingModeNone：仅在地图上显示，不跟随用户位置。
         MAUserTrackingModeFollow：跟随用户位置移动，并将定位点设置成地图中心点。
         MAUserTrackingModeFollowWithHeading：跟随用户的位置和角度移动。
         */
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.setZoomLevel(15, animated: true)
        
        // 后台定位
        mapView.pausesLocationUpdatesAutomatically = false // 不自动暂停
        mapView.allowsBackgroundLocationUpdates = true // 是否自动定位
        
        // 实时路况
        mapView.isShowTraffic = true
        
        /*
         1）普通地图 MAMapTypeStandard；
         2）卫星地图 MAMapTypeSatellite；
         3）夜间地图 MAMapTypeStandardNight；
         */
        mapView.mapType = .standard
        view.addSubview(mapView)
    }
    
    func initToolBar() {
        let prompts: UILabel = UILabel()
        prompts.frame = CGRect(x: 0, y: self.view.bounds.height - 44, width: self.view.bounds.width, height: 44)
        prompts.text = "Long press to add Annotation"
        prompts.textAlignment = NSTextAlignment.center
        prompts.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        prompts.textColor = UIColor.white
        prompts.font = UIFont(name:"HelveticaNeue-Bold" , size: 20)
        
        prompts.autoresizingMask = [.flexibleTopMargin,.flexibleWidth]
        
        self.view.addSubview(prompts)
    }
    
    func initGestureRecognizer() {
        
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController1.handleLongPress(_:)))
        longPress.delegate = self
        self.view.addGestureRecognizer(longPress)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func searchReGeocodeWithCoordinate(_ coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        print("regeo :\(regeo)")
        
        self.search!.aMapReGoecodeSearch(regeo)
    }
}




extension MapViewController1 : MAMapViewDelegate{
//    let pointReuseIndentifier = "pointReuseIndentifier"
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
    
    //- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
    fileprivate func mapView(_ mapView: MAMapView , didUpdateUserLocation userLocation: MAUserLocation ) {
        print("location :\(userLocation.location)")
    }
    
    func mapView(_ mapView: MAMapView, viewFor annotation: MAAnnotation) -> MAAnnotationView? {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let annotationIdentifier = "invertGeoIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MAPinAnnotationView
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            }
            
            poiAnnotationView!.animatesDrop   = true
            poiAnnotationView!.canShowCallout = true
            
            return poiAnnotationView;
        }
        return nil
    }
    
    // - (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay;
    func mapView(_ mapView: MAMapView, rendererFor overlay: MAOverlay) -> MAOverlayRenderer? {
        
        if overlay.isKind(of: MACircle.self) {
            let renderer: MACircleRenderer = MACircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.green.withAlphaComponent(0.4)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 4.0
            
            return renderer
        }
        
        return nil
    }
}

extension MapViewController1 : AMapSearchDelegate{
    // - (void)search:(id)searchRequest error:(NSString*)errInfo;
    func search(_ searchRequest: AnyObject, error errInfo: String) {
        print("request :\(searchRequest), error: \(errInfo)")
        
    }
    
    //    - (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        
        print("request :\(request)")
        print("response :\(response)")
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = response.regeocode.formattedAddress
            annotation.subtitle = response.regeocode.addressComponent.province
            mapView!.addAnnotation(annotation)
            
            let overlay = MACircle(center: coordinate, radius: 50.0)
            mapView!.add(overlay)
        }
    }

}


extension MapViewController1 : UIGestureRecognizerDelegate{
    /// Handle Gesture
    
    //    - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
            let coordinate = mapView!.convert(gesture.location(in: self.view), toCoordinateFrom: mapView)
            
            searchReGeocodeWithCoordinate(coordinate)
            
        }
    }
    
}

