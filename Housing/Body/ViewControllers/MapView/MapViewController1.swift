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
    private var search: AMapSearchAPI?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
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
    
    func initToolBar() {
        let prompts: UILabel = UILabel()
        prompts.frame = CGRectMake(0, self.view.bounds.height - 44, self.view.bounds.width, 44)
        prompts.text = "Long press to add Annotation"
        prompts.textAlignment = NSTextAlignment.Center
        prompts.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        prompts.textColor = UIColor.whiteColor()
        prompts.font = UIFont(name:"HelveticaNeue-Bold" , size: 20)
        
        prompts.autoresizingMask = [.FlexibleTopMargin,.FlexibleWidth]
        
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

    
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        
        regeo.location = AMapGeoPoint.locationWithLatitude(CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        print("regeo :\(regeo)")
        
        self.search!.AMapReGoecodeSearch(regeo)
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
    func mapView(mapView: MAMapView , didUpdateUserLocation userLocation: MAUserLocation ) {
        print("location :\(userLocation.location)")
    }
    
    func mapView(mapView: MAMapView, viewForAnnotation annotation: MAAnnotation) -> MAAnnotationView? {
        
        if annotation.isKindOfClass(MAPointAnnotation) {
            let annotationIdentifier = "invertGeoIdentifier"
            
            var poiAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) as? MAPinAnnotationView
            
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
    func mapView(mapView: MAMapView, rendererForOverlay overlay: MAOverlay) -> MAOverlayRenderer? {
        
        if overlay.isKindOfClass(MACircle) {
            let renderer: MACircleRenderer = MACircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.greenColor().colorWithAlphaComponent(0.4)
            renderer.strokeColor = UIColor.redColor()
            renderer.lineWidth = 4.0
            
            return renderer
        }
        
        return nil
    }
}

extension MapViewController1 : AMapSearchDelegate{
    // - (void)search:(id)searchRequest error:(NSString*)errInfo;
    func search(searchRequest: AnyObject, error errInfo: String) {
        print("request :\(searchRequest), error: \(errInfo)")
        
    }
    
    //    - (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
    func onReGeocodeSearchDone(request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        
        print("request :\(request)")
        print("response :\(response)")
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = response.regeocode.formattedAddress
            annotation.subtitle = response.regeocode.addressComponent.province
            mapView!.addAnnotation(annotation)
            
            let overlay = MACircle(centerCoordinate: coordinate, radius: 50.0)
            mapView!.addOverlay(overlay)
        }
    }

}


extension MapViewController1 : UIGestureRecognizerDelegate{
    /// Handle Gesture
    
    //    - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began {
            let coordinate = mapView!.convertPoint(gesture.locationInView(self.view), toCoordinateFromView: mapView)
            
            searchReGeocodeWithCoordinate(coordinate)
            
        }
    }
    
}

