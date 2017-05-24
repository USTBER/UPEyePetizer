//
//  VideoDetailVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/12.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit
import AVFoundation

class VideoDetailVC: UIViewController {

    var barView: UIView?
    var videoPlayView: VideoPlayView?
    var videoListView: UITableView?
    var videoHeadView: VideoDetailView?
    var videoEndView: EndView?
    
    var videoDataModel: VideoDataModel?
    
    var playerItem: AVPlayerItem?
    var avplayer: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    var vcIsPortrait: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func orientationChange(notify: Notification) -> () {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    override var shouldAutorotate: Bool{
        
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        
        return .portrait
    }
    
    //监听视频播放状态
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let playerItem = object as? AVPlayerItem else {
            
            return
        }
        
        if keyPath == "loadedTimeRanges"{
           
            //视频的进度缓冲
            guard let loadedTimeRanges = avplayer?.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {
                
                return
            }
            let timeRange = first.timeRangeValue
            let startSeconds = CMTimeGetSeconds(timeRange.start)
            let durationSecound = CMTimeGetSeconds(timeRange.duration)
            let loadedTime = startSeconds + durationSecound

            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let percent = loadedTime/totalTime
            //print("缓冲: \(percent)")
            videoPlayView?.progressView.progress = Float(percent)
            
        }else if keyPath == "status"{
           
            if playerItem.status == AVPlayerItemStatus.readyToPlay{
                
                print("readyToPlay-----")
                avplayer?.play()
                monitoringPlayVideo(playerItem: avplayer?.currentItem)
                
            }else{
                print("加载异常")
            }
        }
    }
    
    //监听播放状态
    func monitoringPlayVideo(playerItem: AVPlayerItem?) -> () {
        
        avplayer?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0 / 60.0, Int32(NSEC_PER_SEC)), queue: nil, using: { [weak self] (time) in
            
            guard let playerItem = playerItem else{

                return
            }
            
            let currentTime = CMTimeGetSeconds(playerItem.currentTime())
            let totalTime   = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
            self?.videoPlayView?.slider.value = Float(currentTime / totalTime)
            
            let timeStr = "\((self?.formatPlayTime(secounds: currentTime) ?? "")) / \((self?.formatPlayTime(secounds: totalTime) ?? ""))"
            self?.videoPlayView?.timeLab.text = timeStr
            
        })
    }
    
    func formatPlayTime(secounds:TimeInterval)-> String{
       
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }

    deinit{
        
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem?.removeObserver(self, forKeyPath: "status")
    }

}

//MARK: 设置页面
extension VideoDetailVC{
    
