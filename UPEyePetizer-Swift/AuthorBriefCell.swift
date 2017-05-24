//
//  AuthorBriefCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/26.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class AuthorBriefCell: UITableViewCell {

    lazy var normalView: NormalScrollView = NormalScrollView()
    
    
    var authorBriefDataModel: AttDataModel? {
        
        didSet{
            
            guard let authorBriefDataModel = authorBriefDataModel,
                  let authorBriefItemArr = authorBriefDataModel.itemList else {
                    
                    return
            }
            
            normalView.addScrollImg(colItemArr: authorBriefItemArr)            
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(normalView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        normalView.frame = contentView.bounds
    }
    
}
