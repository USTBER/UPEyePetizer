//
//  VideoPlayView.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/16.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoPlayViewDelegate: NSObjectProtocol {
    
    func scaleBtnClick(isPortrait: Bool) -> ()
}

private let margin: CGFloat = 5
class VideoPlayView: UIView {

    weak var delagete: VideoPlayViewDelegate?
    
    var playerLayer:AVPlayerLayer?
    lazy var controlView: UIView = UIView()
    lazy var slider: UISlider = UISlider()
    lazy var progressView: UIProgressView = UIProgressView()//缓存进度
    lazy var playBtn: UIButton = UIButton(type: UIButtonType.custom)
    lazy var timeLab: UILabel = UILabel()
    lazy var scaleBtn: UIButton = UIButton(type: .custom)
    lazy var titleLab: UILabel = UILabel()
    var isPortrait: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        controlView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        controlView.isHidden = true
        addSubview(controlView)
        
        controlView.addSubview(slider)
        controlView.insertSubview(progressView, belowSubview: slider)
        
        controlView.addSubview(titleLab)
        controlView.addSubview(playBtn)
        controlView.addSubview(timeLab)
        controlView.addSubview(scaleBtn)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        controlView.frame = bounds
        playerLayer?.frame = bounds
        
        titleLab.frame = CGRect(x: 10, y: 10, width: bounds.width - 20, height: 34)
        
        slider.frame = CGRect(x: margin, y: bounds.height - 20, width: bounds.width - 2 * margin, height: 15)
        progressView.frame = CGRect(x: margin, y: slider.center.y, width: bounds.width - 2 * margin, height: 15)
        
        playBtn.frame = CGRect(x: (bounds.width - playBtn.bounds.width) / 2, y: (bounds.height - playBtn.bounds.height) / 2, width: playBtn.bounds.width, height: playBtn.bounds.height)
        timeLab.frame = CGRect(x: 0, y: playBtn.frame.maxY, width: bounds.width, height: 20)
        scaleBtn.frame = CGRect(x: bounds.width - scaleBtn.bounds.width, y: bounds.height - scaleBtn.bounds.height, width: scaleBtn.bounds.width, height: scaleBtn.bounds.height)
    }
}

extension VideoPlayView{
    
    func scaleScreen(btn: UIButton) -> () {
        
        if btn.isSelected {
            
            titleLab.isHidden = true
            isPortrait = true
        }else{
            
            titleLab.isHidden = false
            isPortrait = false
        }
        btn.isSelected = !btn.isSelected
        delagete?.scaleBtnClick(isPortrait: isPortrait)
        layoutSubviews()
    }
    
    func setUpUI() -> () {
        
        titleLab.textColor = UIColor.white
        titleLab.textAlignment = .left
        titleLab.font = UIFont.systemFont(ofSize: 16)
        titleLab.isHidden = true
        
        playBtn.setImage(UIImage(named: "action_player_play_80x80_"), for: .normal)
        playBtn.setImage(UIImage(named: "action_player_pause_80x80_"), for: .selected)
        playBtn.sizeToFit()
        
        timeLab.textColor = UIColor.white
        timeLab.textAlignment = .center
        timeLab.font = UIFont.systemFont(ofSize: 14)
        timeLab.text = "00:00/00:00"
        
        slider.maximumValue = 1
        slider.minimumValue = 0
        slider.value = 0
        slider.maximumTrackTintColor = UIColor.clear
        slider.minimumTrackTintColor = UIColor.white
        slider.setThumbImage(UIImage(named:"slider_thumb"), for: UIControlState())

        
        progressView.progressTintColor = UIColor.lightGray
        progressView.trackTintColor = UIColor.clear
        progressView.progress = 0
        
        scaleBtn.setImage(UIImage(named: "Action_PIP_44x44_"), for: .normal)
        scaleBtn.showsTouchWhenHighlighted = true
        scaleBtn.sizeToFit()
        scaleBtn.addTarget(self, action: #selector(scaleScreen), for: .touchUpInside)
    }
    
}

