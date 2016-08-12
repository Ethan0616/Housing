//
//  CollectionViewController.swift
//  Housing
//
//  Created by Ethan on 16/8/11.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (CollectionViewController)
class CollectionViewController: BaseViewController {

    private var     collectionView : UICollectionView!
    private var     collectionLayout : CollectionLayout!
    private let     cellColumn                = 3
    private let     cellMargin      : CGFloat = 2
    private let     cellMinHeight   : CGFloat = 50.0;
    private let     cellMaxHeight   : CGFloat = 200.0;
    private let     cell_count = 1000
    private let     section_count = 1
    private let     scroll_offset_y = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionLayout()
        initCollectionView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


private extension CollectionViewController{
    func initCollectionLayout(){
        collectionLayout = CollectionLayout()
        collectionLayout.layoutDelegate = self
    }
    
    func initCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.registerClass(NSClassFromString("CollectionCell"), forCellWithReuseIdentifier: "collectionViewCellIdentifier")
        // 注册cell、sectionHeader、sectionFooter
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
//        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    }
}

extension CollectionViewController : UICollectionViewDataSource,UICollectionViewDelegate,CollectionLayoutDelegate{
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return section_count
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return cell_count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        var cell : UICollectionViewCell?
        
        cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCellIdentifier", forIndexPath: indexPath)
        
        guard let collectionCell = cell as? CollectionCell else{
            return CollectionCell()
        }
        collectionCell.backgroundColor = UIColor.redColor()
        let imageIndex =  arc4random() % 23
        let imageName  = String(format: "%02ld.jpg", imageIndex)

        collectionCell.imageView.image = UIImage(named: imageName)
        
        return collectionCell
    }
    
    // MARK: UICollectionViewDelegate
    // ...
    
    // MARK: CollectionLayoutDelegate
    /*** 确定布局行数的回调 */
    func numberOfColumnWithCollectionView(collectionView:UICollectionView,collectionLayout:CollectionLayout) -> NSInteger{
        return cellColumn
    }
    
