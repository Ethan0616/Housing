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
        self.edgesForExtendedLayout = UIRectEdge()
        
        initToolBar()
        initMapView()
        initTipView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tipView!.frame = CGRect(x: 0, y: view.bounds.height - 30, width: view.bounds.width, height: 30)
    }

    /// Initialization
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView!.delegate = self
        self.view.addSubview(mapView!)
        self.view.sendSubview(toBack: mapView!)
        
        mapView!.showsUserLocation = true
        mapView!.userTrackingMode = MAUserTrackingMode.follow
        
        mapView!.distanceFilter = 10.0
        mapView!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        mapView!.setZoomLevel(15.1, animated: true)
    }
    
    func initToolBar() {
        
        let rightButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage.init(asName: "icon_list.png", directory: "resource") , style: .done, target: self, action: #selector(MainViewController.actionHistory))
        
        navigationItem.rightBarButtonItem = rightButtonItem
        
        let leftButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage.init(asName: "icon_play.png", directory: "resource") , style: .done, target: self, action: #selector(MainViewController.actionRecordAndStop))

        navigationItem.leftBarButtonItem = leftButtonItem
        
        imageLocated = UIImage.init(asName: "location_yes.png", directory: "resource")
        imageNotLocate = UIImage.init(asName: "location_no.png", directory: "resource")
        
        locationButton = UIButton(frame: CGRect(x: 20, y: view.bounds.height - 80, width: 40, height: 40))
        locationButton!.autoresizingMask = [.flexibleRightMargin,.flexibleTopMargin]
        locationButton!.backgroundColor = UIColor.white
        locationButton!.layer.cornerRadius = 5
        locationButton!.layer.shadowColor = UIColor.black.cgColor
        locationButton!.layer.shadowOffset = CGSize(width: 5, height: 5)
        locationButton!.layer.shadowRadius = 5
        
        locationButton!.addTarget(self, action: #selector(MainViewController.actionLocation(_:)), for: UIControlEvents.touchUpInside)
        
        locationButton!.setImage(imageNotLocate, for: UIControlState())
        
        view.addSubview(locationButton!)
    }
    
    func initTipView() {
        
        tipView = TipView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        view.addSubview(tipView!)
        
        statusView = StatusView(frame: CGRect(x: 5, y: 35, width: 150, height: 150))
        
        statusView!.showStatusInfo(nil)
        
        view.addSubview(statusView!)
        
    }
    
    /// Action
    
    func stopLocationIfNeeded() {
        if !isRecording {
            print("stop location")
            mapView!.setUserTrackingMode(MAUserTrackingMode.none, animated: false)
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
            navigationItem.leftBarButtonItem!.image = UIImage.init(asName: "icon_stop.png", directory: "resource")
            
            if currentRoute == nil {
                currentRoute = Route()
            }
            
            addLocation(mapView!.userLocation.location)
        }
        else {
            navigationItem.leftBarButtonItem!.image = UIImage.init(asName: "icon_play.png", directory: "resource")

            addLocation(mapView!.userLocation.location)
            hideTip()
            saveRoute()
        }

    }
    
    func actionLocation(_ sender: UIButton) {
        print("actionLocation")
        
        if mapView!.userTrackingMode == MAUserTrackingMode.follow {
            
            mapView!.setUserTrackingMode(MAUserTrackingMode.none, animated: false)
            mapView!.showsUserLocation = false
        }
        else {
            mapView!.setUserTrackingMode(MAUserTrackingMode.follow, animated: true)
        }
    }
    
    /// Helpers
    
    func addLocation(_ location: CLLocation?) {
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
    
    func showTip(_ tip: String?) {
        tipView!.showTip(tip)
    }
    
    func hideTip() {
        tipView!.isHidden = true
    }
    
    /// MAMapViewDelegate
    
    fileprivate func mapView(_ mapView: MAMapView , didUpdateUserLocation userLocation: MAUserLocation ) {
        
        if isRecording {
            // filter the result
            if userLocation.location.horizontalAccuracy < 80.0 && userLocation.location.horizontalAccuracy > 0 {
                
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
    func mapView(_ mapView: MAMapView, didChange mode: MAUserTrackingMode, animated: Bool) {
        if mode == MAUserTrackingMode.none {
            locationButton?.setImage(imageNotLocate, for: UIControlState())
        }
        else {
            locationButton?.setImage(imageLocated, for: UIControlState())
        }
    }

}
