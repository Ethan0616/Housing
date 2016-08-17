//
//  TableViewController1.swift
//  Housing
//
//  Created by Ethan on 16/8/16.
//  Copyright © 2016年 Housing. All rights reserved.
//

import UIKit

@objc (TableViewController1)
class TableViewController1: BaseViewController ,TwitterScrollDelegate {

    lazy var tableV : UITableView = {
        let  tableV = UITableView()
        tableV.backgroundColor = UIColor.clearColor()
        tableV.showsVerticalScrollIndicator = false
        tableV.separatorStyle = .None
        return tableV
    }()
    
    lazy var scrollV : UIScrollView = {
        let  scrollV = UIScrollView()
        scrollV.backgroundColor = UIColor.clearColor()
        scrollV.showsVerticalScrollIndicator = false
        return scrollV
    }()
    var twitterScrollView : TwitterScroll!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        tableV.frame = view.bounds
        twitterScrollView = TwitterScroll(backgroundImage: UIImage(named: "dataBase1.jpg")!, avatarImage: UIImage(named: "dataBase0.jpg")!, titleString: "Hello,Kitty", subtitleString: "subtitleStri", buttonTitle: "buttonTitle", scrollView: tableV)
//        scrollV.frame = view.bounds
//        scrollV.contentSize = CGSizeMake(scrollV.width, scrollV.height * 4)
//        twitterScrollView = TwitterScroll(backgroundImage: UIImage(named: "dataBase1.jpg")!, avatarImage: UIImage(named: "dataBase0.jpg")!, titleString: "Hello,Kitty", subtitleString: "subtitleStri", buttonTitle: "buttonTitle", scrollView: scrollV)
        view.addSubview(twitterScrollView)
        twitterScrollView.delegate = self
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func recievedMBTwitterScrollEvent(){
        
        self.navigationController?.popViewControllerAnimated(true)
        
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

@objc protocol TwitterScrollDelegate : NSObjectProtocol {
    func recievedMBTwitterScrollEvent()
    optional func recievedMBTwitterScrollButtonClicked()
}

class TwitterScroll: UIView {

    var headerImageView : UIImageView!
    var header          = UIView()
    var blurImages      = NSMutableArray()
    weak var scrollView      : UIScrollView! // or tableView
    weak var delegate : TwitterScrollDelegate?
    lazy var avatarImage     : UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.clipsToBounds = true
        
        return imageView
    }()
    lazy var  headerLabel   : UILabel  = {
        var label = UILabel()
        label.frame = CGRectZero
        label.textAlignment = .Center
        label.font = UIFont(name: "HelveticaNeue-Medium",size: 18.0)
        label.textColor = UIColor.whiteColor()
        
        return label
    }()
    var headerButton    : UIButton = {
        var btn = UIButton()
        btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium",size: 12)
        btn.layer.borderColor = UIColor.lightGrayColor().CGColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 8
        
        return btn
    }()
    
    private enum TSType{
        case Table
        case Scroll
    }
    private let offset_HeaderStop       : CGFloat = 40.0
    private let offset_B_LabelHeader    : CGFloat = 95.0
    private let distance_W_LabelHeader  : CGFloat = 35.0
    private var scrollViewType          : TSType = .Scroll
    private weak var tableview          : UITableView!
    private var titleLabel              = UILabel()
    private lazy var subtitleLabel      : UILabel = {
            var label = UILabel()
            label.font = UIFont(name:"HelveticaNeue-Medium",size: 12)
            label.textColor = UIColor.lightGrayColor()
        
        return label
    }()
    
    convenience init(backgroundImage : UIImage , avatarImage : UIImage , titleString : String , subtitleString : String , buttonTitle : NSString , scrollView : UIScrollView){
        self.init()
        
        addSubview(header)
        headerImageView = UIImageView()
        headerImageView.image = backgroundImage
        headerImageView.contentMode = .ScaleAspectFill
        headerLabel.text = titleString
        header.addSubview(headerLabel)
        header.clipsToBounds = true
        header.insertSubview(self.headerImageView, aboveSubview: self.headerLabel)

        if let tableView = scrollView as? UITableView {
            scrollViewType = .Table
            self.tableview = tableView
            self.tableview.separatorStyle = .None
            self.frame = self.tableview.bounds
            self.tableview.tableHeaderView?.frame = CGRectMake(self.x, self.y, self.width, self.header.height + 100)
            self.tableview.addSubview(self.avatarImage)
            self.tableview.addSubview(self.titleLabel)
            self.tableview.addSubview(self.subtitleLabel)
            if buttonTitle.length > 0 {
                self.tableview.addSubview(self.headerButton)
            }
            self.addSubview(self.tableview)
            self.tableview.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        }else{
            scrollViewType = .Scroll
            self.scrollView = scrollView
            self.frame = self.scrollView.bounds
            self.scrollView.addSubview(self.avatarImage)
            self.scrollView.addSubview(self.titleLabel)
            self.scrollView.addSubview(self.subtitleLabel)
            if buttonTitle.length > 0 {
                self.scrollView.addSubview(self.headerButton)
            }
            self.addSubview(self.scrollView)
            self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        }
        
        self.avatarImage.image = avatarImage
        titleLabel.text = titleString
        subtitleLabel.text = subtitleString
        headerButton.setTitle(buttonTitle as String, forState: .Normal)
        headerButton.addTarget(self, action: #selector(self.delegate?.recievedMBTwitterScrollButtonClicked), forControlEvents: .TouchUpInside)

        
        header.frame = CGRectMake(self.x, self.y, self.width, 107)
        headerLabel.frame       = CGRectMake(self.x, self.header.height - 5, self.width, 25)
        self.avatarImage.frame  = CGRectMake(10, 79, 69, 69)
        titleLabel.frame        = CGRectMake(10, 156, 250, 25)
        subtitleLabel.frame     = CGRectMake(10, 177, 250, 25)
        headerButton.frame      = CGRectMake(self.width - 100, 120, 80, 35)
        headerImageView.frame   = header.frame
        
        
        prepareForBlurImages() //
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        var offset : CGFloat = 0
        if scrollViewType == .Table {
            offset = self.tableview.contentOffset.y
        }else if scrollViewType == .Scroll{
            offset = self.scrollView.contentOffset.y
        }
        animationForScroll(offset)
        
//        print("header\(header.frame)  headerImageView\(headerImageView.frame) headerLabel\(headerLabel.frame)")
        
    }
    
    // MARK: Methods
    func prepareForBlurImages(){
        var factor = 0.1
        self.blurImages.addObject(self.headerImageView.image!)
        var height  = Int(self.headerImageView.frame.size.height)
        if height == 0 {
            height = 120 // 最多生成13张图片
        }
        
        for _ in 0..<(height / 10) {
            self.blurImages.addObject(self.headerImageView.image!.boxblurImageWithBlur(factor))
            factor += 0.04
        }
    }
    
    func animationForScroll(offset : CGFloat){
        
        var headerTransform : CATransform3D  = CATransform3DIdentity
        var avatarTransform : CATransform3D  = CATransform3DIdentity
        
        // DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor : CGFloat  = -(offset) / self.header.bounds.size.height
            let headerSizevariation : CGFloat  = ((self.header.bounds.size.height * (1.0 + headerScaleFactor)) - self.header.bounds.size.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            self.header.layer.transform = headerTransform
            
            if offset < -self.frame.size.height/3.5 {
                objc_sync_enter(self)
                
                self.delegate?.recievedMBTwitterScrollEvent()
                if self.delegate != nil {
                    self.delegate = nil
                }
                if scrollViewType == .Table {
                    self.tableview.removeFromSuperview()
                    self.tableview.removeObserver(self, forKeyPath: "contentOffset")
                }else{
                    self.scrollView.removeFromSuperview()
                    self.scrollView.removeObserver(self, forKeyPath: "contentOffset")
                }
                
                objc_sync_exit(self)
                return
            }
            
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            // Header -----------
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            let labelTransform : CATransform3D  = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            self.headerLabel.layer.transform = labelTransform
            self.headerLabel.layer.zPosition = 2
            
            // Avatar -----------
            let avatarScaleFactor : CGFloat  = (min(offset_HeaderStop, offset)) / self.avatarImage.bounds.size.height / 1.4 // Slow down the animation
            let avatarSizeVariation : CGFloat  = ((self.avatarImage.bounds.size.height * (1.0 + avatarScaleFactor)) - self.avatarImage.bounds.size.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if (offset <= offset_HeaderStop) {
                
                if (self.avatarImage.layer.zPosition <= self.headerImageView.layer.zPosition) {
                    self.header.layer.zPosition = 0
                }
                
            }else {
                if (self.avatarImage.layer.zPosition >= self.headerImageView.layer.zPosition) {
                    self.header.layer.zPosition = 2
                }
            }
            
        }
        if self.headerImageView.image != nil {
            blurWithOffset(offset)
        }
        self.header.layer.transform = headerTransform
        self.avatarImage.layer.transform = avatarTransform
        
    }
    
    func blurWithOffset(offset : CGFloat){
        var index   = NSInteger( offset) / 10
        if (index < 0) {
            index = 0
        }
        else if(index >= self.blurImages.count) {
            index = self.blurImages.count - 1
        }
        let image : UIImage = self.blurImages[index] as! UIImage
        if (self.headerImageView.image != image) {
            self.headerImageView.image = image
        }
    }
}


