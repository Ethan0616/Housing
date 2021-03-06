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
        
        DispatchQueue.global().async { 
            for name in tempArr{
                
                let arr = DataBase.share().getAllDataBase(name as! String) as! [DrugSearchModel]
                guard arr.count > 0 else{
                    continue
                }
                
                let nameArr = NSMutableArray()
                let textArr = NSMutableArray()
                
                for i in 0..<arr.count{
                    let model = arr[i]
                    nameArr.add(model.showName)
                    textArr.add(model.factory)
                }
                
                sectionArray.add(name)
                titleArray.add(nameArr)
                classArray.add(textArr)
                
                DispatchQueue.main.async(execute: {
                    
                    self.tableView.reloadData()
                    self.indexView.refreshIndexItems()
                })
            }
        }

    }
    
    func firstAttributesForMJNIndexView(){
        indexView = MJNIndexView()
        indexView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height - 64)
        indexView.backgroundColor = UIColor.yellow
        indexView.dataSource = self
        indexView.getSelectedItemsAfterPanGestureIsFinished = true;
        indexView.font = UIFont(name:"HelveticaNeue" , size: 13.0)
        indexView.selectedItemFont = UIFont(name:"HelveticaNeue-Bold" , size: 20)
        indexView.backgroundColor = UIColor.clear
        indexView.curtainColor = nil
        indexView.curtainFade = 0.0
        indexView.curtainStays = false
        indexView.curtainMoves = true
        indexView.curtainMargins = false
        indexView.ergonomicHeight = false
        indexView.upperMargin = 22.0
        indexView.lowerMargin = 22.0
        indexView.rightMargin = 10.0
        indexView.itemsAligment = .center
        indexView.maxItemDeflection = 100.0
        indexView.rangeOfDeflection = 5
        indexView.fontColor = UIColor.RGBA(0.3, g: 0.3, b: 0.3, a: 1.0)
        indexView.selectedItemFontColor = UIColor.RGBA(0.0, g: 0.0, b: 0.0, a: 1.0)
        indexView.darkening = false
        indexView.fading = true
        view.addSubview(indexView)
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
    public func sectionIndexTitles(for indexView: MJNIndexView!) -> [Any]! {
        return self.sectionTitles as [AnyObject]
    }



    // you have to implement this method to provide this UIControl with NSArray of items you want to display in your index
    func sectionIndexTitles(for indexView: MJNIndexView!) -> [AnyObject]! {
        return self.sectionTitles as [AnyObject]
    }
    
    // you have to implement this method to get the selected index item
    func section(forSectionMJNIndexTitle title: String!, at index: Int) {
        self.tableView .scrollToRow(at: IndexPath(item: 0, section: index), at: .top, animated: true)
    }
}
