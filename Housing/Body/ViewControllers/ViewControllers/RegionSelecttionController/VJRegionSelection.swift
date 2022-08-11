//
//  VJRegionSelection.swift
//  AreaView
//
//  Created by Ethan on 2022/8/3.
//

import UIKit


@objc
protocol VJRegionSelectionProtocol : NSObjectProtocol {
    
//    func didSelectedRegion(Item item : [[VJRegionItem]],DictArr dictArr:[NSDictionary], Text text : NSString)
    func didSelectedRegionWith(_ item : VJRegionModel)
}
fileprivate var localDataArr : [VJRegionItem]! = []
fileprivate let orignInitials : [String] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
fileprivate var hideSwitchBtn : Bool = true // 包含港澳台
fileprivate let viewSpace : CGFloat = 45  // cell高度
fileprivate let exitBtnWH : CGFloat = 44.0  // 退出按钮大小
fileprivate let leftMargin : CGFloat = 22.0 // 左侧边距
fileprivate let wordMargin : CGFloat = 0    // 多子标题的文字间距
fileprivate let subTitleNormalWord : String = "请选择"
fileprivate let mainScreen : CGRect =  {
    return  VJRegionSelection.keyWindow.bounds
}()
@objc
class VJRegionSelection: UIView {
    
    /// 预加载数据
    @objc
    public static func loadData() {
        VJRegionItem.loadLocalPlist()
    }
    
    @objc
    public static func showRegionView(_ item : VJRegionModel? = nil, _ delegate : VJRegionSelectionProtocol? = nil) {
        
        let window = VJRegionSelection.keyWindow
        loadData()
        let regionView = VJRegionSelection(frame: mainScreen)
        regionView.delegate = delegate
        DispatchQueue.main.async {
            window.addSubview(regionView)
        }
        guard let model : VJRegionModel = item else { return }

        regionView.triggerCurrentSelection(model)
    }
    
    
    /// 在cell中显示当前选择，更新subTitle 信息等操作
    /// - Parameter model: 具体选中行
    private func triggerCurrentSelection(_ model : VJRegionModel) {
        
        var tempCurrentIndex : [(Int,Int)] = []
        let currentTempArr : [[VJRegionItem]] = dataArr
        var tempArr : [[VJRegionItem]] = currentTempArr
        let countNum = VJRegionModel.getCurrentIndex(model)
        
        func createCurrentIndex(_ ID : NSString, _ currentIndex : inout [(Int,Int)] , _ tempArr :inout [[VJRegionItem]]) {
            for i in 0..<(tempArr.count ) {
                for j in 0..<(tempArr[i].count) {
                    
                    let item = tempArr[i][j]
                    if let IDStr : NSString = item.ID as NSString? ,IDStr.isEqual(to: ID as String) {
                        currentIndex.append((i,j))
                        if item.hasChild {
                            tempArr = item.dataArr
                            return
                        }
                    }
                }
            }
        }
        
        [Int](0...countNum).forEach { index in
            var titleName : NSString = ""
            var currentID : NSString = ""
            switch index {
                case 0 :
                titleName = model.province
                currentID = model.provinceID
                curIndex = 0
                    break
                case 1 :
                titleName = model.city
                currentID = model.cityID
                curIndex = 1
                    break
                case 2 :
                titleName = model.region
                currentID = model.regionID
                curIndex = 2
                break
                case 3 :
                titleName = model.town
                currentID = model.townID
                curIndex = 3
                break
            default :
                break
            }
            // 更新Subtitle名称
            createBtnWithTitleName(titleName as String)
            // 更新数据源具体编号
            createCurrentIndex(currentID, &tempCurrentIndex, &tempArr)
            
        }
        
        // 刷新页面
        if tempCurrentIndex.count > 0 {
            currentIndex = tempCurrentIndex
            var tempArr : [[VJRegionItem]] = dataArr
            var item : VJRegionItem! = VJRegionItem()
            for (section,row) in currentIndex[0..<curIndex] {
                item = tempArr[section][row]
                if item.hasChild {
                    tempArr = item.dataArr
                    tempDataArr = item.dataArr
                    initials = item.initials
                }
            }
            
            selectedTableView.reloadData()
            displayView.indexView.refreshIndexItems()
        }
    }
    
    
    @objc weak var delegate : VJRegionSelectionProtocol?
    
