//
//  textHeaderCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/16.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class textHeaderCell: UITableViewCell {

    @IBOutlet weak var timeLab: UILabel!
    
    var textHeaderModel:textHeaderDataModel?{
        
        didSet{
            
            timeLab.text = textHeaderModel?.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        timeLab.font = UIFont.init(name: "Lobster 1.4", size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
