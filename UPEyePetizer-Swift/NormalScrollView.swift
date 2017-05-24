//
//  NormalScrollView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/21.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

//滚动图片的宽度
let vColViewW: CGFloat = UIScreen.main.bounds.width * (4 / 5)
//滚动图片之间的间距
let insetMargin:CGFloat = 5

protocol normalScrollViewDelegate: NSObjectProtocol {
    
    //获取点击的videoView
    func scrollViewItemClick(videoItemModel: VideoDataModel) -> ()
    
}

class NormalScrollView: UIView {
    
    weak var delegate: normalScrollViewDelegate?
    
    lazy var normalScrollView: UIScrollView = UIScrollView()
    //var vColView: VideoColView?
    
    func addScrollImg(colItemArr: NSArray) -> () {
        
        setUpNormalView(colItemArr: colItemArr)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        normalScrollView.showsVerticalScrollIndicator = false
        normalScrollView.showsHorizontalScrollIndicator = false
        addSubview(normalScrollView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        //print("NormalScrollView -- layoutSubviews")
        super.layoutSubviews()
        
        normalScrollView.frame = bounds
       
        //设置normalScrollView中子控件的frame
        for i in 0..<normalScrollView.subviews.count {
            
            let vCView = normalScrollView.subviews[i]
            vCView.frame = CGRect(x: CGFloat(i) * (vColViewW + insetMargin), y: insetMargin, width: vColViewW + insetMargin, height: normalScrollView.bounds.height)
        }
    }
    
}

//MARK: 向normalScrollView中添加子控件
extension NormalScrollView{
    
    func itemVideoViewTap(gesture: UITapGestureRecognizer) -> () {
        
        
        guard let tapView = gesture.view as? VideoColView,
              let dataModel =  tapView.videoDataModel  else {
            
            return
        }
    
        delegate?.scrollViewItemClick(videoItemModel: dataModel)
    }
    
    
    func setUpNormalView(colItemArr: NSArray) -> () {
        
        for subView in normalScrollView.subviews {
            
            if subView.isKind(of: VideoColView.self) {
                
                subView.removeFromSuperview()
            }
        }
        
        let colImgCount = colItemArr.count
        for i in 0..<Int(colImgCount) {
            
            let CImodel = ItemListModel(dict: (colItemArr[i] as! [String : Any]))
            let vCModel = VideoDataModel(dict: (CImodel.data ?? [:]))
            
            let vColView = VideoColView()
            vColView.videoDataModel = vCModel
            
            if normalScrollView.bounds.height != 0 {
                
                normalScrollView.contentOffset = CGPoint()
                vColView.frame = CGRect(x: CGFloat(i) * (vColViewW + insetMargin), y: insetMargin, width: vColViewW + insetMargin, height: normalScrollView.bounds.height)
            }
            
            normalScrollView.addSubview(vColView)
            
            let tapItemGes = UITapGestureRecognizer(target: self, action: #selector(itemVideoViewTap))
            vColView.addGestureRecognizer(tapItemGes)
        }
        
        normalScrollView.contentSize = CGSize(width: (vColViewW + insetMargin) * CGFloat(colImgCount) + insetMargin, height: 0)
    }
}