    fileprivate var curIndex : Int = 0
    fileprivate var btnIndex : Int = -1 // 生成的按钮总个数 4321 + tag
    private     var nextBtnWidth : CGFloat = 0 // 下一个按钮的 originX
    fileprivate var currentIndex : [(section :Int,row:Int)] = [] // 值:index   位置：列
    fileprivate var initials : [String] = []
    fileprivate var provinceInitials : [String] = []
    fileprivate var dataArr : [[VJRegionItem]] = []
    fileprivate var tempDataArr : [[VJRegionItem]] = []

    fileprivate weak var scrollView : UIScrollView!
    
    fileprivate var selectedTableView : UITableView!
    
    // 对外的比例
    private(set) var screenHeight : CGFloat = 0.8
    
    // 黑色背景
    private lazy var bgView : UIView = {
        let aview = UIView(frame: mainScreen)
        aview.backgroundColor = UIColor.black
        aview.alpha = 0.4
        return aview
    }()
    
    // 遮盖底边圆角
    private lazy var bottomView : UIView = {
        let aview = UIView(frame: CGRect(x: 0, y: mainScreen.height - 64, width: mainScreen.width, height: 64))
        aview.backgroundColor = UIColor.white
        return aview
    }()
    
    // 白色显示区域
    private lazy var displayView : VJDisplayView = {
        let aview = VJDisplayView(frame: CGRect(x: 0, y: 0, width: mainScreen.width, height: mainScreen.height * screenHeight))
        aview.backgroundColor = UIColor.white
        aview.scrollView.contentSize = CGSize(width: mainScreen.width, height: aview.bounds.height - viewSpace * 3 - (hideSwitchBtn ? 0 : viewSpace))
//        aview.scrollView.contentSize = CGSize(width: mainScreen.width * 3, height: aview.bounds.height - viewSpace * 3 - (hideSwitchBtn ? viewSpace : 0))
        let tempScrollView = UIScrollView(frame: CGRect(x: 0, y: 0,
                                                        width: mainScreen.width - leftMargin * 2,
                                                        height: viewSpace))

        aview.subTitleView.addSubview(tempScrollView)
        scrollView = tempScrollView
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsHorizontalScrollIndicator = false
        createBtnWithTitleName(subTitleNormalWord)
        
        return aview
    }()
    
    
    private func removeAllSubTitleBtns() {
        scrollView.subviews
            .compactMap{$0 as? UIButton}
            .forEach { $0.removeFromSuperview() }
        nextBtnWidth = 0 //
    }
    
