//
//  AttentionBriefCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class AttentionBriefCell: UITableViewCell {

    lazy var attBriefBarView: AttBriefBarView = AttBriefBarView.loadAttBriefBarView()
    lazy var normalView: NormalScrollView = NormalScrollView()
    
    var attBriefDataModel: AttDataModel?{
        
        didSet{
            
            guard let briefModel = attBriefDataModel,
                  let briefItemArr = briefModel.itemList else {
                    
                    return
            }
        
            attBriefBarView.headerModel = briefModel.header
            normalView.addScrollImg(colItemArr: briefItemArr)
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(attBriefBarView)
        contentView.addSubview(normalView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        attBriefBarView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: briedAndScrollCardBarH)
        normalView.frame = CGRect(x: 0, y: attBriefBarView.frame.maxY, width: contentView.bounds.width, height: contentView.bounds.height - briedAndScrollCardBarH)
    }
}