    func popVC() -> () {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func likeClick() -> () {
        
        print("like")
    }
    
    func shareClick() -> () {
        
        print("share")
    }
    
    func otherClick() -> () {
        
        print("other")
    }
    
    //滑动滑块,指定播放位置
    func changeValue(slider: UISlider) {
        
        avplayer?.pause()
        if avplayer?.status == AVPlayerStatus.readyToPlay {
            
            let duration = slider.value * Float(CMTimeGetSeconds((avplayer?.currentItem?.duration)!))
            let seekTime = CMTimeMake(Int64(duration), 1)
            avplayer?.seek(to: seekTime, completionHandler: { (finish) in
                
                if finish{
                
                    self.avplayer?.play()
                }
            })
        }
    }
    
    func playBtnClick(playBtn: UIButton) -> () {
        
        playBtn.isSelected = !playBtn.isSelected
        if playBtn.isSelected {
            
            avplayer?.pause()
        }else{
            
            avplayer?.play()
        }
        
    }
    
    func showControlView(gesture: UITapGestureRecognizer) -> () {
        
        let platView = gesture.view as? VideoPlayView
        let controlView = platView?.controlView
        
        controlView?.isHidden = !(controlView?.isHidden)!
    }
    
    
    func setUpUI() {
        
        setUpNavView()
        setUpVidelPlayView()
        setUpTableView()
    }
    
    func setUpNavView() -> () {
        
        let barViewW: CGFloat = UIScreen.main.bounds.width
        let barViewH: CGFloat = 54
        let btnWH: CGFloat = 44
        let margin: CGFloat = 8
        let btnY: CGFloat = (barViewH - btnWH) / 2
        
        barView = UIView(frame: CGRect(x: 0, y: 0, width: barViewW, height: barViewH))
        barView?.backgroundColor = UIColor(patternImage: UIImage())
        view.addSubview(barView!)
        
        let backBtn = addBarBtn(btnImg: UIImage(named: "ic_video_dismiss_30x30_"), frame: CGRect(x: margin, y: btnY, width: btnWH, height: btnWH))
        backBtn.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        barView?.addSubview(backBtn)
        
        let otherBtn = addBarBtn(btnImg: UIImage(named: "ic_menu_more_white_44x44_"), frame: CGRect(x: barViewW - margin - btnWH, y: btnY, width: btnWH, height: btnWH))
        otherBtn.addTarget(self, action: #selector(otherClick), for: .touchUpInside)
        barView?.addSubview(otherBtn)
        
        
        let shareBtn = addBarBtn(btnImg: UIImage(named: "ic_video_share_20x20_"), frame: CGRect(x: barViewW - (margin + btnWH) * 2, y: btnY, width: btnWH, height: btnWH))
        shareBtn.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        barView?.addSubview(shareBtn)
        
        let likeBtn = addBarBtn(btnImg: UIImage(named: "ic_video_like_20x20_"), frame: CGRect(x: barViewW - (margin + btnWH) * 3, y: btnY, width: btnWH, height: btnWH))
        likeBtn.addTarget(self, action: #selector(likeClick), for: .touchUpInside)
        barView?.addSubview(likeBtn)

    }
    
    func addBarBtn(btnImg: UIImage?, frame: CGRect) -> (UIButton) {
        
        let btn = UIButton(type: .custom)
        btn.setImage(btnImg, for: .normal)
        btn.frame = frame
        return btn
    }
    
    func setUpVidelPlayView() -> () {
        
        videoPlayView = VideoPlayView(frame: CGRect(x: 0, y: 0, width: screenW, height: (screenH / 3)))
        videoPlayView?.backgroundColor = UIColor.black
        videoPlayView?.delagete = self
        view.insertSubview(videoPlayView!, belowSubview: barView!)
        
        guard let urlStr = videoDataModel?.playUrl,
              let url = URL(string: urlStr),
              let titleStr = videoDataModel?.title else {
            
            return
        }
        
        playerItem = AVPlayerItem(url: url)
        //监听缓冲进度改变&&监听状态改变
        playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        
        avplayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: avplayer)
        playerLayer?.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer?.contentsScale = UIScreen.main.scale
        videoPlayView?.playerLayer = playerLayer
        videoPlayView?.layer.insertSublayer(playerLayer!, at: 0)

        videoPlayView?.slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        videoPlayView?.playBtn.addTarget(self, action: #selector(playBtnClick), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showControlView))
        videoPlayView?.addGestureRecognizer(tapGesture)
        videoPlayView?.titleLab.text = titleStr
    }
    
    func setUpTableView() {
    
        videoListView = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(videoListView!, belowSubview: videoPlayView!)
        videoListView?.contentInset = UIEdgeInsetsMake((videoPlayView?.bounds.height)!, 0, 0, 0)
        videoListView?.rowHeight = 88
        videoListView?.backgroundColor = UIColor.darkGray
        
        videoHeadView = VideoDetailView.loadVideoDetailView()
        videoListView?.tableHeaderView = videoHeadView
        videoHeadView?.videoDetailDataModel = videoDataModel
        
        videoEndView = EndView.loadEndView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH / 2))
        videoListView?.tableFooterView = videoEndView
    }
}

//MARK: 设置VideoPlayViewDelegatev代理
extension VideoDetailVC: VideoPlayViewDelegate{
    
    func showLandscapeLeft(anchorPointX: CGFloat) -> () {
        
        barView?.isHidden = true
        videoPlayView?.layer.anchorPoint = CGPoint(x: anchorPointX / 10, y: 0.5)
        videoPlayView?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        videoPlayView?.bounds = CGRect(x: 0, y: 0, width: screenH, height: screenW)
    }
    
    func showPortrait() -> () {
        
        barView?.isHidden = false
        videoPlayView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        videoPlayView?.transform = CGAffineTransform.identity
        videoPlayView?.bounds = CGRect(x: 0, y: 0, width: screenW, height: (screenH / 3))
    }
    
    func scaleBtnClick(isPortrait: Bool) {
        
        //isPortrait ? (print("竖屏")) : (print("横屏"))
        
        let videoPalyViewW: CGFloat = (videoPlayView?.bounds.width)!
        let videoPalyViewH: CGFloat = (videoPlayView?.bounds.height)!
        let anchorPointX = videoPalyViewW / videoPalyViewH
        
        isPortrait ? (showPortrait()) : (showLandscapeLeft(anchorPointX: anchorPointX))
    }
}


