//
//  videoColView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/16.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit


class videoColView: UIView {

    lazy var colImgView: UIImageView = UIImageView()
    lazy var colTitleLab: UILabel = UILabel()
    lazy var colCategoryTimeLab: UILabel = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colImgView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * (4 / 5), height: heightFromWidth(width: UIScreen.main.bounds.width * (4 / 5)))
        colTitleLab.frame = CGRect(x: 0, y: colImgView.frame.maxY, width: colImgView.bounds.width, height: (bounds.height - colImgView.bounds.height) / 2)
        colCategoryTimeLab.frame = CGRect(x: 0, y: colTitleLab.frame.maxY, width: colImgView.bounds.width, height: (bounds.height - colImgView.bounds.height) / 2 - margin)
    }

}

extension videoColView{
    
    func setUpUI() -> () {
        
        colTitleLab.font = UIFont.boldSystemFont(ofSize: 13)
        colTitleLab.textColor = UIColor.black
        colTitleLab.textAlignment = .left
        
        colCategoryTimeLab.font = UIFont.systemFont(ofSize: 11)
        colCategoryTimeLab.textColor = UIColor.darkGray
        colCategoryTimeLab.textAlignment = .left
        
        addSubview(colImgView)
        addSubview(colTitleLab)
        addSubview(colCategoryTimeLab)
    }
}


