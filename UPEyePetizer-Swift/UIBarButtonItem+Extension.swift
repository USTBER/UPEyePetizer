//
//  UIBarButtonItem+Extension.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/7.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init(title: String, titleColor: UIColor,titleFont: CGFloat,target: AnyObject?, action: Selector) {
        
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.showsTouchWhenHighlighted = false
        
        self.init(customView: btn)
    }
    
    
    convenience init(image: UIImage, target: AnyObject?, action: Selector) {
        
        let btn = UIButton(type: .custom)
        btn.setImage(image, for: .normal)
        btn.setImage(image, for: .highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.showsTouchWhenHighlighted = false
        
        self.init(customView: btn)
    }
    
}
