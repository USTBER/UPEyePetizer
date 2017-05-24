//
//  videoColView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/16.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit


class VideoColView: UIView {

    lazy var colImgView: UIImageView = UIImageView()
    lazy var colTitleLab: UILabel = UILabel()
    lazy var colCategoryTimeLab: UILabel = UILabel()
    
    var videoDataModel: VideoDataModel?{
        
        didSet{
            
            guard let model = videoDataModel,
                  let title = model.title,
                  let category = model.category,
                  let showImgUrl = model.cover?["detail"] as? String else {
                    
                    return
            }
            
            
            colImgView.sd_setImage(with: URL(string: showImgUrl), placeholderImage: nil)
            colTitleLab.text = title
            colCategoryTimeLab.text = String().categoryAndTime(category: category, duration: model.duration)
        }

    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        colImgView.frame = CGRect(x: insetMargin, y: 0, width: vColViewW, height: heightFromWidth(width: vColViewW))
        
        colTitleLab.frame = CGRect(x: insetMargin, y: colImgView.bounds.height, width: colImgView.bounds.width, height: (bounds.height - colImgView.bounds.height) / 2 - 5)
        colCategoryTimeLab.frame = CGRect(x: insetMargin, y: colTitleLab.frame.maxY, width: colImgView.bounds.width, height: (bounds.height - colImgView.bounds.height) / 2 - 5)
    }

}

extension VideoColView{
    
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


