//
//  TableViewController2.swift
//  Housing
//
//  Created by Ethan on 16/8/17.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (TableViewController2)
class TableViewController2: BaseViewController{

    var indexView : MJNIndexView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        self.tableView.frame = view.bounds
        firstAttributesForMJNIndexView()
        reloadTableViewData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableViewData(){
        let tempArr = NSArray(array: ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"])
        
        let sectionArray = NSMutableArray()
        let titleArray = NSMutableArray()
        let classArray = NSMutableArray()
        
        self.sectionTitles = sectionArray
        self.titles = titleArray
        self.classNames = classArray
        
        dispatch_barrier_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            for name in tempArr{
                
                let arr = DataBase.shareDataBase().getAllDataBase(name as! String) as! [DrugSearchModel]
                guard arr.count > 0 else{
                    return
                }
                
                let nameArr = NSMutableArray()
                let textArr = NSMutableArray()
                
                for i in 0..<arr.count{
                    let model = arr[i]
                        nameArr.addObject(model.showName)
                        textArr.addObject(model.factory)
                }
                
                sectionArray.addObject(name)
                titleArray.addObject(nameArr)
                classArray.addObject(textArr)
                
                dispatch_async(dispatch_get_main_queue(), {

                    self.tableView.reloadData()
                })   
            }
        }
    }
    
    func firstAttributesForMJNIndexView(){
        indexView = MJNIndexView()
        indexView.frame = self.tableView.frame
        indexView.backgroundColor = UIColor.yellowColor()
        indexView.dataSource = self
        indexView.getSelectedItemsAfterPanGestureIsFinished = true;
        indexView.font = UIFont(name:"HelveticaNeue" , size: 13.0)
        indexView.selectedItemFont = UIFont(name:"HelveticaNeue-Bold" , size: 40.0)
        indexView.backgroundColor = UIColor.clearColor()
        indexView.curtainColor = nil
        indexView.curtainFade = 0.0
        indexView.curtainStays = false
        indexView.curtainMoves = true
        indexView.curtainMargins = false
        indexView.ergonomicHeight = false
        indexView.upperMargin = 22.0
        indexView.lowerMargin = 22.0
        indexView.rightMargin = 10.0
        indexView.itemsAligment = .Center
        indexView.maxItemDeflection = 100.0
        indexView.rangeOfDeflection = 5
        indexView.fontColor = UIColor.RGBA(0.3, g: 0.3, b: 0.3, a: 1.0)
        indexView.selectedItemFontColor = UIColor.RGBA(0.0, g: 0.0, b: 0.0, a: 1.0)
        indexView.darkening = false
        indexView.fading = true
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

extension TableViewController2 : MJNIndexViewDataSource{
    // you have to implement this method to provide this UIControl with NSArray of items you want to display in your index
    func sectionIndexTitlesForMJNIndexView(indexView: MJNIndexView!) -> [AnyObject]! {
        return []
    }
    
    // you have to implement this method to get the selected index item
    func sectionForSectionMJNIndexTitle(title: String!, atIndex index: Int) {
        
    }
}
