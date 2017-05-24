//
//  VideoColCell.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/16.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class VideoColCell: UITableViewCell {

    var outerMargin: CGFloat = 5
    var coverImgViewH: CGFloat = heightFromWidth(width: UIScreen.main.bounds.width) + 20
    
    lazy var coverImgView: UIImageView = UIImageView()
    lazy var coverTitleLab: UILabel = UILabel()
    lazy var coverDesLab: UILabel = UILabel()
    lazy var normalView: NormalScrollView = NormalScrollView()
    
    var videoCollectionModel: VideoCollectionDataModel?{
        
        didSet{
            
            guard let vCModel = videoCollectionModel,
                  let colItemArr = vCModel.itemList,
                  let coverImgUrl = vCModel.header?["cover"] as? String else {
                    
                    return
            }
            
            //清空之前的数据，防止cell的重用出现数据混乱
            coverImgView.image = nil
            coverTitleLab.text = nil
            coverDesLab.text = nil
        
            coverImgView.up_setWebImage(urlString: coverImgUrl, placeholderImage: nil)
            let coverTitle = (vCModel.header?["title"] as? String) ?? ""
            if coverTitle != "" {
                
                let coverDes = (vCModel.header?["description"] as? String) ?? ""
                addSubViewTocoverImgView()
                coverTitleLab.text = coverTitle
                coverDesLab.text = coverDes
            }
    
            normalView.addScrollImg(colItemArr: colItemArr)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        contentView.addSubview(coverImgView)
        contentView.addSubview(normalView)
        
        coverImgView.contentMode = .scaleAspectFill
        coverImgView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImgView.frame = CGRect(x: 0, y:outerMargin, width: contentView.bounds.width, height: coverImgViewH)
        coverTitleLab.frame = CGRect(x: 0, y: coverImgView.bounds.height / 2, width: coverImgView.bounds.width, height: coverImgView.bounds.height / 4)
        coverDesLab.frame = CGRect(x: 0, y: coverTitleLab.frame.maxY, width: coverImgView.bounds.width, height: coverImgView.bounds.height / 4)
        
        normalView.frame = CGRect(x: 0, y: coverImgView.frame.maxY, width: contentView.bounds.width, height: contentView.bounds.height - coverImgView.frame.maxY - outerMargin)
    }
}

//MARK: 根据不同类型选择是否添加子控件
extension VideoColCell{
    
    func addSubViewTocoverImgView() -> () {
        
        coverTitleLab.textColor = UIColor.white
        coverTitleLab.font = UIFont.boldSystemFont(ofSize: 14)
        coverTitleLab.textAlignment = .center
        
        coverDesLab.textColor = UIColor.white
        coverDesLab.font = UIFont.systemFont(ofSize: 12)
        coverDesLab.textAlignment = .center
        
        coverImgView.addSubview(coverTitleLab)
        coverImgView.addSubview(coverDesLab)
    }
}
