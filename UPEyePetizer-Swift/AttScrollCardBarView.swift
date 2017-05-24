//
//  AttScrollCardBarView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class AttScrollCardBarView: UIView {
    
    var conBtnClick: (()->())?
    
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var concernBtn: UIButton!
    
    var headerModel: [String : Any]?{
    
        didSet{
            
            guard let titleStr = headerModel?["title"] as? String,
                  let subTitleStr = headerModel?["subTitle"] as? String else {
                    
                    return
            }

            titleLab.text = titleStr
            subTitleLab.text = subTitleStr
        }
    }
    
    @IBAction func concernBtnClick() {
        
        conBtnClick?()
        
    }

}

extension AttScrollCardBarView{
    
    class func loadAttScrollCardBarView() -> AttScrollCardBarView {
        
        return Bundle.main.loadNibNamed("AttScrollCardBarView", owner: nil, options: nil)?.first as! AttScrollCardBarView
    }
}
