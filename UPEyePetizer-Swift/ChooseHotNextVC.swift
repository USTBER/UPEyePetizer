//
//  ChooseHotNextVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/21.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

private let videoCellID = "videoCellID"

class ChooseHotNextVC: BaseViewController {

    let barW: CGFloat = UIScreen.main.bounds.width
    let barH: CGFloat = 44
    var videoList = [ItemListModel]()
    var hotIdKey: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let urlStr = "\(hotStrOne)\(hotIdKey)\(hotStrTwo)"
        loadHotNextData(URLString: urlStr)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: 请求网络数据
extension ChooseHotNextVC{
    
    func loadHotNextData(URLString: String) -> () {
        
        videoList.removeAll()
        loadData(URLString: URLString, parameters: [:])
    }
    
    func loadData(URLString: String, parameters: [String: Any]) -> () {
        
        NetWorkManager.shared.request(method: .GET, URLString: URLString, parameters: parameters) { (json, isSuccess) in
            
            
            if isSuccess{
                
                let Hotmodel = ChoicenessModel(dict: (json as! [String: Any]))
                guard  let ItemArr = Hotmodel.itemList else{
                    
                    return
                }
                
                for item in ItemArr {
                    
                    let HotDetailmodel = ItemListModel(dict: (item as! [String : Any]))
                    self.videoList.append(HotDetailmodel)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: 设置界面
extension ChooseHotNextVC{
    
    override func setUpNavBar() {
        super.setUpNavBar()
        
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: videoCellID)
        tableView.contentInset = UIEdgeInsetsMake(navigationBar.bounds.size.height, 0, 0, 0)
        childNeedRefresh = false
        
        //隐藏刷新控件
        for item in tableView.subviews {
            
            if item.isKind(of: HeadAndFootRefreshView.self) {
                
                item.isHidden = true
            }
        }
        
        tableView.tableFooterView = ChooseNextFooterView.loadChooseNextFooterView()
    }
    
}

//MARK: 设置TableView相关
extension ChooseHotNextVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ItemModel = videoList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: videoCellID, for: indexPath) as! VideoCell
        let videoModel = VideoDataModel(dict: (ItemModel.data ?? [:]))
        cell.videoModel = videoModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return choiCellH
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ItemModel = videoList[indexPath.row]
        let videoModel = VideoDataModel(dict: (ItemModel.data ?? [:]))
        
        let videoPlayVC = VideoDetailVC()
        videoPlayVC.videoDataModel = videoModel
        navigationController?.present(videoPlayVC, animated: true, completion: nil)
    }
    
}
