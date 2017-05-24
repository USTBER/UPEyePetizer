//
//  MeView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/12.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class MeView: UIView {

    var logAndColAndComBtnClick:(()->())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 194)
    }
    
    @IBAction func loginBtnClick() {
        
        logAndColAndComBtnClick?()
    }
    
    
    @IBAction func commentBtnClick() {
        
        logAndColAndComBtnClick?()
    }
    
    @IBAction func CollectBtnClick() {
        
        logAndColAndComBtnClick?()
    }
    
}

extension MeView{
    
    class func loadMeView() -> MeView {
        
        return Bundle.main.loadNibNamed("MeView", owner: nil, options: nil)?.first as! MeView
    }
}
