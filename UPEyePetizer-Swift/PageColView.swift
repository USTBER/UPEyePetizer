//
//  PageColView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/21.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class PageColView: UIView {
    
    lazy var pageImgView: UIImageView = UIImageView()
    lazy var pageTitleLab: UILabel = UILabel()
    lazy var pageCategoryTimeLab: UILabel = UILabel()
    
    var videoDataModel: VideoDataModel?{
    
        didSet{
            
            guard let vPageModel = videoDataModel,
                  let title = vPageModel.title,
                  let category = vPageModel.category,
                  let showImgUrl = vPageModel.cover?["detail"] as? String else {
                    
                    return
            }
            
            pageTitleLab.text = title
            pageCategoryTimeLab.text = String().categoryAndTime(category: category, duration: vPageModel.duration)
            pageImgView.up_setWebImage(urlString: showImgUrl, placeholderImage: nil)
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
        
        pageImgView.frame = CGRect(x: 0, y: 0, width: pageColViewW, height: heightFromWidth(width: pageColViewW))
        
        pageTitleLab.frame = CGRect(x: 0, y: pageImgView.frame.maxY, width: pageImgView.bounds.width, height: (bounds.height - pageImgView.bounds.height) / 2)
        
        pageCategoryTimeLab.frame = CGRect(x: 0, y: pageTitleLab.frame.maxY, width: pageImgView.bounds.width, height: (bounds.height - pageImgView.bounds.height) / 2)
    }
    
    
}

extension PageColView{
    
    func setUpUI() -> () {
        
        pageTitleLab.font = UIFont.boldSystemFont(ofSize: 13)
        pageTitleLab.textColor = UIColor.black
        pageTitleLab.textAlignment = .center
        
        pageCategoryTimeLab.font = UIFont.systemFont(ofSize: 11)
        pageCategoryTimeLab.textColor = UIColor.darkGray
        pageCategoryTimeLab.textAlignment = .center
        
        addSubview(pageImgView)
        addSubview(pageTitleLab)
        addSubview(pageCategoryTimeLab)
        
        pageImgView.contentMode = .scaleAspectFill
        pageImgView.clipsToBounds = true
    }
}
