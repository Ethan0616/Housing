//
//  RegionSelectionController.swift
//  Housing
//
//  Created by Ethan on 2022/8/6.
//  Copyright © 2022 Housing. All rights reserved.
//

import UIKit

@objc(RegionSelectionController)
class RegionSelectionController: BaseViewController, VJRegionSelectionProtocol {
    func didSelectedRegionWith(_ item: VJRegionModel) {
        model = item
    }
    
    
    var model : VJRegionModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        let btn = UIButton(type: .custom)
        btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        btn.backgroundColor = UIColor.green
        btn.center = view.center
        DispatchQueue.global().async {
            VJRegionSelection.loadData()
            DispatchQueue.main.async {
                self.view.addSubview(btn)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func btnClicked() {
        if model !=  nil {
            VJRegionSelection.showRegionView(model,self)
            return
        }
        
        let view = VJRegionSelection(frame: UIScreen.main.bounds)
        UIWindow.key?.addSubview(view)
        view.delegate = self
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
