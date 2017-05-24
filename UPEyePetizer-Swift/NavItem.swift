//
//  NavItem.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/14.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class NavItem: UINavigationItem {
    
    var leftBtnCloseClick:(()->())?
    
    
    func addLeftCloseBtn(backBtnImg: UIImage) -> () {
        
        let leftBackBtn = UIBarButtonItem(image: backBtnImg, target: self, action: #selector(popVC))
        let ﬁxedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        ﬁxedSpace.width = -10
        
        self.leftBarButtonItems = [ﬁxedSpace, leftBackBtn]
    }
    
    @objc private func popVC() -> () {
        
        leftBtnCloseClick?()
    }
}
