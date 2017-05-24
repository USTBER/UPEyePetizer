//
//  VideoCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/16.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var categoryTimeLab: UILabel!
    
    var videoModel:VideoDataModel?{
        
        didSet{
            
            guard let vModel = videoModel,
                  let title = vModel.title,
                  let category = vModel.category,
                  let showImgUrl = vModel.cover?["detail"] as? String else {
                
                return
            }
            
            backImgView.up_setWebImage(urlString: showImgUrl, placeholderImage: nil)
            titleLab.text = title
            categoryTimeLab.text = String().categoryAndTime(category: category, duration: vModel.duration)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
}
