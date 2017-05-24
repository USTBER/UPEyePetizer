//
//  textFooterCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/16.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class textFooterCell: UITableViewCell {

    @IBOutlet weak var footerLab: UILabel?
    
    var textFooterModel: textFooterDataModel?{
        
        didSet{
            
            footerLab?.text = textFooterModel?.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
