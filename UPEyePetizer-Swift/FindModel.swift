//
//  FindModel.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/2.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class FindModel: NSObject {
    
    var TabListId: Int = 0
    var name: String?
    var apiUrl: String?
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    
        if key == "id" {
            
            TabListId = value as! Int
        }
    }
}
