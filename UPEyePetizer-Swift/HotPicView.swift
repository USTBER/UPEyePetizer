//
//  HotPicView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/6.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class HotPicView: UIImageView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.purple
        isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
