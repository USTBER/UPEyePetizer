//
//  HeadAndFootRefreshView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/11.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class HeadAndFootRefreshView: UIView {

    var backImgView: UIImageView = UIImageView(image: UIImage(named: "ICON_Loading_Out_42x28_"))
    var eyeImgView: UIImageView = UIImageView(image: UIImage(named: "ICON_Loading_In_42x28_"))
    var rotationAnima = CABasicAnimation(keyPath: "transform.rotation.z")
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnima() -> () {
        
        eyeImgView.layer.add(rotationAnima, forKey: nil)
    }
    
    func stopAnima() -> () {
        
        eyeImgView.layer.removeAllAnimations()
    }

}

extension HeadAndFootRefreshView{
    
    func setUpUI() -> () {
        
        addSubview(backImgView)
        backImgView.addSubview(eyeImgView)
        
        backImgView.sizeToFit()
        eyeImgView.center = backImgView.center
    
        //动画完成不删除
        rotationAnima.isRemovedOnCompletion = false
        rotationAnima.fromValue = 0
        rotationAnima.toValue = Double.pi * 2
        rotationAnima.repeatCount = MAXFLOAT
        rotationAnima.duration = 1.0
        
    }
    
}
