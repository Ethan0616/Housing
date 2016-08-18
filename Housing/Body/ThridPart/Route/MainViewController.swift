//
//  MainViewController.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import UIKit

@objc (MainViewController)
class MainViewController: BaseViewController, MAMapViewDelegate {
    
    var mapView: MAMapView?
    var isRecording: Bool = false
    var locationButton: UIButton?
    var imageLocated: UIImage?
    var imageNotLocate: UIImage?
    var currentRoute: Route?
    var tipView: TipView?
    var statusView: StatusView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.edgesForExtendedLayout = UIRectEdge.None
        
        initToolBar()
        initMapView()
        initTipView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tipView!.frame = CGRectMake(0, CGRectGetHeight(view.bounds) - 30, CGRectGetWidth(view.bounds), 30)
    }

    /// Initialization
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        self.view.sendSubviewToBack(mapView!)
        
        mapView!.showsUserLocation = true
        mapView!.userTrackingMode = MAUserTrackingMode.Follow
        
        mapView!.distanceFilter = 10.0
        mapView!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        mapView!.setZoomLevel(15.1, animated: true)
    }
    
    func initToolBar() {
        
        let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_list.png"), style: .Done, target: self, action: #selector(MainViewController.actionHistory))
        
        navigationItem.rightBarButtonItem = rightButtonItem
        
        let leftButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_play.png"), style: .Done, target: self, action: #selector(MainViewController.actionRecordAndStop))

        navigationItem.leftBarButtonItem = leftButtonItem
        
        imageLocated = UIImage(named: "location_yes.png")
        imageNotLocate = UIImage(named: "location_no.png")
        
        locationButton = UIButton(frame: CGRectMake(20, CGRectGetHeight(view.bounds) - 80, 40, 40))
        locationButton!.autoresizingMask = [.FlexibleRightMargin,.FlexibleTopMargin]
        locationButton!.backgroundColor = UIColor.whiteColor()
        locationButton!.layer.cornerRadius = 5
        locationButton!.layer.shadowColor = UIColor.blackColor().CGColor
        locationButton!.layer.shadowOffset = CGSizeMake(5, 5)
        locationButton!.layer.shadowRadius = 5
        
        locationButton!.addTarget(self, action: #selector(MainViewController.actionLocation(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        locationButton!.setImage(imageNotLocate, forState: UIControlState.Normal)
        
        view.addSubview(locationButton!)
    }
    
    func initTipView() {
        
        tipView = TipView(frame: CGRectMake(0, 0, CGRectGetWidth(view.bounds), 30))
        view.addSubview(tipView!)
        
        statusView = StatusView(frame: CGRectMake(5, 35, 150, 150))
        
        statusView!.showStatusInfo(nil)
        
        view.addSubview(statusView!)
        
    }
    
    /// Action
    
    func stopLocationIfNeeded() {
        if !isRecording {
            print("stop location")
            mapView!.setUserTrackingMode(MAUserTrackingMode.None, animated: false)
            mapView!.showsUserLocation = false
        }
    }
    
    func actionHistory() {
        print("actionHistory")
        
        let historyController = RecordViewController(nibName: nil, bundle: nil)
        historyController.title = "Records"
        
        navigationController!.pushViewController(historyController, animated: true)
    }
    
    func actionRecordAndStop() {
        print("actionRecord")
        
        isRecording = !isRecording
        
        if isRecording {
            
            showTip("Start recording...")
            navigationItem.leftBarButtonItem!.image = UIImage(named: "icon_stop.png")
            
            if currentRoute == nil {
                currentRoute = Route()
            }
            
            addLocation(mapView!.userLocation.location)
        }
        else {
            navigationItem.leftBarButtonItem!.image = UIImage(named: "icon_play.png")

            addLocation(mapView!.userLocation.location)
            hideTip()
            saveRoute()
        }

    }
    
    func actionLocation(sender: UIButton) {
        print("actionLocation")
        
        if mapView!.userTrackingMode == MAUserTrackingMode.Follow {
            
            mapView!.setUserTrackingMode(MAUserTrackingMode.None, animated: false)
            mapView!.showsUserLocation = false
        }
        else {
            mapView!.setUserTrackingMode(MAUserTrackingMode.Follow, animated: true)
        }
    }
    
    /// Helpers
    
    func addLocation(location: CLLocation?) {
        let success = currentRoute!.addLocation(location)
        if success {
            showTip("locations: \(currentRoute!.locations.count)")
        }
    }
    
    func saveRoute() {

        if currentRoute == nil {
            return
        }
        
        let name = currentRoute!.title()
        
        let path = FileHelper.recordPathWithName(name)
        
//        print("path: \(path)")
        
        NSKeyedArchiver.archiveRootObject(currentRoute!, toFile: path!)
        
        currentRoute = nil
    }
    
    func showTip(tip: String?) {
        tipView!.showTip(tip)
    }
    
    func hideTip() {
        tipView!.hidden = true
    }
    
    /// MAMapViewDelegate
    
    func mapView(mapView: MAMapView , didUpdateUserLocation userLocation: MAUserLocation ) {
        
        if isRecording {
            // filter the result
            if userLocation.location.horizontalAccuracy < 80.0 {
                
                addLocation(userLocation.location)
            }
        }
        
        let location: CLLocation = userLocation.location
        
        let infoArray: [(String, String)] = [("coordinate", NSString(format: "<%.4f, %.4f>", location.coordinate.latitude, location.coordinate.longitude) as String),
            ("speed", NSString(format: "%.2fm/s(%.2fkm/h)", location.speed, location.speed * 3.6) as String),
            ("accuracy", "\(location.horizontalAccuracy)m"),
            ("altitude", NSString(format: "%.2fm", location.altitude) as String)]
        
        statusView!.showStatusInfo(infoArray)
    }
    
    /** 
    - (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated;
    */
    func mapView(mapView: MAMapView, didChangeUserTrackingMode mode: MAUserTrackingMode, animated: Bool) {
        if mode == MAUserTrackingMode.None {
            locationButton?.setImage(imageNotLocate, forState: UIControlState.Normal)
        }
        else {
            locationButton?.setImage(imageLocated, forState: UIControlState.Normal)
        }
    }

}
