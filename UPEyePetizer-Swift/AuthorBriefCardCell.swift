//
//  AuthorBriefCardCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/26.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class AuthorBriefCardCell: UITableViewCell {

    lazy var attBriefBarView: AttBriefBarView = AttBriefBarView.loadAttBriefBarView()
    
    var authorBriefData: [String: Any]?{
        
        didSet{
            
            attBriefBarView.headerModel = authorBriefData
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(attBriefBarView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        attBriefBarView.frame = contentView.bounds
        
    }
}
