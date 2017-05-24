//
//  AttBriefBarView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class AttBriefBarView: UIView {
    
    var conBtnClick: (()->())?
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var concernBtn: UIButton!
 
    
    var headerModel: [String : Any]?{
        
        didSet{
            
            guard let iconUrlStr = headerModel?["icon"] as? String,
                  let titleStr = headerModel?["title"] as? String,
                  let descripStr = headerModel?["description"] as? String else {
                    
                return
            }

            iconImgView.up_setWebImage(urlString: iconUrlStr, placeholderImage: nil, isAvatar: true)
            titleLab.text = titleStr
            desLab.text = descripStr
            
        }
    }
    
    @IBAction func concernBtnClick() {
        
        conBtnClick?()
    }

}

extension AttBriefBarView{
    
    class func loadAttBriefBarView() -> AttBriefBarView {
        
        return Bundle.main.loadNibNamed("AttBriefBarView", owner: nil, options: nil)?.first as! AttBriefBarView
    }
}
