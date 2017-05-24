//
//  ChooseHotCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/19.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class ChooseHotCell: UITableViewCell {

    @IBOutlet weak var showImgView: UIImageView!
    
    var ImgModel: ItemListModel?{
        
        didSet{
            
            guard let model = ImgModel,
                  let imgData = model.data,
                  let imageUrlStr = imgData["image"] as? String else {
                
                return
            }
            
            showImgView.up_setWebImage(urlString: imageUrlStr, placeholderImage: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
