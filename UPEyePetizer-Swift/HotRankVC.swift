//
//  HotRankVC.swift
//  UPEyePetizer-Swift
//
//  Created by wust_LiTao on 2017/5/18.
//  Copyright © 2017年 Cookie. All rights reserved.
//

import UIKit

private let videoCellID = "videoCellID"

class HotRankVC: BaseViewController {

    //var selectedBtn: UIButton?
    //var line: UILabel?
    let barW: CGFloat = UIScreen.main.bounds.width
    let barH: CGFloat = 44
    var videoList = [ItemListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTopUI()
        loadPopularData(URLString: hotRankWeekUrlStr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: 请求网络数据
extension HotRankVC{
    
    func loadPopularData(URLString: String) -> () {
        
        videoList.removeAll()
        loadData(URLString: URLString, parameters: [:])
    }
    
    func loadData(URLString: String, parameters: [String: Any]) -> () {
        
        NetWorkManager.shared.request(method: .GET, URLString: URLString, parameters: parameters) { (json, isSuccess) in
         
            
            if isSuccess{
                
                let Cmodel = ChoicenessModel(dict: (json as! [String: Any]))
                guard  let ItemArr = Cmodel.itemList else{
                    
                    return
                }
                
                for item in ItemArr {
                    
                    let Imodel = ItemListModel(dict: (item as! [String : Any]))
                    self.videoList.append(Imodel)
                }
                
                self.tableView.reloadData()
            }
        }
    }
        
}

//MARK: 设置TableView相关
extension HotRankVC{
    
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

//MARK: 设置界面
extension HotRankVC{
    
    override func setUpNavBar() {
        super.setUpNavBar()
        
        let titleLab: UILabel = UILabel()
        titleLab.text = "排行榜"
        titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        titleLab.sizeToFit()
        navItem.titleView = titleLab
    }
    
    override func setUpTableView() {
        super.setUpTableView()
        
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: videoCellID)
        tableView.contentInset = UIEdgeInsetsMake(navigationBar.bounds.size.height + barH, 0, 0, 0)
        childNeedRefresh = false
        
        //隐藏刷新控件
        for item in tableView.subviews {
            
            if item.isKind(of: HeadAndFootRefreshView.self) {
                
                item.isHidden = true
            }
        }
    }
    
    /*
    func btnClick(btn: UIButton) -> () {
        
        if btn.tag == 0 {
            
            loadPopularData(URLString: hotRankWeekUrlStr)
            
        }else if btn.tag == 1{
            
            loadPopularData(URLString: hotRankMonthUrlStr)
        }else{
            
            loadPopularData(URLString: hotRankAllUrlStr)
        }
        
        selectedBtn?.isSelected = false
        selectedBtn = btn
        selectedBtn?.isSelected = true
        
        UIView.animate(withDuration: 0.2) { 
            
            self.line?.center.x = screenW / 6 + screenW / 3 * CGFloat(btn.tag)
        }
    }
    */
    
    func setTopUI() -> () {
        
        let array = ["周排行","月排行","总排行"]
        let barView: PageScrollBarView = PageScrollBarView(frame: CGRect(x: 0, y: self.navigationBar.bounds.height, width: barW, height: barH))
        barView.btnNameArrs = array
        barView.delegate = self
        view.addSubview(barView)

        
        /*
        let topView = UIView(frame: CGRect(x: 0, y: 64, width: screenW, height: 40))
        topView.backgroundColor = UIColor.white
        
        let array = ["周排行","月排行","总排行"]
        let btnW = screenW / 3
        let lineWidth = screenW / 6;
        for i in 0..<array.count{
            
            let btn = UIButton(type: .custom)
            btn.tag = i
            btn.frame = CGRect(x: CGFloat(i) * (btnW), y: 5, width: btnW, height: 30)
            btn.setTitle(array[i], for: .normal)
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.setTitleColor(UIColor.black, for: .selected)
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            topView.addSubview(btn)
            
            if i == 0 {
                
                btn.isSelected = true
                selectedBtn = btn
            } else{
                
                btn.isSelected = false
            }
        }
        
        line = UILabel(frame: CGRect(x: lineWidth / 2, y: 34, width: lineWidth, height: 0.5))
        line?.backgroundColor = UIColor.black
        topView.addSubview(line!)
        view.addSubview(topView)
        */
    }
}

//MARK: 设置PageScrollBarViewDelegate相关
extension HotRankVC: PageScrollBarViewDelegate{
    
    func btnClick(btn: UIButton) {
        
        if btn.tag == 0 {
            
            loadPopularData(URLString: hotRankWeekUrlStr)
            
        }else if btn.tag == 1{
            
            loadPopularData(URLString: hotRankMonthUrlStr)
        }else{
            
            loadPopularData(URLString: hotRankAllUrlStr)
        }

    }
}
