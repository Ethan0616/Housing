//
//  Route.swift
//  MyRoute
//
//  Created by xiaoming han on 14-7-21.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

import Foundation

class Route: NSObject, NSCoding {
    
    let distanceFilter: CLLocationDistance = 10
    
    var startTime: Date
    var endTime: Date
    var locations: NSMutableArray
    
    override init() {
        
        startTime = Date()
        endTime = startTime
        locations = NSMutableArray()
        
        
    }
    
    deinit {
//        print("deinit")
    }
    
    /// NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(startTime, forKey: "startTime")
        aCoder.encode(endTime, forKey: "endTime")
        aCoder.encode(locations, forKey: "locations")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        startTime = aDecoder.decodeObject(forKey: "startTime") as! Date
        endTime = aDecoder.decodeObject(forKey: "endTime") as! Date
        locations = aDecoder.decodeObject(forKey: "locations") as! NSMutableArray
    }
    
    /// Interface
    
    func addLocation(_ location: CLLocation?) -> Bool {
        
        if location == nil {
            return false
        }
        
        let lastLocation: CLLocation? = locations.lastObject as? CLLocation
        
        if lastLocation != nil {
            
            let distance: CLLocationDistance = lastLocation!.distance(from: location!)
            
            if distance < distanceFilter {
                return false
            }
        }
        
        locations.add(location!)
        endTime = Date()
        
        return true
    }
    
    func title() -> String! {
        
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        
        return formatter.string(from: self.startTime)
    }
    
    func detail() -> String! {
        return NSString(format: "p: %d, d: %.2fm, t: %@", locations.count, totalDistance(), formattedDuration(totalDuration())) as String
    }
    
    func startLocation() -> CLLocation? {
        
        if locations.count == 0 {
            return nil
        }
        
        return locations.firstObject as? CLLocation
    }
    
    func endLocation() -> CLLocation? {
        
        if locations.count == 0 {
            return nil
        }
        
        return locations.lastObject as? CLLocation
    }
    // 总距离
    func totalDistance() -> CLLocationDistance {
        
        var distance: CLLocationDistance = 0
        if locations.count > 1 {
            
            var currentLocation: CLLocation?
            
            for location: Any in locations {
                
                let loc = location as! CLLocation

                if currentLocation != nil {
                    distance += loc.distance(from: currentLocation!)
                }
                currentLocation = loc
            }
            
        }

        return distance
    }
    
    func totalDuration() -> TimeInterval {
        
        return endTime.timeIntervalSince(startTime)
    }
    // 持续时间
    func formattedDuration(_ duration: TimeInterval) -> String {

        var component: [Double] = [0, 0, 0]
        var t = duration
        
        for i in 0 ..< component.count {
            component[i] = t.truncatingRemainder(dividingBy: 60.0)
            t /= 60.0
        }
        
        return NSString(format: "%.0fh %.0fm %.0fs", component[2], component[1], component[0]) as String
    }
    
    func coordinates() -> [CLLocationCoordinate2D]! {
        
        var coordinates: [CLLocationCoordinate2D] = []
        if locations.count > 1 {
            
            for location: Any in locations {
                
                let loc = location as! CLLocation
                
                coordinates.append(loc.coordinate)
            }
        }
        return coordinates
    }
}
