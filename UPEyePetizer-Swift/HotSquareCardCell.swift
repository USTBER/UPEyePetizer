//
//  HotSquareCardCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/6.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

//滚动图片之间的间距
let picMargin:CGFloat = 10

class HotSquareCardCell: UITableViewCell {

    lazy var titleBarLab: UILabel = UILabel()
    lazy var scrollView: UIScrollView = UIScrollView()
    var picW: CGFloat = 0
    
    var squareCardDataModel: AttDataModel? {
        
        didSet{
            
            guard let squareCardDataModel = squareCardDataModel,
                  let squareCardItemArr = squareCardDataModel.itemList else {
                    
                    return
            }

            let titleStr = squareCardDataModel.header?["title"] as? String
            titleBarLab.text = titleStr
            
            scrollView.contentOffset = CGPoint()
            addScrollViewPic(ItemArr: squareCardItemArr)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleBarLab.textColor = UIColor.black
        titleBarLab.font = UIFont.boldSystemFont(ofSize: 17)
        titleBarLab.textAlignment = .center
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        contentView.addSubview(titleBarLab)
        contentView.addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        titleBarLab.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: briedAndScrollCardBarH - 20)
        scrollView.frame = CGRect(x: 0, y: titleBarLab.frame.maxY, width: contentView.bounds.width, height: contentView.bounds.height - titleBarLab.frame.maxY)
        
        
        let picH = scrollView.bounds.height - picMargin * 2
        picW = picH * 0.9
        for i in 0..<scrollView.subviews.count {
            
            let picView = scrollView.subviews[i]
            var picMarginW: CGFloat = (picW + picMargin) * CGFloat(i) + picMargin
            if i == 0 {
                
                picMarginW = picMargin
            }
            picView.frame = CGRect(x: picMarginW, y: picMargin, width: picW, height: picH)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(scrollView.subviews.count) * (picW + picMargin), height: 0)
    }
}

extension HotSquareCardCell{
    
    func addScrollViewPic(ItemArr: NSArray) -> () {
        
        for subView in scrollView.subviews {
            
            if subView.isKind(of: HotPicView.self) {
                
                subView.removeFromSuperview()
            }
        }
        
        for j in 0..<ItemArr.count - 1 {
            
            let hotPicView = HotPicView(frame: CGRect())
            
            let itemModel = ItemListModel(dict: (ItemArr[j] as! [String : Any]))
            let dataDic = itemModel.data
            let imageUrlStr = dataDic?["image"] as? String
            //let titleStr = dataDic?["title"] as? String
            
            hotPicView.up_setWebImage(urlString: imageUrlStr, placeholderImage: nil)
            scrollView.addSubview(hotPicView)
        }
        
    }
}
