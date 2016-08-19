//
//  MapViewController.swift
//  Housing
//
//  Created by Ethan on 16/8/18.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (MapViewController)
class MapViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        titles = [["常规地图显示","轨迹地图显示","离线地图"]]
        classNames = [["MapViewController1","MainViewController","OfflineDetailViewController"]]
        initTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let className : String  = (classNames.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? String)!
        let type   = NSClassFromString(className) as? UIViewController.Type
        
        if let subViewController =  type {
            let controller = subViewController.init()
            controller.title = titles.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as? String
            if let titleName = controller.title {
                if  let con = controller as? BaseViewController {
                    con.ViewControllerTitle = titleName
                }
            }else{
                if controller is OfflineDetailViewController {
                    let con = controller as! OfflineDetailViewController
                
                    let mapView = MAMapView(frame: self.view.bounds)
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
                    self.navigationController?.pushViewController(con, animated: true)
                    return

                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
