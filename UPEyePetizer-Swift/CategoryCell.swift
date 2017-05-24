//
//  CategoryCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/26.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    let titleLab: UILabel = UILabel()
    let bgImgView: UIImageView = UIImageView()
    
    var categoryData: [String: Any]? {
    
        didSet{
            
            guard let imageUrlStr = categoryData?["image"] as? String,
                  let titleStr = categoryData?["title"] as? String else {
                    
                    return
            }
            
            bgImgView.up_setWebImage(urlString: imageUrlStr, placeholderImage: nil)
            titleLab.text = titleStr
            titleLab.sizeToFit()
        }
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
        titleLab.textColor = UIColor.white
        titleLab.font = UIFont.boldSystemFont(ofSize: 18)
        
        contentView.addSubview(titleLab)
        contentView.insertSubview(bgImgView, belowSubview: titleLab)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImgView.frame = contentView.bounds
        titleLab.center = contentView.center
    }
    
}
