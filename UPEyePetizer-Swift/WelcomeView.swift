//
//  WelcomeView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/15.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class WelcomeView: UIView {

    @IBOutlet weak var welView: UIImageView!
    
    //视图已显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.welView.alpha = 0.6
        UIView.animate(withDuration: 2.5, animations: {
            
            self.welView.layer.setAffineTransform(CGAffineTransform(scaleX: 1.2, y: 1.2))
            self.welView.alpha = 1.0
            
        }) { (true) in
            
            self.removeFromSuperview()
        }
    }
}

extension WelcomeView{
    
    class func loadWelView() -> WelcomeView {
        
        let welView = Bundle.main.loadNibNamed("WelcomeView", owner: nil, options: nil)?.first as! WelcomeView
        welView.frame = UIScreen.main.bounds
        
        return welView
    }
    
    
}

