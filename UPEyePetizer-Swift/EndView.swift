//
//  EndView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class EndView: UIView {
    
    @IBOutlet weak var endLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.darkGray
        
        endLab.text = "- The End -"
        endLab.font = UIFont.init(name: "Lobster 1.4", size: 16)
    }
    

}

extension EndView{
    
    class func loadEndView(frame: CGRect) -> EndView {
        
        let endView = Bundle.main.loadNibNamed("EndView", owner: nil, options: nil)?.first as! EndView
        endView.frame = frame
        
        return endView
    }
}

