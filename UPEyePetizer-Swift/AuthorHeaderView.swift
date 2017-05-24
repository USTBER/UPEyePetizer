
//
//  AuthorHeaderView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class AuthorHeaderView: UIView {
    
    
    var iconView: UIImageView = UIImageView()
    var iconUrl: String?{
        
        didSet{
            
            guard let urlStr = iconUrl else {
                
                return
            }
            
            iconView.up_setWebImage(urlString: urlStr, placeholderImage: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        iconView.frame = CGRect(x: (bounds.size.width - 100) / 2, y: (bounds.size.height - 100) / 2, width: 100, height: 100)
        addSubview(iconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
