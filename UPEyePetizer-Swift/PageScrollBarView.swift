//
//  PageScrollBarView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/27.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

protocol PageScrollBarViewDelegate: NSObjectProtocol {
    
    func btnClick(btn: UIButton) -> ()
}

private let bottomViewW: CGFloat = 16
private let bottomViewH: CGFloat = 2
class PageScrollBarView: UIView {

    weak var delegate: PageScrollBarViewDelegate?
    
    lazy var bottomView = UIView()
    var lastBtn: UIButton?
    
    
    var btnNameArrs: [String]?{
        
        didSet{
            
            guard let btnNameArrs = btnNameArrs else {
                
                return
            }
            
            let btnCoun = btnNameArrs.count
            let btnW: CGFloat = UIScreen.main.bounds.width / CGFloat(btnCoun)
            for i in 0..<btnCoun{
                
                addBtns(btnNum: i, btnName: btnNameArrs[i], btnW: btnW)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        bottomView.backgroundColor = UIColor.black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

extension PageScrollBarView{
    
    func addBtns(btnNum: Int, btnName: String, btnW: CGFloat) -> () {
        
        let btn = UIButton(frame: CGRect(x: CGFloat(btnNum) * btnW, y: 0, width: btnW, height: bounds.height))
        btn.tag = btnNum
        btn.backgroundColor = UIColor.white
        btn.setTitle(btnName, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(moveBtn), for: .touchUpInside)
        addSubview(btn)
        
        if btnNum == 0 {
            
            btn.setTitleColor(UIColor.black, for: .normal)
            bottomView.frame = CGRect(x: (btnW - bottomViewW) / 2 , y: (bounds.height - bottomViewH), width: bottomViewW, height: bottomViewH)
            addSubview(bottomView)
            
            lastBtn = btn
        }else {
            
            btn.setTitleColor(UIColor.lightGray, for: .normal)
        }
    }
    
    
    
    func moveBtn(btn: UIButton) -> () {
        
        insertSubview(bottomView, aboveSubview: btn)
        UIView.animate(withDuration: 0.25) {
            
            self.bottomView.center.x = btn.center.x
            btn.setTitleColor(UIColor.black, for: .normal)
        }
        
        lastBtn?.setTitleColor(UIColor.lightGray, for: .normal)
        lastBtn = btn
        
        delegate?.btnClick(btn: btn)
    }
}




