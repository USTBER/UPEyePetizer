//
//  NewFeatureView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/15.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class NewFeatureView: UIView {

    lazy var scrollView: UIScrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
        
        scrollView.frame = self.bounds
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clear
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        addSubview(scrollView)
        
        let count = 2
        let rect = UIScreen.main.bounds
        for i in 0..<count {
            
            let imgName = "newFeature\(i+1)"
            let imgView = UIImageView(image: UIImage(named:imgName))
            
            let guideImgView: UIImageView = UIImageView(image: UIImage(named: "Action_next_44x44_"))
            guideImgView.frame = CGRect(x: rect.width - 44, y: rect.height - 44, width: 44, height: 44)
            imgView.addSubview(guideImgView)
            
            imgView.frame = CGRect(x: CGFloat(i) * rect.width, y: 0, width: rect.width, height: rect.height)
            //imgView.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(imgView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension NewFeatureView: UIScrollViewDelegate{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.width + 0.5)
        if page == scrollView.subviews.count {
            
            removeFromSuperview()
        }
        
    }
}


