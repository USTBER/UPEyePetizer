//
//  VideoDetailView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/13.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

class VideoDetailView: UIView {
    
    
    var videoDetailDataModel: VideoDataModel?{
        
        didSet{
            
            guard let model = videoDetailDataModel,
                  let title = model.title,
                  let category = model.category,
                  let descript = model.descriptionEditor,
                  let consumption = model.consumption,
                  let collectionCount = consumption["collectionCount"],
                  let shareCount = consumption["shareCount"],
                  let replyCount = consumption["replyCount"] else {
                return
            }
            
            titleLab.text = title
            categoryTimeLab.text = String().categoryAndTime(category: category, duration: model.duration)
            
            
            if descript == "" {
                
                contenLab.text = descript
            }else{
            
                contenLab.text = descript
            }
            
            collectionBtn.setTitle("\(collectionCount)", for: .normal)
            shareCountBtn.setTitle("\(shareCount)", for: .normal)
            replyCountBtn.setTitle("\(replyCount)", for: .normal)
            
            print("didSet")
            layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var categoryTimeLab: UILabel!
    
    @IBOutlet weak var contenLab: UILabel!
    
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var shareCountBtn: UIButton!
    @IBOutlet weak var replyCountBtn: UIButton!
    
    @IBOutlet weak var toolBarView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")

    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        print("layoutIfNeeded")
        
        let contentLabY = contenLab.frame.maxY
        let toolBarViewH = toolBarView.bounds.height
        //print("\(contentLabY) --- \(toolBarViewH)")
        
        frame.size.height = contentLabY + toolBarViewH + 10
    }
}

extension VideoDetailView{
    
    class func loadVideoDetailView() -> VideoDetailView {
        
        let videoDetailView = Bundle.main.loadNibNamed("VideoDetailView", owner: nil, options: nil)?.first as! VideoDetailView
        videoDetailView.frame.size.width = UIScreen.main.bounds.width
        
        return videoDetailView
    }
}
