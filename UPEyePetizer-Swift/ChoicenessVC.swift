//
//  ChoicenessVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/4/7.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

private let textHeaderCellID = "textHeaderCellID"
private let videoCellID = "videoCellID"
private let textFooterCellID = "textFooterCellID"
private let videoColCellID = "videoColCellID"

private var topBackViewH: CGFloat = choiCellH + 20
private var textHeaderFooterH: CGFloat = 44
private var videoColH: CGFloat = choiCellH * 2 + 40

class ChoicenessVC: BaseViewController {
    
    var tableViewOriginalInsets: UIEdgeInsets?
    
    lazy var topBackView: UIImageView = UIImageView(frame: CGRect(x: 0, y: -topBackViewH, width: UIScreen.main.bounds.width, height: topBackViewH))
    lazy var topIconView: UIImageView = UIImageView(frame: CGRect(x: (UIScreen.main.bounds.width - 136)/2, y: 20, width: 136, height: 124))
    lazy var shelterView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: topBackViewH))
    
    lazy var timeLab: UILabel = UILabel()
    lazy var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    var newVideoList = [ItemListModel]()
    var videoList = [ItemListModel]()

    var nextPageUrl: String?
    let timeInterval = Int(NSDate().timeIntervalSince1970 * 1000)
    let filePath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent("ChoicenessNewData.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadNewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override var refreshing: refreshState?{
        
        didSet{
            
            if refreshing == refreshState.StateNormal {
                
                super.superTableViewOriginalInsets = tableViewOriginalInsets
                
            }else if refreshing == refreshState.StateRefreshing{
    
                var insets = tableView.contentInset
                insets.bottom = footerViewOffsetY
                isPullup ? (tableView.contentInset = insets) : ()
                isPullup ?  loadMoreData() : ()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchClick() -> () {
        
        print("searchClick")
    }
    
}

//MARK: 请求网络数据
extension ChoicenessVC{
    
    func loadNewData() -> () {
        
        print("loadNewData --- ")
        //print(timeInterval)
        newVideoList.removeAll()
        videoList.removeAll()
        let params = ["date": "\(timeInterval)","num": "2","page": "0"]
        loadData(URLString: choiceUrlStr, parameters: params)
    }
    
    func loadMoreData() -> () {
        
        print("loadMoreData ---")
        loadData(URLString: nextPageUrl!, parameters: [:])
    }
    
    func loadData(URLString: String, parameters: [String: Any]) -> () {
        
        NetWorkManager.shared.request(method: .GET, URLString: URLString, parameters: parameters) { (json, isSuccess) in
            
            if isSuccess{
    
                //将新获取的数据存入沙盒，当网络请求失败时可以使用
                if !self.isPullup {
                    
                    let JsonDic = (json as? [String: AnyObject]) ?? [:]
                    guard let data = try? JSONSerialization.data(withJSONObject: JsonDic, options: .prettyPrinted) else{
                        
                        return
                    }
                    
                    (data as NSData).write(toFile: self.filePath, atomically: true)
                    //print(self.filePath)
                    //print("保存新数据到沙盒")
                }
                
                self.dicToJson(json: json!)
                
                
            }else {
                
                guard let dataSource = NSData(contentsOfFile: self.filePath),
                      let newJson = try? JSONSerialization.jsonObject(with: (dataSource as Data), options: .mutableContainers) as? [String: AnyObject]
                    else{
                        
                        return
                }
                
                self.dicToJson(json: newJson ?? [:])
                
                //_ = try? FileManager.default.removeItem(atPath: self.filePath)
            }
        }
    }
    
    func dicToJson(json: Any) -> () {
        
        let Cmodel = ChoicenessModel(dict: (json as! [String: Any]))
        nextPageUrl = Cmodel.nextPageUrl
        guard  let ItemArr = Cmodel.itemList else{
            
            return
        }
        
        for item in ItemArr {
            
            let Imodel = ItemListModel(dict: (item as! [String : Any]))
            if Imodel.type == "banner2" || Imodel.type == "horizontalScrollCard" {
                
                continue
            }else{
                
                if !isPullup {
                    
                    self.newVideoList.append(Imodel)
                }
                self.videoList.append(Imodel)
                
            }
        }
    
        //取出第一个Imodel
        
        if self.newVideoList.count != 0 {
            
            let firstImodel = self.newVideoList[0]
            //print(firstImodel.type!)
            if firstImodel.type == "textHeader"{
                
                self.newVideoList.remove(at: 0)
            }
            //print(self.videoList.count)
        }
        
        self.timeLab.isHidden = false
        self.loadingView.isHidden = true
        self.loadingView.stopAnimating()
        self.tableView.reloadData()
        self.endRefeshing()
        
    }
}

//MARK: 设置页面
extension ChoicenessVC{
    
    
    override func setUpNavBar() {
        
        super.setUpNavBar()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "bar_ic_search_white_44x44_") ?? UIImage(), target: self, action: #selector(searchClick))
    }
    
    override func setUpTableView() {
    
        super.setUpTableView()
        
        tableView.register(UINib(nibName: "textHeaderCell", bundle: nil), forCellReuseIdentifier: textHeaderCellID)
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: videoCellID)
        tableView.register(UINib(nibName: "textFooterCell", bundle: nil), forCellReuseIdentifier: textFooterCellID)
        tableView.register(VideoColCell.self, forCellReuseIdentifier: videoColCellID)
        
        tableView.contentInset = UIEdgeInsetsMake(topBackViewH, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        tableViewOriginalInsets = tableView.contentInset
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        topBackView.image = UIImage(named: "Home_header")
        topBackView.contentMode = .scaleAspectFill
        tableView.insertSubview(topBackView, belowSubview: tableView.subviews.first!)//UITableViewWrapperView
        
        topIconView.image = UIImage(named: "badge_selected_header_136x124_")
        topBackView.addSubview(topIconView)
        
        headerView.isHidden = true
        timeLab.textAlignment = NSTextAlignment.center
        timeLab.text = NSDate().getWeekAndMon()
        timeLab.font = UIFont.init(name: "Lobster 1.4", size: 13)
        timeLab.frame = CGRect(x: 0, y: topIconView.frame.maxY, width:topBackView.bounds.width , height: topBackView.bounds.height - topIconView.frame.maxY)
        topBackView.addSubview(timeLab)
        
        loadingView.sizeToFit()
        loadingView.center = timeLab.center
        topBackView.addSubview(loadingView)
        
        shelterView.backgroundColor = UIColor.black
        shelterView.alpha = 0.0
        topBackView.addSubview(shelterView)
    }
    
}

//MARK: 设置TableView相关
extension ChoicenessVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return isPullup ? videoList.count : newVideoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if videoList.count == 0{
            
            return UITableViewCell()
        }

        let ItemModel = videoList[indexPath.row]
        switch ItemModel.type! {
            
        case "textHeader":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: textHeaderCellID, for: indexPath) as! textHeaderCell
            let textHeaderModel = textHeaderDataModel(dict: (ItemModel.data ?? [:]))
            cell.textHeaderModel = textHeaderModel
            return cell
        case "video":
        
            let cell = tableView.dequeueReusableCell(withIdentifier: videoCellID, for: indexPath) as! VideoCell
            let videoModel = VideoDataModel(dict: (ItemModel.data ?? [:]))
            cell.videoModel = videoModel
            return cell
        case "textFooter":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: textFooterCellID, for: indexPath) as! textFooterCell
            let textFooterModel = textFooterDataModel(dict: (ItemModel.data ?? [:]))
            cell.textFooterModel = textFooterModel
            return cell
        case "videoCollectionWithCover","videoCollectionOfFollow","videoCollectionOfAuthorWithCover":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: videoColCellID, for: indexPath) as! VideoColCell
            let videoCollectionModel = VideoCollectionDataModel(dict: (ItemModel.data ?? [:]))
            cell.videoCollectionModel = videoCollectionModel
            cell.normalView.delegate = self
            return cell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let ItemModel = videoList[indexPath.row]
        
        switch ItemModel.type! {
            
        case "textHeader","textFooter":
            
            return textHeaderFooterH
        case "video":
            
            return choiCellH
        case "videoCollectionWithCover","videoCollectionOfFollow","videoCollectionOfAuthorWithCover":
            
            return videoColH
        default:
            break
        }
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contenOffsetY = scrollView.contentOffset.y
        if contenOffsetY < -topBackViewH {
            
            shelterView.alpha = 0.0
            navItem.rightBarButtonItem?.customView?.alpha = 1.0
            
            var rect = topBackView.frame
            rect.origin.y = contenOffsetY
            rect.size.height = -contenOffsetY
            topBackView.frame = rect
            
            var rectIcon = topIconView.frame
            rectIcon.origin.y = -(topBackViewH + contenOffsetY) + 20
            topIconView.frame = rectIcon
            
            var rectTimeLab = timeLab.frame
            rectTimeLab.origin.y = topIconView.frame.maxY
            timeLab.frame = rectTimeLab
            
            if contenOffsetY <= -(topBackViewH + headerViewOffserY) {
                
                timeLab.isHidden = true
                loadingView.isHidden = false
                loadingView.startAnimating()
            }
            
            var rectLoadingView = loadingView.frame
            rectLoadingView.origin.y = topIconView.frame.maxY + 10
            loadingView.frame = rectLoadingView
            
        }else{
            
            var rect = topBackView.frame
            rect.origin.y = contenOffsetY
            topBackView.frame = rect

            let shelterAlpha = contenOffsetY / topBackViewH
            shelterView.alpha = shelterAlpha + 1
            navItem.rightBarButtonItem?.customView?.alpha = -shelterAlpha
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if loadingView.isAnimating {
            
            loadNewData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath)
        if (cell?.isKind(of: VideoCell.self))! {
            
            if videoList.count == 0 {
                
                return
            }
            
            let ItemModel = videoList[indexPath.row]
            let videoModel = VideoDataModel(dict: (ItemModel.data ?? [:]))
            
            let videoPlayVC = VideoDetailVC()
            videoPlayVC.videoDataModel = videoModel
            navigationController?.present(videoPlayVC, animated: true, completion: nil)
        }
        
    }
    
}

//MARK: 设置NormalScrollView代理
extension ChoicenessVC: normalScrollViewDelegate{
    
    func scrollViewItemClick(videoItemModel: VideoDataModel) {
        
        let videoPlayVC = VideoDetailVC()
        videoPlayVC.videoDataModel = videoItemModel
        navigationController?.present(videoPlayVC, animated: true, completion: nil)
    }
    
}