    @discardableResult
    private func createBtnWithTitleName(_ name : String) -> UIButton {
        removeNormalButton()
        let btn = UIButton(type: .custom)
        btn.setTitle(name, for: .normal)
        btn.setTitle(name, for: .highlighted)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.setTitleColor(UIColor.red, for: .highlighted)
        btn.sizeToFit()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        btnIndex += 1
        btn.tag = 4321 + btnIndex
        btn.addTarget(self, action: #selector(titleBtnAction(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: nextBtnWidth, y: 0, width: btn.bounds.size.width, height: viewSpace)
        nextBtnWidth = btn.frame.origin.x + btn.frame.size.width + wordMargin
        resetButtonNormalColor()
        scrollView.contentSize = CGSize(width: nextBtnWidth, height: viewSpace)
        scrollView.addSubview(btn)

        btn.isHighlighted = true

        return btn
    }
    
    /// 刷新当前页面的按钮显示
    private func refreshSubTitleBtns() {
        removeAllSubTitleBtns()
        btnIndex = -1
        var tempArr : [[VJRegionItem]] = dataArr
        var item : VJRegionItem! = VJRegionItem()
        var index : Int = 0
        createBtnWithTitleName(subTitleNormalWord)
        for (section,row) in currentIndex[0..<curIndex] {
            item = tempArr[section][row]
            createBtnWithTitleName(item.ext_name as String)
            if item.hasChild {
                tempArr = item.dataArr
                if index == curIndex { // 最后一个，还有下一级
                    createBtnWithTitleName(subTitleNormalWord)
                    return
                }
            }
            index += 1
        }
    }
    
    /// 更新最后一个按钮的显示
    private func refreshLastBtnTitleNmae(_ name : String ) {
        let btns : [UIButton] = scrollView.subviews.compactMap{$0 as? UIButton}
        .sorted{$0.tag < $1.tag}
        
        if let btn = btns.last {
            
            btn.setTitle(name, for: .normal)
            btn.setTitle(name, for: .highlighted)
            btn.setTitleColor(UIColor.red, for: .normal)
            btn.setTitleColor(UIColor.red, for: .highlighted)
        }
    }
    
    // 移除 请选择按钮,对按钮重新布局
    private func removeNormalButton() {
        // 所有按钮
        let buttons = scrollView.subviews.compactMap{$0 as? UIButton}
        .sorted{$0.tag < $1.tag}
        // 所有默认文字的按钮
        let normalButton = buttons.filter{$0.titleLabel?.text == subTitleNormalWord}
        guard normalButton.count > 0 else { return }
        // 重设frame 移除所有请选择
        var index : Int = 0
        let normalButtonCount = normalButton.count - 1
        var tagFlag : Int = 0
        var currentWidth : CGFloat = 0
        buttons.forEach { btn in
            var containNormalBtn = false
            // 当前按钮为 有默认文字的按钮
            if normalButton.contains(btn) {
                currentWidth += (btn.bounds.width + wordMargin)
                btn.removeFromSuperview()
                tagFlag += 1
                containNormalBtn = true
            } else {
                btn.tag -= tagFlag
            }
            btn.frame = CGRect(x: btn.frame.origin.x - currentWidth, y: btn.frame.origin.y, width: btn.frame.size.width, height: btn.frame.size.height)
            
            // 最后一个 计算完直接结束  需要重设当前originX标记 nextBtnWidth
            if normalButtonCount == index {
                nextBtnWidth = btn.frame.origin.x + btn.frame.size.width
                scrollView.contentSize = CGSize(width: nextBtnWidth, height: viewSpace)
                btnIndex = btn.tag - 4321 - (containNormalBtn ? 1 : 0) // 标记为上一个
                return
            }
            index += 1
        }
    }
    
    // 取消高亮红色
    private func resetButtonNormalColor() {
        scrollView.subviews.compactMap{$0 as? UIButton}
            .forEach{
                $0.setTitleColor(UIColor.black, for: .normal)
                $0.setTitleColor(UIColor.black, for: .highlighted)
            }
    }
    
    private func setButtonRedColor(_ btn : UIButton) {
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.setTitleColor(UIColor.red, for: .highlighted)
    }
    
    @objc func titleBtnAction(_ btn : UIButton) {
        resetButtonNormalColor()
        setButtonRedColor(btn)
        let tag = btn.tag - 4321
//        print("选择第几层\(tag)")
        curIndex = tag
        reloadDataWithTag(tag)
    }
    
    
    /// 重新刷新数据源
    /// - Parameter tag: 当前层级
    @objc func reloadDataWithTag(_ tagFlag:Int) {
        
        if tagFlag > currentIndex.count { return } // 越界
//        removeAllSubTitleBtns()
        var  tempArr = dataArr
        var  tempInitials :[String] = provinceInitials
        for (session,row) in currentIndex[0..<tagFlag] {
            let item = tempArr[session][row]
//            createBtnWithTitleName(item.ext_name as String)
            tempArr = item.dataArr
            tempInitials = item.initials
        }
        btnIndex = tagFlag
        curIndex = tagFlag
        tempDataArr = tempArr
        initials = tempInitials
        
        selectedTableView.reloadData()
        displayView.indexView.refreshIndexItems()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(bottomView)
        addSubview(displayView)
        displayView.frame = CGRect(x: 0, y: bounds.height * (1.0 - screenHeight), width: bounds.width, height: bounds.height * screenHeight)
        displayView.exitBtn.addTarget(self, action: #selector(closeBtnAction(_:)), for: .touchUpInside)
        displayView.scrollView.delegate = self
        displayView.indexView.dataSource = self
        addTableView()
        createDataSource(VJRegionItem.loadLocalPlist())
        addTapGesture()
    }
    
    fileprivate func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeBtnAction(_:)))
        bgView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func createDataSource(_ tempData : [VJRegionItem]) {
        
        orignInitials.forEach { prefix_word in
            let arr = tempData.filter{ $0.pinyin_prefix as String == prefix_word.lowercased() }
            if arr.count > 0 {
                provinceInitials.append(prefix_word)
                dataArr.append(arr)
            }
        }
        tempDataArr = dataArr
        initials = provinceInitials
        selectedTableView.reloadData()
        displayView.indexView.refreshIndexItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = bounds
        bottomView.frame = CGRect(x: 0, y: mainScreen.height - 64, width: mainScreen.width, height: 64)
        displayView.frame = CGRect(x: 0, y: bounds.height * (1.0 - screenHeight), width: bounds.width, height: bounds.height * screenHeight)
    }
    
