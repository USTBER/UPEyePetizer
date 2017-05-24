//
//  PageScrollView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/21.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

protocol PageScrollViewDelegate: NSObjectProtocol {
    
    func pageScrollViewItemClick(videoItemModel: VideoDataModel) -> ()
}

//滚动图片的宽度
let pageColViewW: CGFloat = UIScreen.main.bounds.width * (5 / 6)

class PageScrollView: UIView {
    
    weak var delegate: PageScrollViewDelegate?
    
    var VideoDataModelArrs = [VideoDataModel]()
    
    let pageControlH: CGFloat = 34
    let screenW = UIScreen.main.bounds.width
    
    lazy var pageScrollView: UIScrollView = UIScrollView()
    var insetMargin:CGFloat = 5
    let ViewMargin: CGFloat = (UIScreen.main.bounds.width - pageColViewW) / 2 - 5

    var pageCounts: Int = 0
    
    lazy var pageControl: UIPageControl = UIPageControl()
    
    func addScrollImg(colItemArr: NSArray) -> () {
        
        setUpPageScrollView(colItemArr: colItemArr)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.delegate = self
        addSubview(pageScrollView)
        
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.gray
        addSubview(pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pageScrollView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - pageControlH)
        pageControl.frame = CGRect(x: 0, y: pageScrollView.frame.maxY, width: bounds.width, height: pageControlH)
        
        //设置pageScrollView中子控件的frame
        for i in 0..<pageScrollView.subviews.count {
            
            let pCView = pageScrollView.subviews[i]
            pCView.frame = CGRect(x: CGFloat(i) * (pageColViewW + insetMargin), y: insetMargin, width: pageColViewW + insetMargin, height: pageScrollView.bounds.height)
        }
        
    }
}
//MARK: 向normalScrollView中添加子控件
extension PageScrollView{
    
    func pageItemVideoViewTap(gesture: UITapGestureRecognizer) -> () {
        
        
        guard let tapView = gesture.view as? PageColView,
              let dataModel =  tapView.videoDataModel  else {
                
                return
        }
        
        delegate?.pageScrollViewItemClick(videoItemModel: dataModel)
    }
    
    func videoDataToJson(colItemArr: NSArray ,num: Int) -> (VideoDataModel) {
        
        let pageItemsModel = ItemListModel(dict: (colItemArr[num] as! [String : Any]))
        let pageDataModel = VideoDataModel(dict: (pageItemsModel.data ?? [:]))
        
        return pageDataModel
    }

    func setUpPageScrollView(colItemArr: NSArray) -> () {
        
        pageCounts = colItemArr.count
        pageControl.numberOfPages = colItemArr.count

        for subView in pageScrollView.subviews {
            
            if subView.isKind(of: PageColView.self) {
                
                subView.removeFromSuperview()
            }
        }
    
        //获取数据模型
        for i in 0..<Int(colItemArr.count) {
            
            if i == 0 {
                
                VideoDataModelArrs.append(videoDataToJson(colItemArr: colItemArr, num: colItemArr.count - 1))
            }
            
            VideoDataModelArrs.append(videoDataToJson(colItemArr: colItemArr, num: i))
            
            if i == colItemArr.count - 1 {
                
                VideoDataModelArrs.append(videoDataToJson(colItemArr: colItemArr, num: 0))
            }
        }
        
        for i in 0..<VideoDataModelArrs.count {
            
            let pageVideoDataModel = VideoDataModelArrs[i]
            let pageColView = PageColView()
            pageColView.videoDataModel = pageVideoDataModel
            
            if pageScrollView.bounds.height != 0 {
                
                pageColView.frame = CGRect(x: CGFloat(i) * (pageColViewW + insetMargin), y: insetMargin, width: pageColViewW + insetMargin, height: pageScrollView.bounds.height)
            }
            
            pageScrollView.addSubview(pageColView)
            let tapItemGes = UITapGestureRecognizer(target: self, action: #selector(pageItemVideoViewTap))
            pageColView.addGestureRecognizer(tapItemGes)
        }
        
        //刚开始显示第一张图片
        let pageCount: CGFloat = 1
        let offsetX = pageColViewW * pageCount + insetMargin * (pageCount - 1) - ViewMargin
        pageScrollView.contentOffset = CGPoint(x:offsetX, y: 0)
        
        pageScrollView.contentSize = CGSize(width: (pageColViewW + insetMargin) * CGFloat(VideoDataModelArrs.count), height: 0)
    }
}

//MARK: ScrollView相关代理
extension PageScrollView: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var pageCount = lroundf(Float(scrollView.contentOffset.x / (pageColViewW - insetMargin)))
        if pageCount == 0{
            
            pageCount = pageCounts
        }
        
        if pageCount == pageCounts + 1 {
        
            pageCount = 1
        }
        pageControl.currentPage = pageCount - 1
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        scrollViewMove(scrollView: scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scrollViewMove(scrollView: scrollView)
    }
    
    func scrollViewMove(scrollView: UIScrollView) -> () {
        
        let ViewMargin: CGFloat = (screenW - pageColViewW) / 2 - insetMargin
        let pageCount = lroundf(Float(scrollView.contentOffset.x / (pageColViewW - insetMargin)))
        var offsetX = pageColViewW * CGFloat(pageCount) + insetMargin * (CGFloat(pageCount) - 1) - ViewMargin

        //print("\(pageCount) ---- ")
        if pageCount == 0 {
            
            offsetX = pageColViewW * CGFloat(pageCounts) + insetMargin * CGFloat(pageCounts - 1) - ViewMargin
            
            DispatchQueue.main.async {
                
                scrollView.contentOffset = CGPoint(x:offsetX, y: 0)
            }
        }else if pageCount == (self.pageCounts + 1){
            
            offsetX = pageColViewW - ViewMargin
            DispatchQueue.main.async {
                
                scrollView.contentOffset = CGPoint(x:offsetX, y: 0)
            }
        }else{
            
            DispatchQueue.main.async {
                
                scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            }
        }
    }
}



 
