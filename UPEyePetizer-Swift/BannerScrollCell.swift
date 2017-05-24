//
//  BannerScrollCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/9.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class BannerScrollCell: UITableViewCell {
    
    let scrollView: UIScrollView = UIScrollView()
    let pageControl: UIPageControl = UIPageControl()
    let pageControlH: CGFloat = 14
    
    var imgUrlArr = [String]()
    var imgArr = [UIImageView]()
    var timer: Timer?
    
    var bannerScrollCellData: [String : Any]?{
        
        didSet{
            
            guard let bannerData = bannerScrollCellData,
                  let itemList = bannerData["itemList"] as? NSArray else {
                
                return
            }
            
            imgUrlArr.removeAll()
            imgArr.removeAll()
            
            for item in itemList {
                
                guard let itemData = (item as! [String: AnyObject])["data"],
                      let imgUrl = itemData["image"] as? String else {
                    
                        return
                }
                
                imgUrlArr.append(imgUrl)
            }
            
            for i in 0..<imgUrlArr.count {
                
                let imgView = UIImageView()
                imgView.up_setWebImage(urlString: imgUrlArr[i], placeholderImage: nil)

                scrollView.addSubview(imgView)
                imgArr.append(imgView)
            }
            
            pageControl.numberOfPages = itemList.count
            scrollView.contentSize = CGSize(width: CGFloat(itemList.count) * UIScreen.main.bounds.width, height: 0)
            
    
            timer?.invalidate()
            setUpTimer()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        contentView.addSubview(scrollView)
        
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        pageControl.pageIndicatorTintColor = UIColor.white
        contentView.addSubview(pageControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = contentView.bounds
        pageControl.frame = CGRect(x: 0, y: contentView.bounds.height - pageControlH, width: contentView.bounds.width, height: pageControlH)
        
        for i in 0..<imgArr.count {
            
            let imgView = imgArr[i]
            imgView.frame = CGRect(x: CGFloat(i) * UIScreen.main.bounds.width, y: 0, width: contentView.bounds.width, height: contentView.bounds.height)
            
        }
    }

}

//MARK:- UIScrollView代理相关方法
extension BannerScrollCell: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let page: Int = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width + 0.5)
        pageControl.currentPage = page
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    
        timer?.fireDate = NSDate.distantFuture
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        timer?.fireDate = NSDate.distantPast
    }
    
}

//MARK:- 定时器相关方法
extension BannerScrollCell{
    
    func setUpTimer() -> () {
        
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(changeView), userInfo: nil, repeats: true)
    }
    
    func changeView() -> () {
        
        var offsetX = scrollView.contentOffset.x
        let imgViewW = contentView.bounds.width
        offsetX = offsetX + imgViewW
        
        if offsetX == imgViewW * CGFloat(imgArr.count){
            
            pageControl.currentPage = 0
            scrollView .setContentOffset(CGPoint(), animated: false)
            
        }else{
            
            pageControl.currentPage = Int(offsetX / imgViewW)
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            
        }

    }
}



