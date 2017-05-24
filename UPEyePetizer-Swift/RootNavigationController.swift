//
//  RootNavigationController.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/7.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            if let vc = viewController as? BaseViewController {
                
                let backBtnImg = UIImage(named: "Action_backward_44x44_") ?? UIImage()
                let leftBackBtn = UIBarButtonItem(image:backBtnImg, target: self, action: #selector(popToParentVC))
                let ﬁxedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                ﬁxedSpace.width = -15
                vc.navItem.leftBarButtonItems = [ﬁxedSpace, leftBackBtn]
            }
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    func popToParentVC() -> () {
        
        popViewController(animated: true)
    }
    
}