    @objc func closeBtnAction(_ sender : UIButton) {
        removeAllViews()
    }
    
    private func removeAllViews() {
        bottomView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.displayView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: self.bounds.height * self.screenHeight)
        } completion: { complete in
            self.bottomView.removeFromSuperview()
            self.displayView.removeFromSuperview()
            self.bgView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    private func addTableView() {
        [Int](0...2).forEach { i in

            let rect = CGRect(x: CGFloat(i) * mainScreen.width, y: 0, width: mainScreen.width, height: displayView.scrollView.contentSize.height)
            let tableView = UITableView(frame: rect, style: .grouped)
            tableView.tag = 12222 + i
            displayView.scrollView.addSubview(tableView)
            tableView.backgroundColor = UIColor.clear
            if 1 == i {
                tableView.backgroundColor = UIColor.green
            }
            tableView.delegate = self
            tableView.dataSource = self
//            tableView.sectionHeaderHeight = 16.0
            tableView.separatorStyle = .none
            if i == 0 {
                selectedTableView = tableView
            }
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}

extension VJRegionSelection : UITableViewDelegate ,UITableViewDataSource , MJNIndexViewDataSource {
    
    func sectionIndexTitles(for indexView: MJNIndexView!) -> [Any]! {
        return initials
    }
    
    func section(forSectionMJNIndexTitle title: String!, at index: Int) {
        selectedTableView.scrollToRow(at: IndexPath(item: 0, section: index), at: .top, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if selectedTableView === tableView {
            return tempDataArr[section].count
        } else {
            return 5
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectedTableView === tableView {
            return  tempDataArr.count
        }
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedTableView === tableView {
            let cell = VJRegionSelectionTableViewCell(style: .value1, reuseIdentifier: "VJRegionSelectionTableViewCell")
      
            let item = tempDataArr[indexPath.section][indexPath.row]
            cell.titleLabel.text = item.ext_name as String?
            cell.nameSelected = false
/// 未完成
//            if curIndex > 0 && currentIndex.count > 0 {
//                let currentIndexPath = currentIndex[curIndex - 1]
//                if indexPath.section == currentIndexPath.section
//                    && indexPath.row ==  currentIndexPath.row {
//
//                    cell.nameSelected = true
//                }
//            }
            
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectedTableView {
            
            let tempArr = getCurrentItems()
            let item = tempArr[indexPath.section][indexPath.row]
            if item.hasChild {
                createBtnWithTitleName(item.ext_name as String)
            } else {
                refreshLastBtnTitleNmae(item.ext_name as String)
            }
            currentIndex.append((indexPath.section,indexPath.row))
            curIndex += 1
            // 有子视图
            if item.hasChild {
                refreshSubTitleBtns()
                
                //            print("section:\(indexPath.section) ; row: \(indexPath.row)")
                tempDataArr = item.dataArr
                initials = item.initials
                selectedTableView.reloadData()
                displayView.indexView.refreshIndexItems()
                createBtnWithTitleName(subTitleNormalWord)
                selectedTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            } else {
                
                resetButtonNormalColor()
                //            print("没有下一级，需要回调")
                //            delegate?.didSelectedRegion(Item: dataArr,
                //                                        DictArr: tupleToDictionary(),
                //                                        Text: getFullAddress())
                let model = createModel()
                self.delegate?.didSelectedRegionWith(model)
                removeAllViews()
            }
        }
    }
    
    private func createModel() -> VJRegionModel {
        let model = VJRegionModel()
        
        var tempArr : [[VJRegionItem]] = dataArr
        var item : VJRegionItem! = VJRegionItem()
        var index : Int = 0
        for (section,row) in currentIndex[0..<curIndex] {
            item = tempArr[section][row]
            model.ID = item.ID
            switch index {
            case 0:
                model.province = item.name
                model.provinceID = item.ID
                break
            case 1:
                model.city = item.name
                model.cityID = item.ID
                break;
            case 2:
                model.region = item.ext_name
                model.regionID = item.ID
                break;
            case 3:
                model.town = item.ext_name
                model.townID = item.ID
                break;
                
            default:
                break;
            }

            if item.hasChild {
                tempArr = item.dataArr
            }
            index += 1
        }
        
        return model
    }
    
    private func tupleToDictionary() -> [NSDictionary] {
        
        var dictArr : [NSDictionary] = []
        
        currentIndex.forEach { (section: Int, row: Int) in

            let dict = NSMutableDictionary()
            dict.setValue(section, forKey: "section")
            dict.setValue(row, forKey: "row")
            dictArr.append(dict)
        }
        return dictArr
    }
    
    private func getFullAddress() -> NSString {
        let resultStr : NSString = ""
        
        var tempArr : [[VJRegionItem]] = dataArr
        var item : VJRegionItem! = VJRegionItem()
        for (section,row) in currentIndex[0..<curIndex] {
            item = tempArr[section][row]
            if item.hasChild {
                tempArr = item.dataArr
            }
        }
        
        return resultStr
    }

    private func getCurrentItems() -> [[VJRegionItem]] {
        refreshCurrentIndex()
        var tempArr : [[VJRegionItem]] = dataArr
        var item : VJRegionItem! = VJRegionItem()
        for (section,row) in currentIndex[0..<curIndex] {
            item = tempArr[section][row]
            if item.hasChild {
                tempArr = item.dataArr
            }
        }
        return tempArr
    }
    
    private func refreshCurrentIndex() {
        guard currentIndex.count > 0 else { return }
        var temp : [(Int,Int)] = []
        for obj in currentIndex[0..<curIndex] {
            temp.append(obj)
        }
        currentIndex = temp
    }
    
    
    /// 处理分区头
    // A-Z
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if selectedTableView === tableView {
            return initials[section]
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectedTableView == tableView {
            return 20
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if selectedTableView === tableView {
            return 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if selectedTableView === tableView {
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: mainScreen.width, height: 0))
            aView.backgroundColor = UIColor.clear
            return aView
        }
        
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectedTableView === tableView {
            let aView = UIView(frame: CGRect(x: 0, y: 0, width: mainScreen.width, height: 20))
            aView.backgroundColor = UIColor.clear
            let label = UILabel(frame: CGRect(x: 20, y: 0, width: 120, height: 20))
            label.text = initials[section]
            label.textColor = UIColor.black
            aView.addSubview(label)
            let lineView = UIView(frame: CGRect(x: 0, y: 19, width: mainScreen.width , height: 1))
            lineView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1)
            aView.addSubview(lineView)
            return aView
        }
        return nil
    }
    
}

extension VJRegionSelection : UIScrollViewDelegate {
    @objc func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

    }
    
    @objc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView === backScroll {
//
//            if imageArr != nil && imageArr.count > 1 {
//
//                // page
//                let pageNum : CGFloat =  (scrollView.contentOffset.x + 0.5 * currentRect.width) / currentRect.width
//
//                if pageNum < 1.0 {
//                    pageController?.selNum = index - 1
//                }else if pageNum > 2.0 {
//                    pageController?.selNum = index + 1
//                }else{
//                    if  index != 0 { // 必须加条件判断，否则会崩
//
//                        pageController?.selNum = index
//                    }
//                }
//                return
//            }
//        }
    }
    
    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

//        if scrollView === backScroll {
//            scrollViewAction()
//
//        }
    }
    
    @objc func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if backScroll === scrollView{
//
//            scrollViewAction()
//        }
    }
}


fileprivate class VJDisplayView : UIView {

    var indexView : MJNIndexView!

    fileprivate lazy var exitBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.backgroundColor = UIColor.red
        btn.setImage(UIImage(named:"icon_close"), for: .normal)
//        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return btn
    }()
    
    fileprivate lazy var titleLabel : UILabel = {
       let aLabel = UILabel()
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        aLabel.text = "请选择所在地区"
        aLabel.font = UIFont.systemFont(ofSize: 18.0)
        aLabel.backgroundColor = UIColor.clear
        return aLabel
    }()
        
    fileprivate lazy var switchBtn0 : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("中国大陆", for: .normal)
        btn.isHidden = hideSwitchBtn
        return btn
    }()
    
    fileprivate lazy var switchBtn1 : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("港澳台及海外", for: .normal)
        btn.isHidden = hideSwitchBtn
        return btn
    }()
    
    fileprivate lazy var switchView : UIView = {
        let aView = UIView()
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.backgroundColor = UIColor.clear
        return aView
    }()
    
    fileprivate lazy var subTitleView : UIView = {
        let aView = UIView()
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.backgroundColor = UIColor.clear
        
        return aView
    }()
    
    fileprivate lazy var scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.clear
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(exitBtn)
        addSubview(titleLabel)
        switchView.addSubview(switchBtn0)
        switchView.addSubview(switchBtn1)
        addSubview(switchView)
        addSubview(subTitleView)
        addSubview(scrollView)
        layoutContainerViews()
        firstAttributesForMJNIndexView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutContainerViews() {
        
        let leadingGuide    = UILayoutGuide()
        let trailingGuide   = UILayoutGuide()
        let topGuide        = UILayoutGuide()
        let bottomGuide     = UILayoutGuide()
        
        addLayoutGuide(topGuide)
        addLayoutGuide(bottomGuide)
        addLayoutGuide(leadingGuide)
        addLayoutGuide(trailingGuide)

        NSLayoutConstraint.activate([
            topGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            topGuide.trailingAnchor.constraint(equalTo: trailingAnchor,constant:mainScreen.width - leftMargin),
            topGuide.topAnchor.constraint(equalTo: topAnchor),
            topGuide.heightAnchor.constraint(equalToConstant: 0),

            bottomGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomGuide.trailingAnchor.constraint(equalTo: trailingAnchor,constant:mainScreen.width - leftMargin),
            bottomGuide.topAnchor.constraint(equalTo: topAnchor,constant: self.bounds.height),
            bottomGuide.heightAnchor.constraint(equalToConstant: 0),
            
            leadingGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin),
            leadingGuide.topAnchor.constraint(equalTo: topAnchor),
            leadingGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            leadingGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            trailingGuide.leadingAnchor.constraint(equalTo: leadingAnchor,constant:mainScreen.width - leftMargin * 2),
            trailingGuide.topAnchor.constraint(equalTo: topAnchor),
            trailingGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            trailingGuide.trailingAnchor.constraint(equalTo: trailingAnchor,constant:mainScreen.width - leftMargin * 2),
            
            
            exitBtn.topAnchor.constraint(equalTo: topAnchor, constant: (viewSpace - exitBtnWH) * 0.5),
            exitBtn.trailingAnchor.constraint(equalTo: trailingGuide.trailingAnchor),
            exitBtn.widthAnchor.constraint(equalToConstant: exitBtnWH),
            exitBtn.heightAnchor.constraint(equalToConstant: exitBtnWH),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: viewSpace),
            titleLabel.trailingAnchor.constraint(equalTo: trailingGuide.trailingAnchor, constant: -exitBtnWH),
            
            switchView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            switchView.leadingAnchor.constraint(equalTo: leadingGuide.leadingAnchor),
            switchView.trailingAnchor.constraint(equalTo: trailingGuide.trailingAnchor),
            switchView.heightAnchor.constraint(equalToConstant: hideSwitchBtn ? 0 : viewSpace),
            
            switchBtn0.topAnchor.constraint(equalTo: switchView.topAnchor),
            switchBtn0.leadingAnchor.constraint(equalTo: switchView.leadingAnchor),
            switchBtn0.bottomAnchor.constraint(equalTo: switchView.bottomAnchor),
//            switchBtn0.widthAnchor.constraint(equalToConstant: 120),
            
            switchBtn1.topAnchor.constraint(equalTo: switchView.topAnchor),
            switchBtn1.leadingAnchor.constraint(equalTo: switchBtn0.trailingAnchor,constant: leftMargin),
            switchBtn1.bottomAnchor.constraint(equalTo: switchView.bottomAnchor),
//            switchBtn1.widthAnchor.constraint(equalToConstant: 120),
            
            subTitleView.topAnchor.constraint(equalTo: switchView.bottomAnchor),
            subTitleView.leadingAnchor.constraint(equalTo: leadingGuide.leadingAnchor),
            subTitleView.heightAnchor.constraint(equalToConstant: viewSpace),
            subTitleView.trailingAnchor.constraint(equalTo: trailingGuide.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: subTitleView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingGuide.leadingAnchor, constant: -leftMargin),
            scrollView.trailingAnchor.constraint(equalTo: trailingGuide.trailingAnchor, constant: leftMargin),
        ])
    }
    
    private func firstAttributesForMJNIndexView() {
        indexView = MJNIndexView(frame: CGRect(x: 0, y: viewSpace * 3 - (hideSwitchBtn ? viewSpace : 0), width: bounds.width, height: bounds.height))
        indexView.getSelectedItemsAfterPanGestureIsFinished = true;
        indexView.font = UIFont(name:"HelveticaNeue" , size: 13.0)
        indexView.selectedItemFont = UIFont(name:"HelveticaNeue-Bold" , size: 20)
        indexView.curtainColor = nil
        indexView.curtainFade = 0.0
        indexView.curtainStays = false
        indexView.curtainMoves = true
        indexView.curtainMargins = false
        indexView.ergonomicHeight = true
        indexView.upperMargin = 22.0
        indexView.lowerMargin = 22.0
        indexView.rightMargin = 10.0
        indexView.itemsAligment = .center
        indexView.maxItemDeflection = 100.0
        indexView.rangeOfDeflection = 2
        indexView.fontColor = UIColor.VJRGBA(r:0.3, g: 0.3, b: 0.3, a: 1.0)
        indexView.selectedItemFontColor = UIColor.VJRGBA(r:0.0, g: 0.0, b: 0.0, a: 1.0)
        indexView.darkening = false
        indexView.fading = true
        indexView.backgroundColor = UIColor.clear
        indexView.minimumGapBetweenItems = 6
        

        addSubview(indexView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(indexView)
    }
}

