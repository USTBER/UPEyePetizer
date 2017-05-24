//
//  CategoryDetailHeadView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/21.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class CategoryDetailHeadView: UIView {

    var titleLab: UILabel = UILabel()
    var bgImgView = UIImageView()
    
    var categoryData: [String: Any]?{
    
            didSet{
                
                guard let title = categoryData?["title"] as? String,
                    let imgUrlStr = categoryData?["image"] as? String else {
                    
                    return
                }
                
                titleLab.text = title
                bgImgView.up_setWebImage(urlString: imgUrlStr, placeholderImage: nil)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor.white
            
            bgImgView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            bgImgView.contentMode = .scaleAspectFill
            addSubview(bgImgView)
            
            titleLab.textAlignment = .center
            titleLab.textColor = UIColor.black
            titleLab.font = UIFont.boldSystemFont(ofSize: 20)
            titleLab.frame = CGRect(x: (bounds.size.width - 100) / 2, y: 44, width: 100, height: 64)
            addSubview(titleLab)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
