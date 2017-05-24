//
//  AttentionScrollCardCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class AttentionScrollCardCell: UITableViewCell {
    
    lazy var attScrollCardBarView: AttScrollCardBarView = AttScrollCardBarView.loadAttScrollCardBarView()
    lazy var pageScrollView: PageScrollView = PageScrollView()
    
    var outerMargin: CGFloat = 5
    
    var attScrollCardDataModel: AttDataModel?{
        
        didSet{
            
            guard let scrollCardModel = attScrollCardDataModel,
                  let acrollCardItemArr = scrollCardModel.itemList else {
                    
                    return
            }
            
            attScrollCardBarView.headerModel = scrollCardModel.header
            pageScrollView.addScrollImg(colItemArr: acrollCardItemArr)
            
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.gray
        contentView.addSubview(attScrollCardBarView)
        contentView.addSubview(pageScrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        attScrollCardBarView.frame = CGRect(x: 0, y:outerMargin, width: contentView.bounds.width, height: briedAndScrollCardBarH)
        pageScrollView.frame = CGRect(x: 0, y: attScrollCardBarView.frame.maxY, width: contentView.bounds.width, height: contentView.bounds.height - briedAndScrollCardBarH - outerMargin * 2)
    }
}
