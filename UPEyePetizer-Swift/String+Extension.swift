//
//  String+Extension.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/16.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import Foundation

extension String{
    
    func categoryAndTime(category: String, duration: Int) -> String {
        
        let time = videoTime(duration: duration)
        return "#\(category) / \(time)"
    }
    
    private func videoTime(duration: Int) -> String {
        
        let min = duration / 60
        let sec = duration % 60
        
        return String.init(format: "%02d'%02d\"",min,sec)
    }
    
}