@objc class VJRegionModel : NSObject {
    @objc var ID          : NSString!
    @objc var province    : NSString! // 省
    @objc var city        : NSString! // 市
    @objc var region      : NSString! // 区
    @objc var town        : NSString! // 县城
    @objc var provinceID     : NSString! // 省
    @objc var cityID         : NSString! // 市
    @objc var regionID       : NSString! // 区
    @objc var townID         : NSString! // 县城
    
    
    /// 当前层级
    /// - Parameter model: 当前对象
    /// - Returns: 层级
    @objc
    static func getCurrentIndex(_ model : VJRegionModel) -> Int {
        var index = -1

        if model.ID.isEqual(to: model.townID as String) {
            index = 3
            return index
        }
        
        if model.ID.isEqual(to: model.regionID as String) {
            index = 2
            return index
        }
        
        if model.ID.isEqual(to: model.cityID as String) {
            index = 1
            return index
        }
        
        if model.ID.isEqual(to: model.provinceID as String) {
            index = 0
            return index
        }
        
        return index
    }
}


@objc class VJRegionItem : NSObject {
    
    var childs      : [VJRegionItem]!
    var deep        : NSNumber!
    var ext_id      : NSString!
    var ext_name    : NSString!
    var ID          : NSString!
    var name        : NSString!
    var pid         : NSNumber!
    var pinyin      : NSString!
    var pinyin_prefix : NSString!
    var hasChild    : Bool = false   // 是否包含子层