    /*** 确定cell的Margin*/
    func marginOfCellWithCollectionView(collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat{
        return cellMargin
    }
    
    
    /*** 确定cell的最小高度*/
    func minHeightOfCellWithCollectionView(collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat{
        return cellMinHeight
    }
    
    /*** 确定cell的最大高度*/
    func maxHeightOfCellWithCollectionView(collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat {
        return cellMaxHeight
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            offsetY = 0
        }
        self.navigationController?.navigationBar.alpha = (CGFloat(scroll_offset_y) - offsetY) / CGFloat(scroll_offset_y)
    }
}

// MARK: CollectionLayout
final class CollectionLayout: UICollectionViewLayout {
    
    weak var layoutDelegate : CollectionLayoutDelegate?
    
    //section的数量
    var numberOfSections : NSInteger!
    
    //section中Cell的数量
    var numberOfCellsInSections : NSInteger!
    
    //瀑布流的行数
    var columnCount : NSInteger!
    
    //cell边距
    var margin : CGFloat!
    
    //cell的最小高度
    var cellMinHeight : CGFloat!
    
    //cell的最大高度，最大高度比最小高度小，以最小高度为准
    var cellMaxHeight : CGFloat!
    
    //cell的宽度
    var cellWidth : CGFloat!
    
    //存储每列Cell的X坐标
    var cellXArray :NSMutableArray = NSMutableArray()
    
    //存储每个cell的随机高度，避免每次加载的随机高度都不同
    var cellHeightArray : NSMutableArray = NSMutableArray()
    
    //记录每列Cell的最新Cell的Y坐标
    var cellYArray : NSMutableArray = NSMutableArray()
    
    override init() {
        super.init()
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        initData()
   }
    
    // 该方法返回每一个Cell的ContentSize
    override func collectionViewContentSize() -> CGSize {
        let height = maxCellYInArray(cellYArray)
        
        return CGSizeMake((self.collectionView?.bounds.width) ?? 0.0, height)
    }
    // 该方法为每个Cell绑定一个Layout属性
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        initCellYArray()
        var arrayM : [UICollectionViewLayoutAttributes] = []
        for i in 0..<numberOfCellsInSections{
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let attributes : UICollectionViewLayoutAttributes? = self.layoutAttributesForItemAtIndexPath(indexPath)
            if let attr = attributes {
                arrayM.append(attr)
            }else{
                print("----------------------------------------!")
            }
        }
        
        return arrayM
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let cellHeight = cellHeightArray[indexPath.row] as! CGFloat
        let minYindex = minCellYInArray(cellYArray)
        let tempX : CGFloat = cellXArray[minYindex] as! CGFloat
        let tempY : CGFloat = cellYArray[minYindex] as! CGFloat
        
        let frame : CGRect =  CGRectMake(tempX, tempY, cellWidth, cellHeight)
        //更新相应的Y坐标
        cellYArray[minYindex] = tempY + cellHeight + margin
        //计算每个Cell的位置
        attributes.frame = frame
        
        return attributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:  privateMethod
    func initData(){
        numberOfSections = self.collectionView?.numberOfSections()
        numberOfCellsInSections = self.collectionView?.numberOfItemsInSection(0)
        columnCount = self.layoutDelegate?.numberOfColumnWithCollectionView(self.collectionView!, collectionLayout: self)
        margin = self.layoutDelegate?.marginOfCellWithCollectionView(self.collectionView!, collectionLayout: self)
        cellMinHeight = self.layoutDelegate?.minHeightOfCellWithCollectionView(self.collectionView!, collectionLayout: self)
        cellMaxHeight = self.layoutDelegate?.maxHeightOfCellWithCollectionView(self.collectionView!, collectionLayout: self)
        
        initWidthArray()
        
        initHeightArray()
    }
    func initWidthArray(){
        //计算每个Cell的宽度
        cellWidth = ((self.collectionView?.bounds.size.width)! - (CGFloat(columnCount) - 1) * margin) / CGFloat(columnCount)
        //为每个Cell计算X坐标
        cellXArray = NSMutableArray(capacity: columnCount)
        for i in 0..<columnCount{
            let tempx : CGFloat = CGFloat(i) * (cellWidth + margin)
            cellXArray.insertObject(tempx, atIndex: i)
        }
    }
    func initHeightArray(){
        //随机生成Cell的高度
        cellHeightArray = NSMutableArray(capacity: numberOfCellsInSections)
        for i in 0..<numberOfCellsInSections{
            let cellHeight : CGFloat = CGFloat(arc4random()) % cellMaxHeight + cellMinHeight
            cellHeightArray.insertObject(cellHeight, atIndex: i)
        }
    }
    func initCellYArray(){
        cellYArray = NSMutableArray(capacity:columnCount)
        for _ in 0..<columnCount {
            cellYArray.addObject(0)
        }
    }
    
    // MARK:  Tools
    func maxCellYInArray(arr : NSMutableArray) -> CGFloat{
        guard arr.count > 0 else{
            return 0.0
        }
        
        var max : CGFloat = arr.firstObject as! CGFloat
        for obj in arr {
            let tempObj = obj as! CGFloat
            if tempObj > max {
                max = tempObj
            }
        }
        
        return max
    }
    // 取回索引最小
    func minCellYInArray(arr : NSMutableArray) -> NSInteger{
        guard arr.count > 0 else{
            return 0
        }
        var minIndex : NSInteger = 0
        var min : CGFloat = arr.firstObject as! CGFloat
        for i in 0..<arr.count {
            
            let tempObj = arr[i] as! CGFloat
            if tempObj < min {
                min = tempObj
                minIndex = i
            }
            
        }
        
        return minIndex
    }
    
}

@objc protocol CollectionLayoutDelegate : NSObjectProtocol {
    
    /*** 确定布局行数的回调 */
    func numberOfColumnWithCollectionView(collectionView:UICollectionView,collectionLayout:CollectionLayout) -> NSInteger
    
    /*** 确定cell的Margin*/
    func marginOfCellWithCollectionView(collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat
    

    /*** 确定cell的最小高度*/
    func minHeightOfCellWithCollectionView(collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat
    
    /*** 确定cell的最大高度*/
    func maxHeightOfCellWithCollectionView(collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat
    
}

// MARK: CELL
@objc (CollectionCell)
final class CollectionCell : UICollectionViewCell{
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .ScaleAspectFill
        self.clipsToBounds = true
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




