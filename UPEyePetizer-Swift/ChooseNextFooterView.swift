//
//  ChooseNextFooterView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/22.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class ChooseNextFooterView: UIView {


    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
}

extension ChooseNextFooterView{
    
    class func loadChooseNextFooterView() -> ChooseNextFooterView {
        
        let chooseNextView = Bundle.main.loadNibNamed("ChooseNextFooterView", owner: nil, options: nil)?.first as! ChooseNextFooterView
        
        chooseNextView.frame.size.width = UIScreen.main.bounds.width
        chooseNextView.frame.size.height = 64
        
        return chooseNextView
    }
}