    var dataArr     : [[VJRegionItem]]! = []
    var initials    : [String]! = []
    
    @discardableResult
    static func loadLocalPlist()->[VJRegionItem] {
        if localDataArr.count > 0 {
            return localDataArr
        }
//        guard let path = Bundle.main.path(forResource: "area_format_user", ofType: "plist") else { return []}
        guard let path = Bundle.main.path(forResource: "area_format_user", ofType: "json") else { return []}

        let data = NSData(contentsOfFile: path)! as Data
        var arr :NSArray = []
        do {
            arr = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSArray
        }catch {
            print(error)
        }
        localDataArr = createItems(arr)
        
        return localDataArr
    }
    
    static func createItems(_ dataArr : NSArray) -> [VJRegionItem] {
        var regionItems : [VJRegionItem] = []
        dataArr.forEach { item in
            if let dict = item as? NSDictionary {
                let regionItem = createItem(dict)
                regionItems.append(regionItem)
            }
        }
        
        return regionItems
    }
    
    static func createItem(_ dict : NSDictionary) -> VJRegionItem {
        
        let regionItem = VJRegionItem()

        if let deep = dict["deep"] as? NSNumber {
            regionItem.deep = deep
        }
        
        if let ext_id = dict["ext_id"] as? NSString {
            regionItem.ext_id = ext_id
        }
        
        if let ext_name = dict["ext_name"] as? NSString {
            regionItem.ext_name = ext_name
        }
        
        if let ID = dict["id"] as? NSString {
            regionItem.ID = ID
        }
        
        if let name = dict["name"] as? NSString {
            regionItem.name = name
        }
        
        if let pid = dict["pid"] as? NSNumber {
            regionItem.pid = pid
        }
        
        if let pinyin = dict["pinyin"] as? NSString {
            regionItem.pinyin = pinyin
        }
        
        if let pinyin_prefix = dict["pinyin_prefix"] as? NSString {
            regionItem.pinyin_prefix = pinyin_prefix
        }
        
        if let childs = dict["childs"] as? NSArray , childs.count > 0 {
            
            regionItem.childs = createItems(childs)
            regionItem.hasChild = true
            
            orignInitials.forEach {prefix_word in
                let arr = regionItem.childs.filter{ $0.pinyin_prefix as String == prefix_word.lowercased() }
                if arr.count > 0 {
                    regionItem.dataArr.append(arr)
                    regionItem.initials.append(prefix_word)
                }
            }
            regionItem.childs.removeAll()
        } else {
            regionItem.hasChild = false
        }
        
        return regionItem
    }
}


