//
//  Bundle+Extension.swift
//  SwiftTest
//
//  Created by wust_LiTao on 2017/4/6.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import Foundation

extension Bundle{
    
    var nameSpace: String{
        
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    var versionNum: String{
        
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    
}
