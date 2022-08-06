//
//  RegionSelectionController.swift
//  Housing
//
//  Created by Ethan on 2022/8/6.
//  Copyright © 2022 Housing. All rights reserved.
//

import UIKit

@objc(RegionSelectionController)
class RegionSelectionController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let view = VJRegionSelection(frame: UIScreen.main.bounds)
        UIWindow.key?.addSubview(view)
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