fileprivate extension UIColor {
    class func VJRGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}


class VJRegionSelectionTableViewCell : UITableViewCell {
    private let imageViewHW : CGFloat = 30.0
    private let labelH      : CGFloat = 44.0
    private let labelW      : CGFloat = 200
    lazy var customIV : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "duigou-cu"))
        iv.frame = CGRect(x: 0, y: 0, width: imageViewHW, height: imageViewHW)
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    
    lazy var titleLabel : UILabel = {
       let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: labelW, height: labelH)
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    var nameSelected: Bool = false

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(customIV)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        customIV.isHidden = !nameSelected
        if nameSelected {
            customIV.frame = CGRect(x: leftMargin, y: (bounds.height - imageViewHW) * 0.5 , width: imageViewHW, height: imageViewHW)
            titleLabel.frame = CGRect(x: leftMargin + imageViewHW + 4, y:  (bounds.height - labelH) * 0.5 , width: labelW, height: labelH)
        } else {
            customIV.frame = CGRect.zero
            titleLabel.frame = CGRect(x: leftMargin, y: (bounds.height - labelH) * 0.5 , width: labelW, height: labelH)
        }
    }
    
}


extension VJRegionSelection {
    
    static var keyWindow: UIWindow {
        if #available(iOS 13, *) {
            let keyWindow : UIWindow  = UIApplication.shared.connectedScenes
                .map{$0 as? UIWindowScene}
                .compactMap{$0}
                .first?.windows.first ?? UIWindow()
//            return UIApplication.shared.windows.first { $0.isKeyWindow }
            return keyWindow
        } else {
            return UIApplication.shared.keyWindow ?? UIWindow()
        }
    }
    
    static func isBangsScreen() ->Bool {
        let keyWindow = VJRegionSelection.keyWindow
        if #available(iOS 11.0, *) {
            return keyWindow.safeAreaInsets.bottom > 0
        } else {
            // Fallback on earlier versions
        }
        return false
    }
    
    static var safeBottom : CGFloat {
        if #available(iOS 11.0, *) {
            return keyWindow.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
        }
        return 0
    }
}
