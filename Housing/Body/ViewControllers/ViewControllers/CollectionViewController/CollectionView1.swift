//
//  CollectionView1.swift
//  Housing
//
//  Created by Ethan on 16/8/16.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (CollectionView1)
class CollectionView1: BaseViewController {
    
    fileprivate var     collectionView : UICollectionView!
    fileprivate var     collectionLayout : CollectionLayout!
    fileprivate let     cellColumn                = 3
    fileprivate let     cellMargin      : CGFloat = 2
    fileprivate let     cellMinHeight   : CGFloat = 50.0;
    fileprivate let     cellMaxHeight   : CGFloat = 200.0;
    fileprivate let     cell_count = 1000
    fileprivate let     section_count = 1
    fileprivate let     scroll_offset_y = 300
    
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


private extension CollectionView1{
    func initCollectionLayout(){
        collectionLayout = CollectionLayout()
        collectionLayout.layoutDelegate = self
    }
    
    func initCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.register(NSClassFromString("CollectionCell"), forCellWithReuseIdentifier: "collectionViewCellIdentifier")
        // 注册cell、sectionHeader、sectionFooter
        //        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
        //        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        //        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    }
}

extension CollectionView1 : UICollectionViewDataSource,UICollectionViewDelegate,CollectionLayoutDelegate{
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return section_count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return cell_count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var cell : UICollectionViewCell?
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCellIdentifier", for: indexPath)
        
        guard let collectionCell = cell as? CollectionCell else{
            return CollectionCell()
        }
        collectionCell.backgroundColor = UIColor.red
        let imageIndex =  arc4random() % 23
        let imageName  = String(format: "%02ld.jpg", imageIndex)
        
        collectionCell.imageView.image = UIImage.imageWithASName(imageName)
        return collectionCell
    }
    
    // MARK: UICollectionViewDelegate
    // ...
    
    // MARK: CollectionLayoutDelegate
    /*** 确定布局行数的回调 */
    func numberOfColumnWithCollectionView(_ collectionView:UICollectionView,collectionLayout:CollectionLayout) -> NSInteger{
        return cellColumn
    }
    
    /*** 确定cell的Margin*/
    func marginOfCellWithCollectionView(_ collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat{
        return cellMargin
    }
    
    
    /*** 确定cell的最小高度*/
    func minHeightOfCellWithCollectionView(_ collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat{
        return cellMinHeight
    }
    
    /*** 确定cell的最大高度*/
    func maxHeightOfCellWithCollectionView(_ collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat {
        return cellMaxHeight
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    
    override func prepare() {
        super.prepare()
        initData()
    }
    
    // 该方法返回每一个Cell的ContentSize
    override var collectionViewContentSize : CGSize {
        let height = maxCellYInArray(cellYArray)
        
        return CGSize(width: (self.collectionView?.bounds.width) ?? 0.0, height: height)
    }
    // 该方法为每个Cell绑定一个Layout属性
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        initCellYArray()
        var arrayM : [UICollectionViewLayoutAttributes] = []
        for i in 0..<numberOfCellsInSections{
            let indexPath = IndexPath(item: i, section: 0)
            let attributes : UICollectionViewLayoutAttributes? = self.layoutAttributesForItem(at: indexPath)
            if let attr = attributes {
                arrayM.append(attr)
            }else{
                print("----------------------------------------!")
            }
        }
        
        return arrayM
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let cellHeight = cellHeightArray[indexPath.row] as! CGFloat
        let minYindex = minCellYInArray(cellYArray)
        let tempX : CGFloat = cellXArray[minYindex] as! CGFloat
        let tempY : CGFloat = cellYArray[minYindex] as! CGFloat
        
        let frame : CGRect =  CGRect(x: tempX, y: tempY, width: cellWidth, height: cellHeight)
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
        numberOfSections = self.collectionView?.numberOfSections
        numberOfCellsInSections = self.collectionView?.numberOfItems(inSection: 0)
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
            cellXArray.insert(tempx, at: i)
        }
    }
    func initHeightArray(){
        //随机生成Cell的高度
        cellHeightArray = NSMutableArray(capacity: numberOfCellsInSections)
        for i in 0..<numberOfCellsInSections{
            let cellHeight : CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: cellMaxHeight) + cellMinHeight
            cellHeightArray.insert(cellHeight, at: i)
        }
    }
    func initCellYArray(){
        cellYArray = NSMutableArray(capacity:columnCount)
        for _ in 0..<columnCount {
            cellYArray.add(0)
        }
    }
    
    // MARK:  Tools
    func maxCellYInArray(_ arr : NSMutableArray) -> CGFloat{
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
    func minCellYInArray(_ arr : NSMutableArray) -> NSInteger{
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
    func numberOfColumnWithCollectionView(_ collectionView:UICollectionView,collectionLayout:CollectionLayout) -> NSInteger
    
    /*** 确定cell的Margin*/
    func marginOfCellWithCollectionView(_ collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat
    
    
    /*** 确定cell的最小高度*/
    func minHeightOfCellWithCollectionView(_ collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat
    
    /*** 确定cell的最大高度*/
    func maxHeightOfCellWithCollectionView(_ collectionView:UICollectionView,collectionLayout:CollectionLayout) -> CGFloat
    
}

// MARK: CELL
@objc (CollectionCell)
final class CollectionCell : UICollectionViewCell{
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
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


