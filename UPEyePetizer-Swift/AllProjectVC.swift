

//
//  AllProjectVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

private let videoCellID = "videoCellID"

class AllProjectVC: BaseViewController {

    
    let barW: CGFloat = UIScreen.main.bounds.width
    let barH: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setTopUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: 设置界面
extension AllProjectVC{
    
    override func setUpNavBar() {
        super.setUpNavBar()
        
        let titleLab: UILabel = UILabel()
        titleLab.text = "360 全景"
        titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        titleLab.sizeToFit()
        navItem.titleView = titleLab
    }
    
    override func setUpTableView() {}
    
    func setTopUI() -> () {
        
        let array = ["按时间排序","分享排行榜"]
        let barView: PageScrollBarView = PageScrollBarView(frame: CGRect(x: 0, y: self.navigationBar.bounds.height, width: barW, height: barH))
        barView.btnNameArrs = array
        barView.delegate = self
        view.addSubview(barView)
        
        let endView = EndView.loadEndView(frame: CGRect(x: 0, y: barView.frame.maxY, width: screenW, height: view.bounds.height - barView.frame.maxY))
        view.addSubview(endView)
    }
}

//MARK: 设置PageScrollBarViewDelegate相关
extension AllProjectVC: PageScrollBarViewDelegate{
    
    func btnClick(btn: UIButton) {
        
        if btn.tag == 0 {
            
            print("按时间排序")
            
        }else if btn.tag == 1{
            
            print("分享排行榜")
        }
    }
}

